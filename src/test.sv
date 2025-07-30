class test;
	virtual intf drv_if;
	virtual intf mon_if;
	virtual intf ref_if;
	environment env;

	function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
		this.drv_if = drv_if;
		this.mon_if = mon_if;
		this.ref_if = ref_if;
	endfunction	

	task run();
		env = new(drv_if, mon_if, ref_if);
		env.build();
		env.start();
	endtask	

endclass	

class flag extends test;
	flag_trans fg;

	function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
		super.new(drv_if, mon_if, ref_if);
		fg = new;
  endfunction 

  task run();
    env = new(drv_if, mon_if, ref_if);
    env.build();
		env.gen.trans = fg;
		env.start();
  endtask 

endclass	

class error_flag extends test;
	   error_trans err_f;

  function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
    super.new(drv_if, mon_if, ref_if);
    err_f = new;
  endfunction

  task run();
    env = new(drv_if, mon_if, ref_if);
    env.build();
    env.gen.trans = err_f;
    env.start();
  endtask

endclass	

class one_op extends test;
	one_operand op;

  function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
    super.new(drv_if, mon_if, ref_if);
    op = new;
  endfunction

  task run();
    env = new(drv_if, mon_if, ref_if);
    env.build();
    env.gen.trans = op;
    env.start();
  endtask
endclass	

class delay extends test;
	val_delay d;

	function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
    super.new(drv_if, mon_if, ref_if);
    d = new;
  endfunction

  task run();
    env = new(drv_if, mon_if, ref_if);
    env.build();
    env.gen.trans = d;
    env.start();
  endtask

endclass	

class regress_test extends test;
	flag_trans fg;
	error_trans err_f;
	one_operand op;

  function new(virtual intf drv_if, virtual intf mon_if, virtual intf ref_if);
    super.new(drv_if, mon_if, ref_if);
		fg = new;
		err_f = new;
		op = new;
  endfunction
	
	task run();
		env = new(drv_if, mon_if, ref_if);
    env.build();

		$display("===========================|| Normal test start ||===========================\n");
		begin
			env.start(); 
		end
		$display("===========================|| Normal test end ||===========================\n");

		$display("===========================|| flag test start ||===========================\n");
		begin
			env.gen.trans = fg;
			env.start();
		end
		$display("===========================|| flag test end ||===========================\n");

		    $display("===========================|| Error test start ||===========================\n");
    begin
      env.gen.trans = err_f;
      env.start();
    end
    $display("===========================|| Error test end ||===========================\n");

		$display("===========================|| one operand test start ||===========================\n");
    begin
      env.gen.trans = op;
      env.start();
    end
    $display("===========================|| one operand test end ||===========================\n");
	endtask	

endclass	
