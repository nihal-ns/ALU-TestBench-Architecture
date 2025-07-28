`include"defines.sv"

module cover_assert(clk,rst,CE,MODE,CMD,INP_VALID,OPA,OPB,CIN,RES);
	input clk,rst;
	input CE,CIN,MODE;
	input [`WIDTH-1:0] OPA, OPB;
	input [1:0] INP_VALID;
	input [`CMD_WIDTH:0] CMD;


	//// assertion part ----------
	property alu_unknown;
		@(posedge clk) !($isunknown ({rst,CE,MODE,CMD,INP_VALID,OPA,OPB,CIN}));
	endproperty

	unknown: assert property(alu_known) 
										else
											$error("Inputs are unknown");

	Rst_assert: assert property(@(posedge clk) !rst)
										else
											$error("Reset is asserted");

	Clk_enable: assert property(@(posedge clk) !CE |=> RES == $past(RES));
										else
											$error("Output is not retained, it changed");

	/////assertion end ------------
	
	covergroup alu_cvg @(posedge clk);
		RstBit: coverpoint rst;
		ClkEnBit: coverpoint CE;
		MBit: coverpoint MODE iff(!rst && CE);
		CinBit: coverpoint CIN iff(!rst && CE && MODE && (CMD == 2 || CMD ==3));
		InValVector: coverpoint INP_VALID iff(!rst && CE)
			{
				bins invalid = {0};
				bins input_valid_1 = {1};
				bins input_valid_2 = {2};
				bins input_valid_3 = {3};
			}

		CMDVector: coverpoint CMD iff(!rst && CE)
			{
				bins arithmetic_bin[] = {[0:10]} with {MODE == 1};        //should check with "iff" instead of "with"
				bins logical[] = {[0:13]} with {MODE == 0};								// check if it  this () or {} ??				
        bins out_of_range_arithetic = {[11:15]} with {MODE == 1'b1};
        bins out_of_range_logical = {14,15} with {MODE == 1'b0};
			}
		
	endgroup
	
endmodule	
