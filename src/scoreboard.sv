`include "defines.sv"

class scoreboard;
	int MATCH, MISMATCH;
	int t;
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
				//	$display("\n %0t || --------------- ===| ScoreBoard ref data |===---------------------------",$time);
				end
				begin
					mon2scb.get(trans);
					//$display("\n %0t ||---------------- ===| ScoreBoard mon data |===--------------------------",$time);
				end
			join
			compare_report();
		end
	endtask	

	task compare_report();
		if(trans.RES == trans_ref.RES && trans.OFLOW == trans_ref.OFLOW && trans.COUT == trans_ref.COUT && trans.G == trans_ref.G && trans.L == trans_ref.L && trans.E == trans_ref.E && trans.ERR == trans_ref.ERR)
	/* if(trans === trans_ref) */		
			begin
				t++;
				MATCH++;
				$display("\n%0t ||CORRECT EXECUTION, OUTPUT MATCHES\n \tEXPECTED\tRECIEVED\nRES:   %0d\t\t%0d\nOFLOW: %1b\t\t%1b\nCOUT:  %1b\t\t%1b\nE:     %1b\t\t%1b\nG:     %1b\t\t%1b\nL:     %1b\t\t%1b \nERR:   %1b\t\t%1b\n",$time,trans.RES,trans_ref.RES,trans.OFLOW,trans_ref.OFLOW,trans.COUT,trans_ref.COUT,trans.E,trans_ref.E,trans.G,trans_ref.G,trans.L,trans_ref.L,trans.ERR,trans_ref.ERR);
			end
		else 
			begin
				t++;
				MISMATCH++;
				$display("\n Inputs(DUT|REF): \tCMD:%d|%0d |M:%d|%0d ||A:%0d|%0d ||B:%0d|%0d ",trans.CMD,trans_ref.CMD,trans.MODE, trans_ref.MODE, trans.OPA,trans_ref.OPA,trans.OPB,trans_ref.OPB);
				$display("\n%0t || INCORRECT EXECUTION\nCMP:\n \tEXPECTED\tRECIEVED\nRES:   %0d\t\t%0d\nOFLOW: %1b\t\t%1b\nCOUT:  %1b\t\t%1b\nE:     %1b\t\t%1b\nG:     %1b\t\t%1b\nL:     %1b\t\t%1b \nERR:   %1b\t\t%1b\n",$time,trans.RES,trans_ref.RES,trans.OFLOW,trans_ref.OFLOW,trans.COUT,trans_ref.COUT,trans.E,trans_ref.E,trans.G,trans_ref.G,trans.L,trans_ref.L,trans.ERR,trans_ref.ERR);
        /* $display(" ||||| Failed\n CMD = %0d", trans_ref.CMD); */
        /* if(!(trans.RES === trans_ref.RES)) */
        /*   $display(" Result error : reference : %0d | monitor : %0d", trans_ref.RES, trans.RES); */
        /* if(!(trans.ERR === trans_ref.ERR)) */
        /*   $display(" Error signal mismatch : reference : %0d | monitor : %0d", trans_ref.ERR, trans.ERR); */
        /* if(!(trans.OFLOW === trans_ref.OFLOW)) */
        /*   $display(" Overflow mismatch : reference : %0d | monitor : %0d", trans_ref.OFLOW, trans.OFLOW); */
        /* if(!(trans.G === trans_ref.G)) */
        /*   $display(" G mismatch : reference : %0d | monitor : %0d", trans_ref.G, trans.G); */
        /* if(!(trans.L === trans_ref.L)) */
        /*   $display(" L mismatch : reference : %0d | monitor : %0d", trans_ref.L, trans.L); */
        /* if(!(trans.E === trans_ref.E)) */
        /*   $display(" E mismatch : reference : %0d | monitor : %0d", trans_ref.E, trans.E); */
        /* if(!(trans.COUT === trans_ref.COUT)) */
        /*   $display(" COUT error : reference : %0d | monitor : %0d", trans_ref.COUT, trans.COUT); */
			end
    $display("--------------------------------------------------------------------------%0d------------------------------------------------------------------------",t);
	endtask	
endclass	


