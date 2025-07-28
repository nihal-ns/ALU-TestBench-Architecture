
`include "defines.sv"

class monitor;
	transaction trans;
	mailbox #(transaction) mon2scb;
	virtual intf.MONITOR vif;

	function new(mailbox #(transaction) mon2scb, virtual intf.MONITOR vif);
		this.mon2scb = mon2scb;
		this.vif = vif;
	endfunction

	task start();
		repeat(2) @(vif.mon_cb);  // changed to 1
		for(int i=0; i<`no_trans; i++) begin
			trans = new;
			repeat(3) @(vif.mon_cb) // changed 2
			if(vif.mon_cb.MODE && vif.mon_cb.CMD ==9) 
				repeat(1)@(vif.mon_cb);
			begin
				trans.RES = vif.mon_cb.RES;
				trans.OFLOW = vif.mon_cb.OFLOW;
				trans.COUT = vif.mon_cb.COUT;
				trans.E = vif.mon_cb.E;
				trans.G = vif.mon_cb.G;
				trans.L = vif.mon_cb.L;
				trans.ERR = vif.mon_cb.ERR;
				trans.MODE = vif.mon_cb.MODE;
				trans.CMD = vif.mon_cb.CMD;
				trans.OPA = vif.mon_cb.OPA;
				trans.OPB = vif.mon_cb.OPB;
			end
			$display("\n-----------------------------|| MONITOR ||--------------------------------------");
			if(trans.MODE)
				$display("%0t || MONITOR Arithmetic: \n||| cmd:%0d | A:%0d | B:%0d ||| \nresult:%0d |overflow:%0b |cout:%0b |EGL:%0b%0b%0b |error:%b",$time,trans.CMD,trans.OPA,trans.OPB, trans.RES, trans.OFLOW, trans.COUT, trans.E, trans.G, trans.L, trans.ERR);
			else
				$display("%0t || MONITOR Logical \n||| cmd:%0d | A:%0b | B:%0b ||| \nresult:%0b |overflow:%0b |cout:%0b |EGL:%0b%0b%0b |error:%0b",$time,trans.CMD,trans.OPA,trans.OPB, trans.RES, trans.OFLOW, trans.COUT, trans.E, trans.G, trans.L, trans.ERR);
			mon2scb.put(trans);
			//repeat(2)@(vif.mon_cb); 
		end
	endtask
endclass


