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
      gen2drv.put(trans.copy()); 
			if(trans.MODE)
				$display("%0t ||Gen class: Arithmetic ||| CMD:%0d | valid:%0d | A:%0d | B:%0d | Ce:%0b\n",$time, trans.CMD,trans.INP_VALID, trans.OPA, trans.OPB, trans.CE);
			else
				$display("%0t ||Gen class: Logical    ||| CMD:%0d | valid:%0b | A:%0b | B:%0b | Ce:%0b\n",$time, trans.CMD,trans.INP_VALID, trans.OPA, trans.OPB, trans.CE);
		end
		$display("--------------------------------------------------------------------------------------------------------------\n");
	endtask	
endclass	

