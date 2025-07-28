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
	constraint cmd_operation {if(MODE) 
															CMD inside {[0:10]};
														else 
															CMD inside {[0:13]};}

	constraint valid_control {
    if(MODE)
    { if(CMD == 4 || CMD == 5)
        INP_VALID == 2'b01;
      else if(CMD == 6 || CMD == 7)
        INP_VALID == 2'b10;
      else
        INP_VALID == 2'b11; 
		}
    else
		{
			if(CMD == 6 || CMD == 8 || CMD == 9)
        INP_VALID == 2'b01;
      else if(CMD == 7 || CMD == 10 || CMD == 11)
        INP_VALID == 2'b10;
      else
        INP_VALID == 2'b11;}
		}

	constraint val_eg {INP_VALID == 2'b11;}  // checking

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
class flag_trans extends transaction;            // checks for COUT, OFLOW, ERR, EGL flags
	constraint mode_arthi_only {MODE dist {0:=2,1:=8};}  //tune the dist

	constraint cmd_operation { 
			if(MODE) 
				CMD inside {[0:3],8};       // add, add_cin, sub, sub_cin, cmp
			else
				CMD inside {12,13}; }      // ROR, ROL

	constraint opa_val 
		{ 
			if(MODE)
			{ 
				if(CMD == 0 || CMD == 2)
					OPA + OPB >=9'b100000000;
				else if(CMD == 1 || CMD == 3)
					{ 
						if(CIN)
							OPA == OPB;
						else
							OPA < OPB;
					}
			}	
			else
				OPB > 4'b1111;
	}

	virtual function transaction copy();
    flag_trans copy1;
    copy1 = new();
    copy1.INP_VALID = INP_VALID;
    copy1.MODE = MODE;
    copy1.CMD = CMD;
    copy1.CE = CE;
    copy1.OPA = OPA;
    copy1.OPB = OPB;
    copy1.CIN = CIN;
    return copy1;
  endfunction
endclass

class error_trans extends transaction;
	constraint cmd_operation {
		if(MODE)
      CMD inside {[0:7],[11:15]};
    else
			CMD inside {[4:15]};}

	


endclass	
