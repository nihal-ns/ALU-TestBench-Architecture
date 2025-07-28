/* `include "defines.sv" */
/* `define drv_if vif.drv_cb */ 

/* class driver; */
/* 	transaction trans; */
/* 	mailbox #(transaction) gen2drv; */
/* 	mailbox #(transaction) drv2ref; */

/* 	virtual intf.DRIVER vif; */

/* 	function new(mailbox #(transaction) gen2drv, */
/* 							 mailbox #(transaction) drv2ref, */
/* 							 virtual intf.DRIVER vif); */

/* 		this.gen2drv = gen2drv; */
/* 		this.drv2ref = drv2ref; */
/* 		this.vif = vif; */
/* 	endfunction */	

/* 	task start(); */
/* 		repeat(3)@(drv_if);  // define */
/* 			for(int i=0;i<`no_trans;i++) begin */
/* 				trans = new; */
/* 				gen2drv.get(trans); */
/* 				if(vif.drv_cb.reset == 1) */
/* 					repeat(1)@(drv_if) // define */
/* 					begin */
/* 						drv_if.OPA <= {(`WIDTH-1){1'b0}}; */
/* 						drv_if.OPB <= {(`WIDTH-1){1'b0}}; */
/* 						drv_if.MODE <= 0; */
/* 						drv_if.CMD <=	{`CMD_WIDTH{1'b0}}; */
/* 						drv_if.CIN <= 0; */
/* 						drv_if.CE <= 0; */
/* 						drv_if.INP_VALID <= 2'b0; */
/* 						drv2ref.put(trans); */
/* 						repeat(1)@(drv_if); */
/* 							$display("Driver reset: M:%0b |cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d",trans.MODE, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB); */
/* 					end */
/* 				else */
/* 					repeat(1)@(drv_if) */
/* 					begin */
/* 						drv_if.OPA <= trans.OPA; */
/* 						drv_if.OPB <= trans.OPB; */
/* 						drv_if.MODE <= trans.MODE; */
/* 						drv_if.CMD <=	trans.CMD; */
/* 						drv_if.CIN <= trans.CIN; */
/* 						drv_if.CE <= trans.CE; */
/* 						drv_if.INP_VALID <= trans.INP_VALID; */
/* 						repeat(1)@(drv_if); */
/* 							if(trans.MODE) */
/* 								$display("Driver reset: M:arithmetic |cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d", trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB); */
/* 							else */	
/* 								$display("Driver reset: M:logical |cmd:%0d |valid:%0b |OPA:%0b |OPB:%0b", trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB); */
/* 						drv2ref.put(trans); */
/* 					end */
/* 			end */
/* 	endtask */	
/* endclass */	

`include "defines.sv"
/* // `define drv_if vif.drv_cb // <-- REMOVE THIS */


