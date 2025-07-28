`include "defines.sv"

class generator;
	transaction trans;
	mailbox #(transaction) gen2drv;

	function new (mailbox #(transaction) gen2drv);
		this.gen2drv = gen2drv;
		trans = new;
	endfunction	

	task start();
		for(int i=0;i<`no_trans;i++) begin
			if(!(trans.randomize)) $fatal("Generator trans randomization failed");    
      gen2drv.put(trans); 
			$display(" %0t ||Gen class randomized signals: M:%0b | CMD:%0d | valid:%0b | A:%0b | B:%0b ",$time, trans.MODE, trans.CMD,trans.INP_VALID, trans.OPA, trans.OPB);
		end
	endtask	
endclass	



