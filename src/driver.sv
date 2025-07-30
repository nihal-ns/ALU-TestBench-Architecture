`include "defines.sv"

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
			if(vif.drv_cb.rst == 1) 
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

				if(((trans.MODE) && (trans.CMD < 4 || trans.CMD > 7) && (trans.CMD <11)) || ((!trans.MODE) && (trans.CMD < 6 || trans.CMD > 11 ) && (trans.CMD < 14)) && trans.INP_VALID != 2'b11) begin

					if(trans.INP_VALID == 1 || trans.INP_VALID == 2) begin

						if(trans.INP_VALID == 1)
							trans.OPA.rand_mode(0);
						else
							trans.OPB.rand_mode(0); 

						for(int i=0;i<16;i++) begin
							repeat(1)@(vif.drv_cb);
							$display("\n %0t |-----| Driver count: %0d |-----| \n",$time,i);
							if(i==15) begin
								trans.MODE.rand_mode(1);
								trans.CMD.rand_mode(1);
								if(trans.INP_VALID == 2'b11)
									break;
							end	
							else begin 
								trans.CMD.rand_mode(0);
								trans.MODE.rand_mode(0);
								trans.CIN.rand_mode(0); 
								trans.CE.rand_mode(0); 
								void'(trans.randomize);
								if(trans.INP_VALID == 2'b11)
									break;
							end
						end
					end
				end

				/* else begin */ 
				vif.drv_cb.OPA <= trans.OPA;
				vif.drv_cb.OPB <= trans.OPB;
				vif.drv_cb.MODE <= trans.MODE;
				vif.drv_cb.CMD <= trans.CMD;
				vif.drv_cb.CIN <= trans.CIN;
				vif.drv_cb.CE <= trans.CE;
				vif.drv_cb.INP_VALID <= trans.INP_VALID;
				/* end // for if count; */
				repeat(1) @(vif.drv_cb);
				/* $display("\n-------------------------------------|| DRIVER ||----------------------------------------\n"); */
				if(trans.MODE)
					$display("%0t || Driver: Arithmetic \t|||cmd:%0d |valid:%0b |OPA:%0d |OPB:%0d",$time, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB);
				else
					$display("%0t || Driver: Logical    \t|||cmd:%0d |valid:%0b |OPA:%0b |OPB:%0b",$time, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB);
				drv2ref.put(trans);
				repeat(1)@(vif.drv_cb);  // this is extra
				if(trans.MODE && trans.CMD==9)	begin
					repeat(3)@(vif.drv_cb);  // this is extra
				end
				/* end // for loop count */	
			end
		end
	endtask
endclass

