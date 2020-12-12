.SILENT:

default: verilate simulate

verilate:
	verilator --cc MyCPU.v --exe --build MyCPU_sim.cpp

simulate:
	obj_dir/VMyCPU

clean:
	rm -rf obj_dir