/* ////////////////////////////// */
class driver;
	transaction trans;
	mailbox #(transaction) gen2drv;
	mailbox #(transaction) drv2ref;
	virtual intf.DRIVER vif;

	function new(mailbox #(transaction) gen2drv, mailbox #(transaction) drv2ref, virtual intf.DRIVER vif);
		this.gen2drv = gen2drv;
		this.drv2ref = drv2ref;
		this.vif = vif;
	endfunction

	task start();
		repeat(2) @(vif.drv_cb); // <-- changed to 1
		for(int i=0; i<`no_trans; i++) begin
			trans = new;
			gen2drv.get(trans);
			if(vif.drv_cb.rst == 1) // <-- FIX: Use vif directly and signal is 'rst'
				repeat(1) @(vif.drv_cb)
				begin
					vif.drv_cb.OPA <= '0;
					vif.drv_cb.OPB <= '0;
					vif.drv_cb.MODE <= 0;
					vif.drv_cb.CMD <= '0;
					vif.drv_cb.CIN <= 0;
					vif.drv_cb.CE <= 0;
					vif.drv_cb.INP_VALID <= 2'b0;
					drv2ref.put(trans);
					repeat(1) @(vif.drv_cb);
					$display("%0t || Driver reset: M:%0b |cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d",$time,trans.MODE, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB);
				end
			else
				/* repeat(1) @(vif.drv_cb) */
				begin
					repeat(1) @(vif.drv_cb);
					vif.drv_cb.OPA <= trans.OPA;
					vif.drv_cb.OPB <= trans.OPB;
					vif.drv_cb.MODE <= trans.MODE;
					vif.drv_cb.CMD <= trans.CMD;
					vif.drv_cb.CIN <= trans.CIN;
					vif.drv_cb.CE <= trans.CE;
					vif.drv_cb.INP_VALID <= trans.INP_VALID;
					repeat(1) @(vif.drv_cb);
					$display("\n---------------------------------|| DRIVER ||------------------------------------\n");
					if(trans.MODE)
						$display("%0t || Driver: Arithmetic \n|||cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d",$time, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB);
					else
						$display("%0t || Driver: Logical \n|||cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d",$time, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB);
					drv2ref.put(trans);
					repeat(1)@(vif.drv_cb);  // this is extra
					if(trans.MODE && trans.CMD==9)	begin
						repeat(3)@(vif.drv_cb);  // this is extra
						$display("Entered");
					end
				end
		end
	endtask
endclass


//////////////
//
// ALU Testbench/driver.sv
// ALU Testbench/driver.sv
/* `include "defines.sv" */

/* class driver; */
/*     transaction trans; */
/*     int cycles_delay; */
    
/*     mailbox #(transaction) gen2drv; */
/*     mailbox #(transaction) drv2ref; */
/*     virtual intf.DRIVER vif; */

/*     function new(mailbox #(transaction) gen2drv, mailbox #(transaction) drv2ref, virtual intf.DRIVER vif); */
/*         this.gen2drv = gen2drv; */
/*         this.drv2ref = drv2ref; */
/*         this.vif = vif; */
/*     endfunction */

/*     task start(); */
/*         // Wait for the first clock edge to be safe */
/*         @(vif.drv_cb); */
        
/*         // This loop now correctly corresponds to one full ALU operation */
/*         for (int i = 0; i < `no_trans; i++) begin */
/*             gen2drv.get(trans); */
/*             $display("Driver: Received transaction from generator with INP_VALID = %b.", trans.INP_VALID); */

/*             // Drive common signals */
/*             @(vif.drv_cb); */
/*             vif.drv_cb.CE   <= trans.CE; */
/*             vif.drv_cb.CIN  <= trans.CIN; */
/*             vif.drv_cb.CMD  <= trans.CMD; */
/*             vif.drv_cb.MODE <= trans.MODE; */
            
            

/* 						// --- Corrected Logic to Handle DUT Timing --- */
/*             case (trans.INP_VALID) */
/*                 2'b11: begin */
/*                     $display("Driver: Driving FULL transaction."); */
/*                     vif.drv_cb.OPA <= trans.OPA; */
/*                     vif.drv_cb.OPB <= trans.OPB; */
/*                     vif.drv_cb.INP_VALID <= 2'b11; */
/*                 end */
                
/*                 2'b01: begin */
/*                     $display("Driver: Driving SPLIT transaction (Part 1: OPA)."); */
/*                     vif.drv_cb.OPA <= trans.OPA; */
/*                     vif.drv_cb.INP_VALID <= 2'b01; */

/*                     cycles_delay = $urandom_range(1, 15); */
/*                     repeat(cycles_delay) @(vif.drv_cb); */
                    
/*                     $display("Driver: Driving SPLIT transaction (Part 2: OPB) after %0d cycles.", cycles_delay); */
/*                     vif.drv_cb.OPB <= trans.OPB; // Use OPB from the SAME transaction */
/*                     vif.drv_cb.INP_VALID <= 2'b10; */
/*                 end */
                
/*                 2'b10: begin */
/*                     $display("Driver: Driving SPLIT transaction (Part 1: OPB)."); */
/*                     vif.drv_cb.OPB <= trans.OPB; */
/*                     vif.drv_cb.INP_VALID <= 2'b10; */

/*                     cycles_delay = $urandom_range(1, 15); */
/*                     repeat(cycles_delay) @(vif.drv_cb); */

/*                     $display("Driver: Driving SPLIT transaction (Part 2: OPA) after %0d cycles.", cycles_delay); */
/*                     vif.drv_cb.OPA <= trans.OPA; // Use OPA from the SAME transaction */
/*                     vif.drv_cb.INP_VALID <= 2'b01; */
/*                 end */
/*                 default: $display("Driver: INP_VALID is 00, driving nothing."); */
/*             endcase */
            
/*             // Wait one cycle for the last part of the transaction to be seen */
/*             @(vif.drv_cb); */
/*             // De-assert INP_VALID to signal the end of the operation */
/*             vif.drv_cb.INP_VALID <= 2'b00; */

/*             // Send the single, complete transaction to the reference model */
/*             drv2ref.put(trans); */
/*         end */
/*     endtask */
/* endclass */
