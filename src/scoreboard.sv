`include "defines.sv"

class scoreboard;
	int MATCH, MISMATCH;
	transaction trans, trans_ref;

	mailbox #(transaction) mon2scb;
	mailbox #(transaction) ref2scb;

	function new(mailbox #(transaction) mon2scb, mailbox #(transaction) ref2scb);
		this.mon2scb = mon2scb;
		this.ref2scb = ref2scb;
	endfunction	

	task start();
		for(int i=0;i<`no_trans;i++)
		begin
			trans = new;
			trans_ref = new;
			fork 
				begin
					ref2scb.get(trans_ref);
					$display("\n %0t || --------------- ===| ScoreBoard ref data |===---------------------------",$time);
				end
				begin
					mon2scb.get(trans);
					$display("\n %0t ||---------------- ===| ScoreBoard mon data |===--------------------------",$time);
				end
			join
			compare_report();
		end
	endtask	

	task compare_report();
		if(trans.RES == trans_ref.RES && trans.OFLOW == trans_ref.OFLOW && trans.COUT == trans_ref.COUT && trans.G == trans_ref.G && trans.L == trans_ref.L && trans.E == trans_ref.E && trans.ERR == trans_ref.ERR)
			
			begin
				MATCH++;
				$display("%0t | CORRECT EXECUTION, OUTPUT MATCHES\n EXPECTED\tRECIEVED\nRES: %0d\t%0d\nOFLOW: %1b\t%1b\nCOUT: %1b\t%1b\nE: %1b\t%1b\nG: %1b\t%1b\nL: %1b\t%1b ERR:%1b\t%1b\n",$time,trans.RES,trans_ref.RES,trans.OFLOW,trans_ref.OFLOW,trans.COUT,trans_ref.COUT,trans.E,trans_ref.E,trans.G,trans_ref.G,trans.L,trans_ref.L,trans.ERR,trans_ref.ERR);
			end
		else 
			begin
				MISMATCH++;
				$display("%0t | INCORRECT EXECUTION\nCMP:\n EXPECTED\tRECIEVED\nRES: %0d\t%0d\nOFLOW: %1b\t%1b\nCOUT: %1b\t%1b\nE: %1b\t%1b\nG: %1b\t%1b\nL: %1b\t%1b ERR:%1b\t%1b\n",$time,trans.RES,trans_ref.RES,trans.OFLOW,trans_ref.OFLOW,trans.COUT,trans_ref.COUT,trans.E,trans_ref.E,trans.G,trans_ref.G,trans.L,trans_ref.L,trans.ERR,trans_ref.ERR);
			end
    $display("---------------------------------------------------------------------------------------------------------------------------------------------------");
	endtask	
endclass	
