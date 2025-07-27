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
