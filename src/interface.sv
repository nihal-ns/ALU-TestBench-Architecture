`include "defines.sv"

interface intf(input bit clk, rst);
	// input side
	logic [`WIDTH-1:0] OPA;
	logic [`WIDTH-1:0] OPB;
	logic [`CMD_WIDTH:0] CMD;
	logic CIN;
	logic CE;
	logic MODE;
	logic [1:0] INP_VALID;
	
	// output side
	logic [`WIDTH:0]RES;
	logic OFLOW;
	logic COUT;
	logic E;
	logic G;
	logic L;
	logic ERR;

	clocking mon_cb@(posedge clk);
		/* default input #0 output #0; */
		input OFLOW, COUT, E, G, L, ERR;
		input RES;
	endclocking

	clocking drv_cb@(posedge clk);
		/* default input #0 output #0; */
		input rst;
		output OPA, OPB;
		output CMD;
		output CE, CIN, MODE;
		output INP_VALID;
	endclocking

	clocking ref_cb@(posedge clk);
		// changed input#0	
		default input #1 output #0;
		input rst, CE, CIN, MODE, INP_VALID, OPA, OPB;
		//output RES, COUT, OFLOW, ERR, E, G, L;
	endclocking

	modport MONITOR(clocking mon_cb);
	modport DRIVER(clocking drv_cb);
	modport REF(clocking ref_cb);
endinterface
