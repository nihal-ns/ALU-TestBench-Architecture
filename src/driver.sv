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
