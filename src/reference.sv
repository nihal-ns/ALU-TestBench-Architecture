/* `define ref_if vif.ref_cb */

/* class reference; */
/* 	transaction ref_trans; */
/* 	virtual intf.REF vif */

/* 	mailbox #(transaction) drv2ref; */
/* 	mailbox #(transaction) ref2scb; */

/* 	function new(virtual intf.REF vif, mailbox #(transaction) drv2ref, mailbox #(transaction) ref2scb); */
/* 		this.vif = vif; */
/* 		this.drv2ref = drv2ref; */
/* 		this.ref2scb = ref2scb; */
/* 	endfunction */	


/* 	/1* this part yet to figure out */
/*   localparam POW_2_N = $clog2(WIDTH); */
/*   wire [POW_2_N - 1:0] SH_AMT = OPB[POW_2_N - 1:0]; */
/* 		*/

/* 	task start(); */
/* 		begin */
/* 			for(int i=0;i<`no_trans;i++) begin */
/* 				drv2ref.get(ref_trans); */
/* 				repeat(2) @(ref_if) begin */
/* 					if(ref_trans.reset == 1) begin */
/* 						ref_trans.RES = 'b0; */
/* 						ref_trans.ERR = 'b0; */
/* 						ref_trans.COUT = 0; */
/* 						ref_trans.OFLOW = 0; */
/* 						ref_trans.E = 0; */
/* 						ref_trans.G = 0; */
/* 						ref_trans.L = 0; */
/* 					end */
/* 					else if(ref_trans.CE == 1) */ 
/* 						if(ref_trans.MODE) begin */ 
/* 							case(ref_trans.CMD) */
/* 								`ADD: */ 
/* 									begin */ 
/* 										ref_trans.RES = ref_trans.OPA + ref_trans.OPB; */
/* 										ref_trans.COUT = ref_trans.RES[`WIDTH]; */
/* 									end */
								
/* 								`SUB: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPA - ref_trans.OPB; */
/* 										ref_trans.OFLOW = ref_trans.OPA < ref_trans.OPB; */
/* 									end */

/* 								`ADD_CIN: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN; */
/* 										ref_trans.COUT = ref_trans.RES[`WIDTH]; */
/* 									end */
								
/* 								`SUB_CIN: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN; */
/* 										ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) || (ref_trans.OPA == ref_trans.OPB) && ref_trans.CIN; */
/* 									end */
								
/* 								`INC_A: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPA + 1; */
/* 										ref_trans.COUT = ref_trans.RES[`WIDTH]; */
/* 									end */
								
/* 								`DEC_A: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPA - 1; */
/* 										ref_trans.COUT = ref_trans.OPA == 0; */
/* 									end */

/* 								`INC_B: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPB + 1; */
/* 										ref_trans.COUT = ref_trans.RES[`WIDTH]; */
/* 									end */

/* 								`DEC_B: */
/* 									begin */
/* 										ref_trans.RES = ref_trans.OPB - 1; */
/* 										ref_trans.COUT = ref_trans.OPB == 0; */
/* 									end */

/* 								`CMP: */
/* 									begin */
/* 										ref_trans.E = ref_trans.OPA == ref_trans.OPB; */
/* 										ref_trans.G = ref_trans.OPA > ref_trans.OPB; */
/* 										ref_trans.L = ref_trans.OPA < ref_trans.OPB; */
/* 									end */

/* 								`INC_MULT: */
/* 									begin */
/* 										ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1); */
/* 									end */

/* 								`SH_MULT: */
/* 									begin */
/* 										ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB; */
/* 									end */

/* 								default: */
/* 									begin */
/* 										ref_trans.RES = 'b0; */
/* 										ref_trans.COUT = 0; */
/* 										ref_trans.OFLOW = 0; */
/* 										ref_trans.E = 0; */
/* 										ref_trans.G = 0; */
/* 										ref_trans.L = 0; */
/* 										ref_trans.ERR = 1; */
/* 									end */
/* 						end */
/* 						else begin */
/* 							case(ref_trans.CMD) */
/* 								`AND:			ref_trans.RES = {1'b0,ref_trans.OPA & ref_trans.OPB}; */ 
/* 								`NAND:		ref_trans.RES = {1'b0,~(ref_trans.OPA & ref_trans.OPB)}; */
/* 								`OR:			ref_trans.RES = {1'b0,ref_trans.OPA | ref_trans.OPB}; */ 
/* 								`NOR:			ref_trans.RES = {1'b0,~(ref_trans.OPA | ref_trans.OPB)}; */
/* 								`XOR:			ref_trans.RES = {1'b0,ref_trans.OPA ^ ref_trans.OPB}; */
/* 								`XNOR:		ref_trans.RES = {1'b0,~(ref_trans.OPA ^ ref_trans.OPB)}; */
/* 								`NOT_A:   ref_trans.RES = {1'b0,~ref_trans.OPA}; */
/* 								`NOT_B:   ref_trans.RES = {1'b0,~ref_trans.OPB}; */
/* 								`SHR1_A:  ref_trans.RES = ref_trans.OPA >> 1; */
/* 								`SHL1_A:	ref_trans.RES = ref_trans.OPA << 1; */ 
/* 								`SHR1_B:  ref_trans.RES = ref_trans.OPB >> 1; */ 
/* 								`SHL1_B:  ref_trans.RES = ref_trans.OPB >> 1; */ 
								
