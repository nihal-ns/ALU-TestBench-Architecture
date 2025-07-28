`include "defines.sv"

class transaction;
	rand bit [`WIDTH-1:0] OPA;
	rand bit [`WIDTH-1:0] OPB;
	rand bit [`CMD_WIDTH:0] CMD;
	rand bit [1:0] INP_VALID;
	rand bit CIN, CE, MODE;
	
	bit OFLOW, COUT, E, G, L, ERR;
	bit [`WIDTH:0] RES;

	//constraint yet to declare it
	constraint CE_enable {CE == 1;}  // just check
	constraint mode_operation {if(MODE) 
															CMD inside {[0:10]};
														else 
															CMD inside {[0:13]};}

	constraint valid_control {if(MODE) {
															if((CMD == 4) || (CMD == 5)) 
																INP_VALID == 2'b01;
															else if((CMD == 6) || (CMD == 7))
																INP_VALID ==2'b10; }
														else { 
															if((CMD == 6) || (CMD == 8) || (CMD == 9))
																INP_VALID == 2'b01;
															else if((CMD == 7) || (CMD == 10) || (CMD == 11))
																INP_VALID == 2'b10;}}	
	
	virtual function transaction copy();
		copy = new();
		copy.OPA = this.OPA;
		copy.OPB = this.OPB;
		copy.CMD = this.CMD;
		copy.INP_VALID = this.INP_VALID;
		copy.CIN = this.CIN;
		copy.CE = this.CE;
		copy.MODE = this.MODE;
		return copy;
	endfunction	
endclass	

// extended class yet to do
