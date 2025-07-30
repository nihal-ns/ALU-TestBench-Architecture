`include"defines.sv"

module cover_assert(clk,rst,CE,MODE,CMD,INP_VALID,OPA,OPB,CIN,RES,ERR,COUT,OFLOW,E,G,L);
	input clk,rst;
	input CE,CIN,MODE;
	input [`WIDTH-1:0] OPA, OPB;
	input [1:0] INP_VALID;
	input [`CMD_WIDTH:0] CMD;
	input [`WIDTH:0] RES;
	
	input ERR;
	input COUT;
	input OFLOW;
	input E;
	input G;
	input L;
	//// assertion part ----------
	property alu_unknown;
		@(posedge clk) !($isunknown ({rst,CE,MODE,CMD,INP_VALID,OPA,OPB,CIN}));
	endproperty

	unknown: assert property(alu_unknown) 
											/* $info("pass"); */
										else
											$error("Inputs are unknown");

	Rst_assert: assert property(@(posedge clk) !rst)
											/* $info("pass"); */	
										else
											$info("Reset is asserted");

	Clk_enable: assert property(@(posedge clk) !CE |=> RES == $past(RES))
											/* $info("pass"); */
										else
											$error("Output is not retained, it changed");

	sequence delay_16;
    INP_VALID == 2'b11 or (INP_VALID[0] ##[0:16] INP_VALID[1]) or (INP_VALID[1] ##[0:16] INP_VALID[0]);
  endsequence

  property alu_delay;
    @(posedge clk)
    if(MODE)
      CMD inside {[0:3],[8:10]} |-> (CMD inside {[0:3],[8:10]}) throughout delay_16
    else
      CMD inside {[0:5],12,13} |-> (CMD inside {[0:5],12,13}) throughout delay_16;
  endproperty

  Input_Invalid_cycle: assert property(alu_delay) 
													/* $info("pass"); */
												else 
													$error("Timeout, inputs are not recieved on time");

	/////assertion end ------------
	
	/////coverage part -----------
	covergroup alu_in_cvg @(posedge clk);
		RstBit: coverpoint rst;
		ClkEnBit: coverpoint CE;
		MBit: coverpoint MODE iff(!rst && CE);
		CinBit: coverpoint CIN iff(!rst && CE && MODE && (CMD == 2 || CMD == 3));
		InValVector: coverpoint INP_VALID iff(!rst && CE)
			{
				bins invalid = {0};
				bins input_valid_1 = {1};
				bins input_valid_2 = {2};
				bins input_valid_3 = {3};
			}
		CMDVector: coverpoint CMD iff(!rst && CE)
			{
				bins arithmetic_bin[] = {[0:10]} iff (MODE == 1);      // using "with" instead of "iff" gives some error/warning
				bins logical[] = {[0:13]} iff (MODE == 0);											
        bins out_of_range_arithetic = {[11:15]} iff (MODE == 1'b1);
        bins out_of_range_logical = {14,15} iff (MODE == 1'b0);
			}
	Cross_ModexCmd: cross MBit, CMDVector;
	CrossCMDxInValid: cross CMDVector, InValVector;
	endgroup

	covergroup alu_out_cvg @(posedge clk);
		CoutBit: coverpoint COUT iff((MODE == 1) && (CMD == 0 || CMD == 2));
		OflowBit: coverpoint OFLOW iff((MODE == 1) && (CMD == 1 || CMD == 2));
		ErrBit: coverpoint ERR;
		Cmp_E: coverpoint E iff(MODE == 1 && CMD == 10);
		Cmp_G: coverpoint G iff(MODE == 1 && CMD == 10);
		Cmp_L: coverpoint L iff(MODE == 1 && CMD == 10);
	endgroup

	alu_in_cvg cg1 = new;
	alu_out_cvg cg2 = new;

endmodule	