/* 								`ROL_A_B: */ 
/* 									begin */
/* 										ref_trans.RES = {1'b0,ref_trans.OPA << SH_AMT | ref_trans.OPA >> (`WIDTH - SH_AMT)}; */
/*                     ref_trans.ERR = |ref_trans.OPB[`WIDTH - 1 : POW_2_N +1]; */
/* 									end */

/* 								`ROR_A_B: */
/* 									begin */
/*                     ref_trans.RES = {1'b0,ref_trans.OPA << (`WIDTH - SH_AMT) | ref_trans.OPA >> SH_AMT}; */
/*                     ref_trans.ERR = |ref_trans.OPB[`WIDTH - 1 : POW_2_N +1]; */
/* 									end */
/* 								default: */
/* 									begin */
/* 										ref_trans.RES = 'b0; */
/* 										ref_trans.COUT = 0; */
/* 										ref_trans.OFLOW = 0; */
/* 										ref_trans.E = 0; */
/* 										ref_trans.G = 0; */
/* 										ref_trans.L = 0; */
/* 										ref_trans.ERR = 1; */
/* 									end */
/* 						end */
/* 				ref2scb.put(ref_trans); */
/* 				end */
/* 			end */
/* 		end */
/* 	endtask */
/* endclass */	

`include "defines.sv"

class reference;

	transaction ref_trans;
	virtual intf.REF vif;

	mailbox #(transaction) drv2ref;
	mailbox #(transaction) ref2scb;

	function new(virtual intf.REF vif, mailbox #(transaction) drv2ref, mailbox #(transaction) ref2scb);
		this.vif = vif;
		this.drv2ref = drv2ref;
		this.ref2scb = ref2scb;
	endfunction

	logic [`POW_2_N - 1:0] SH_AMT;

	task start();
		/* repeat(4)@(vif.ref_cb);   // added this part */ 
		for(int i=0;i<`no_trans;i++) begin
			ref_trans = new();
			drv2ref.get(ref_trans);
			repeat(1) @(vif.ref_cb) begin  //changed 1
				if(vif.ref_cb.rst == 1) begin
					ref_trans.RES = 'b0;
					ref_trans.ERR = 'b0;
					ref_trans.COUT = 0;
					ref_trans.OFLOW = 0;
					ref_trans.E = 0;
					ref_trans.G = 0;
					ref_trans.L = 0;
				end
				else if(ref_trans.CE == 1)
				begin
					if(((ref_trans.MODE) && (ref_trans.CMD < 4 || ref_trans.CMD > 7) && (ref_trans.CMD <11)) || ((!ref_trans.MODE) && (ref_trans.CMD < 6 || ref_trans.CMD > 11 ) && (ref_trans.CMD < 14)) && ref_trans.INP_VALID != 2'b11) begin
						for(int i=0;i<16;i++) begin
							if(i<16) begin
								if(ref_trans.INP_VALID != 2'b11 ) begin
									repeat(1) @(vif.ref_cb) begin
										ref_trans.INP_VALID = vif.ref_cb.INP_VALID;
									end // repeat
								end //if
								else
									break;
							end //if
							else
								ref_trans.INP_VALID = 2'b00;
						end //for
					end	//if

					if(ref_trans.MODE) begin
						case(ref_trans.INP_VALID)
							2'b00: ref_trans.ERR = 1;
							2'b01:
								begin
									if(ref_trans.CMD == `INC_A) begin
										ref_trans.RES = ref_trans.OPA + 1;
										/* ref_trans.COUT = ref_trans.RES[`WIDTH]; */  // flag is not present here
									end
									else if(ref_trans.CMD == `DEC_A) begin
										ref_trans.RES = ref_trans.OPA - 1;
										/* ref_trans.OFLOW = ref_trans.OPA == 0; */    // flag is not present here 
									end
									else
										ref_trans.ERR = 1;
								end

							2'b10:
								begin
									if(ref_trans.CMD == `INC_B) begin
										ref_trans.RES = ref_trans.OPB + 1;
										/* ref_trans.COUT = ref_trans.RES[`WIDTH]; */          // flag is not present here 
									end
									else if(ref_trans.CMD == `DEC_B) begin
										ref_trans.RES = ref_trans.OPB - 1;
										/* ref_trans.OFLOW = ref_trans.OPB == 0; */             // flag is not present here 
									end
									else
										ref_trans.ERR = 1;
								end

							2'b11:
								begin
									case(ref_trans.CMD)
										`ADD:
											begin
												ref_trans.RES = ref_trans.OPA + ref_trans.OPB;
												ref_trans.COUT = ref_trans.RES[`WIDTH];
											end

										`SUB:
											begin
												ref_trans.RES = ref_trans.OPA - ref_trans.OPB;
												ref_trans.OFLOW = ref_trans.OPA < ref_trans.OPB;
											end

										`ADD_CIN:
											begin
												ref_trans.RES = ref_trans.OPA + ref_trans.OPB + ref_trans.CIN;
												ref_trans.COUT = ref_trans.RES[`WIDTH];
											end

										`SUB_CIN:
											begin
												ref_trans.RES = ref_trans.OPA - ref_trans.OPB - ref_trans.CIN;
												ref_trans.OFLOW = (ref_trans.OPA < ref_trans.OPB) || (ref_trans.OPA == ref_trans.OPB) && ref_trans.CIN;
											end

										`CMP:
											begin
												ref_trans.E = ref_trans.OPA == ref_trans.OPB;
												ref_trans.G = ref_trans.OPA > ref_trans.OPB;
												ref_trans.L = ref_trans.OPA < ref_trans.OPB;
											end

										`INC_MULT: 
											begin
												repeat(1)@(vif.ref_cb);
												ref_trans.RES = (ref_trans.OPA + 1) * (ref_trans.OPB + 1);
											end

										`SH_MULT: ref_trans.RES = (ref_trans.OPA << 1) * ref_trans.OPB;

										default: ref_trans.ERR = 1;
										endcase
								end
							default: ref_trans.ERR = 1;
							endcase
					end

					else begin
						case(ref_trans.INP_VALID)
							2'b00: ref_trans.ERR = 1;

							2'b01:
								begin
									case(ref_trans.CMD)
										`NOT_A: ref_trans.RES = {1'b0,~ref_trans.OPA};
										`SHR1_A: ref_trans.RES = ref_trans.OPA >> 1;
										`SHL1_A:	 ref_trans.RES = ref_trans.OPA << 1;
										default:	 ref_trans.ERR = 1;
									endcase
								end

							2'b10:
								begin
									case(ref_trans.CMD)
										`NOT_B: ref_trans.RES = {1'b0,~ref_trans.OPB};
										`SHR1_B: ref_trans.RES = ref_trans.OPB >> 1;
										`SHL1_B: ref_trans.RES = ref_trans.OPB >> 1;
										default: ref_trans.ERR = 1;
									endcase
								end

							2'b11:
								begin
									case(ref_trans.CMD)
										`AND:			ref_trans.RES = {1'b0,ref_trans.OPA & ref_trans.OPB};
										`NAND:		ref_trans.RES = {1'b0,~(ref_trans.OPA & ref_trans.OPB)};
										`OR:			ref_trans.RES = {1'b0,ref_trans.OPA | ref_trans.OPB};
										`NOR:			ref_trans.RES = {1'b0,~(ref_trans.OPA | ref_trans.OPB)};
										`XOR:			ref_trans.RES = {1'b0,ref_trans.OPA ^ ref_trans.OPB};
										`XNOR:		ref_trans.RES = {1'b0,~(ref_trans.OPA ^ ref_trans.OPB)};

										`ROL_A_B:
											begin
												SH_AMT = ref_trans.OPB[`POW_2_N - 1:0];
												ref_trans.RES = {1'b0,ref_trans.OPA << SH_AMT | ref_trans.OPA >> (`WIDTH - SH_AMT)};
												ref_trans.ERR = |ref_trans.OPB[`WIDTH - 1 : `POW_2_N +1];
											end

										`ROR_A_B:
											begin
											  SH_AMT = ref_trans.OPB[`POW_2_N - 1:0];
												ref_trans.RES = {1'b0,ref_trans.OPA << (`WIDTH - SH_AMT) | ref_trans.OPA >> SH_AMT};
												ref_trans.ERR = |ref_trans.OPB[`WIDTH - 1 : `POW_2_N +1];
											end
										default: 	ref_trans.ERR = 1;
									endcase
								end // case 2'b11

							default: ref_trans.ERR = 1;
						endcase
					end // else
				end // CE if
			
			if(ref_trans.MODE)
				$display("\n %0t || REF display Arithmetic \n ||| valid:%d | A:%d | B:%d | cmd:%d \n ||| output: | res:%d | err:%d | oflow:%d | EGL:%d%d%d ",$time,ref_trans.INP_VALID, ref_trans.OPA,  ref_trans.OPB, ref_trans.CMD, ref_trans.RES,ref_trans.ERR, ref_trans.OFLOW, ref_trans.E, ref_trans.G, ref_trans.L);
			else
				$display("\n %0t || REF display logical \n ||| valid:%d | A:%d | B:%d | cmd:%d \n ||| output: | res:%d | err:%d | oflow:%d | EGL:%d%d%d ",$time,ref_trans.INP_VALID, ref_trans.OPA,  ref_trans.OPB, ref_trans.CMD, ref_trans.RES,ref_trans.ERR, ref_trans.OFLOW, ref_trans.E, ref_trans.G, ref_trans.L);
			end
			ref2scb.put(ref_trans);
			/* repeat(2)@(vif.ref_cb); */
		end
	endtask
endclass



