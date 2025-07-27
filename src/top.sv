include "ALU_Design_16clock_cycles.sv"
`include "interface.sv"

module top;
	import alu_pkg::*;

	bit clk = 0;
	bit reset;

	initial forever #10 clk = ~clk;

	initial begin
		@(posedge clk); reset = 1;
		repeat(1) @(posedge clk); reset = 0;
	end

	intf inter(clk, reset);

	ALU_DESIGN DUT (
		.OPA(inter.OPA),
		.OPB(inter.OPB),
		.CMD(inter.CMD),
		.CE(inter.CE),
		.CIN(inter.CIN),
		.INP_VALID(inter.INP_VALID),
		.MODE(inter.MODE),
		.G(inter.G),
		.L(inter.L),
		.E(inter.E),
		.ERR(inter.ERR),
		.COUT(inter.COUT),
		.OFLOW(inter.OFLOW),
		.RES(inter.RES),
		.CLK(clk),
		.RST(reset)
	);

	test tb;

	initial begin
		tb = new(inter.DRIVER, inter.MONITOR, inter.REF);
		tb.run();
		$display("--------------------------------------------------------");
		$display("\n ------------Match %0d of %0d--------------- \n",tb.env.scb.MATCH,tb.env.scb.MATCH+tb.env.scb.MISMATCH);
		$finish;
	end
endmodule
