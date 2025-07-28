`include "defines.sv"

class generator;
	transaction trans;
	mailbox #(transaction) gen2drv;

	function new (mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
		trans = new;
	endfunction	

	task start();
		// yet to think what to do here
		for(int i=0;i<`no_trans;i++) begin
			if(!(trans.randomize)) $fatal("Generator trans randomization failed");    
      gen2drv.put(trans); 
			$display(" %0t ||Gen class randomized signals: M:%0b | CMD:%0d | valid:%0b | A:%0b | B:%0b ",$time, trans.MODE, trans.CMD,trans.INP_VALID, trans.OPA, trans.OPB);
		end
	endtask	
endclass	


/* // this for smarter generator */
/* // ALU Testbench/generator.sv */
/* // ALU Testbench/generator.sv */
/* `include "defines.sv" */

/* class generator; */
/* 	transaction trans; */
/* 	mailbox #(transaction) gen2drv; */
/* 	virtual intf.DRIVER vif; */

/* 	function new (mailbox #(transaction) gen2drv, virtual intf.DRIVER vif); */
/* 		this.gen2drv = gen2drv; */
/* 		this.vif = vif; */
/* 	endfunction */

/* 	task start(); */
/* 		$display("%0t || Generator starting with smart sequence generation...",$time); */
/* 		for(int i=0; i < `no_trans; i++) begin */
/* 			if ($urandom_range(0, 1) == 0) begin // Changed range for more split transactions */
/* 				// ** SPLIT TRANSACTION ** */
/* 				$display("Generator: Creating a SPLIT transaction..."); */
/* 				trans = new; */
/* 				assert(trans.randomize() with { INP_VALID == 2'b01; }); */
/* 				$display("%0t || Gen part 1: M:%0b|CMD:%0d|valid:%0b|A:%0h",$time, trans.MODE, trans.CMD, trans.INP_VALID, trans.OPA); */
/* 				gen2drv.put(trans); */

/* 				repeat($urandom_range(1, 15)) @(vif.drv_cb); */

/* 				// ** THIS IS THE FIX ** */
/* 				// All declarations must be at the start of the block. */
/* 				transaction trans_part2; */
/* 				trans_part2 = new; */

/* 				// Ensure mode and command match the first part */
/* 				assert(trans_part2.randomize() with { */
/* 					INP_VALID == 2'b10; */
/* 					MODE == trans.MODE; // Use the mode from the first transaction */
/* 					CMD == trans.CMD;   // Use the command from the first transaction */
/* 				}); */
/* 				$display("%0t || Gen part 2: M:%0b|CMD:%0d|valid:%0b|B:%0h",$time, trans_part2.MODE, trans_part2.CMD, trans_part2.INP_VALID, trans_part2.OPB); */
/* 				gen2drv.put(trans_part2); */

/* 			end else begin */
/* 				// ** FULL TRANSACTION ** */
/* 				$display("Generator: Creating a FULL transaction..."); */
/* 				trans = new; */
/* 				assert(trans.randomize() with { INP_VALID == 2'b11; }); */
/* 				$display("%0t || Gen FULL: M:%0b|CMD:%0d|valid:%0b|A:%0h|B:%0h",$time, trans.MODE, trans.CMD, trans.INP_VALID, trans.OPA, trans.OPB); */
/* 				gen2drv.put(trans); */
/* 			end */
/* 		end */
/* 	endtask */
/* endclass */
