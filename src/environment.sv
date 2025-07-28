
class environment;
  virtual intf drv_vif;
  virtual intf mon_vif;
  virtual intf ref_vif;

  mailbox #(transaction) gen2drv;
  mailbox #(transaction) mon2scb;
  mailbox #(transaction) drv2ref;
  mailbox #(transaction) ref2scb;

  generator gen;
  driver drv;
  monitor mon;
  reference ref_m;
  scoreboard scb;

  function new (virtual intf drv_vif, virtual intf mon_vif, virtual intf ref_vif);
    this.drv_vif = drv_vif;
    this.mon_vif = mon_vif;
    this.ref_vif = ref_vif;
  endfunction

  task build();
    gen2drv = new();
    mon2scb = new();
    drv2ref = new();
    ref2scb = new();
		
    gen   = new(gen2drv);
    drv   = new(gen2drv, drv2ref, drv_vif);
    mon   = new(mon2scb, mon_vif);
    ref_m = new(ref_vif, drv2ref, ref2scb);
    scb   = new(mon2scb, ref2scb); 
  endtask

  task start();
    fork
      gen.start();
      drv.start();
      mon.start();
      scb.start();
      ref_m.start();
    join
  endtask
endclass
