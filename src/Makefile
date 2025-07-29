all: simulate

compile:
  vlog alu_pkg.sv top.sv

# Simulate that file/module
simulate: compile
  vsim -c top -do "run -all; quit"

clean:
  rm -rf transcript  work   
