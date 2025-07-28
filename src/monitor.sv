/* `include "defines.sv" */
/* `define mon_if vif.mon_cb */

/* class monitor; */
/* 	transaction trans; */
/* 	mailbox #(transaction) mon2scb; */
/* 	virtual intf.MONITOR vif; */
	
/* 	function new(mailbox #(transaction) mon2scb, virtual intf.MONITOR vif); */
/* 		this.mon2scb = mon2scb; */
/* 		this.vif = vif; */
/* 	endfunction */	

/* 	task start(); */
/* 		repeat(4) @(mon_if); */ 
/*     for(int i=0;i<`no_trans;i++) */
/*       begin */
/*         trans = new; */
/*         repeat(1) @(mon_if) */
/* 					begin */
/* 						trans.RES <= mon_if.RES; */
/* 						trans.OFLOW <= mon_if.OFLOW; */
/* 						trans.COUT <= mon_if.COUT; */
/* 						trans.E <= mon_if.E; */
/* 						trans.G <= mon_if.G; */
/* 						trans.L <= mon_if.L; */
/* 						trans.ERR <= mon_if.ERR; */
/*           end */
/*         $display("MONITOR signals: result:%0d |overflow:%0b |cout:%0b |EGL:%0b%0b%0b |error:%b",trans.RES, trans.OFLOW, trans.COUT, trans.E, trans.G, trans.L, trans.ERR); */
/*         mon2scb.put(trans); */
/* 				repeat(1)@(mon_if); */
/* 			end */
/* 	endtask */	
/* endclass */	

// monitor.sv
`include "defines.sv"
// `define mon_if vif.mon_cb // <-- REMOVE THIS

class monitor;
	transaction trans;
	mailbox #(transaction) mon2scb;
	virtual intf.MONITOR vif;

	function new(mailbox #(transaction) mon2scb, virtual intf.MONITOR vif);
		this.mon2scb = mon2scb;
		this.vif = vif;
	endfunction

	task start();
		repeat(4) @(vif.mon_cb);
		for(int i=0; i<`no_trans; i++) begin
			trans = new;
			repeat(1) @(vif.mon_cb)
			begin
				trans.RES = vif.mon_cb.RES; // <-- FIX: Use vif and blocking '='
				trans.OFLOW = vif.mon_cb.OFLOW;
				trans.COUT = vif.mon_cb.COUT;
				trans.E = vif.mon_cb.E;
				trans.G = vif.mon_cb.G;
				trans.L = vif.mon_cb.L;
				trans.ERR = vif.mon_cb.ERR;
			end
			$display("\n-----------------------------|| MONITOR ||--------------------------------------");
			$display("%0t || MONITOR signals: result:%0h |overflow:%0b |cout:%0b |EGL:%0b%0b%0b |error:%b",$time, trans.RES, trans.OFLOW, trans.COUT, trans.E, trans.G, trans.L, trans.ERR);
			mon2scb.put(trans);
			@(vif.mon_cb); // <-- FIX: Simplified from repeat(1)@...
		end
	endtask
endclass
