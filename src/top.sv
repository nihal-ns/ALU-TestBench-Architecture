/* `include "ALU_Design_16clock_cycles.sv" */
/* `include "alu_pkg.sv" */
/* `include "interface.sv" */

/* module top; */
/* 	import alu_pkg ::*; */

/* 	bit clk; */
/* 	bit reset; */

/* 	initial begin */
/* 		forever #10 clk = ~clk; */
/* 	end */

/* 	initial begin */ 
/* 		@(posedge clk); */
/* 			reset = 1; */
/* 		repeat(1) @(posedge clk); */
/* 			reset = 0; */
/* 	end */

/* 	intf inter(clk,reset); */

/* 	ALU DUT(.OPA(intf_alu.OPA), */
/*           .OPB(intf_alu.OPB), */
/* 					.CMD(intf_alu.CMD), */
/*           .CE(intf_alu.CE), */
/*           .CIN(intf_alu.CIN), */
/*           .INP_VALID(intf_alu.INP_VALID), */
/* 				  .MODE(intf_alu.MODE), */
/* 					.G(intf_alu.G), */
/* 					.L(intf_alu.L), */
/* 					.E(intf_alu.E), */
/* 					.ERR(intf_alu.ERR), */
/* 					.COUT(intf_alu.COUT), */
/* 					.OFLOW(intf_alu.OFLOW), */
/* 					.RES(intf_alu.RES), */
/*           .CLK(clk), */
/*           .RST(reset)); */

/* 	test tb; //= new(inter.DRIVER, inter.MONITOR, inter.REF); */

/* 	initial begin */
/* 		tb = new(inter.DRIVER, inter.MONITOR, inter.REF); */
/* 		tb.run(); */
/* 		$display("--------"); */
/* 		$finish; */
/* 	end */
/* endmodule */	

`include "ALU_Design_16clock_cycles.sv"
// `include "alu_pkg.sv" // <-- CRITICAL: REMOVE THIS LINE
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

	// FIX: Changed all 'intf_alu' to 'inter'
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
		// Pass the virtual interface correctly using the modports
		tb = new(inter.DRIVER, inter.MONITOR, inter.REF);
		tb.run();
		$display("--------");
		$finish;
	end
endmodule
