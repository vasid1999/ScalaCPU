.SILENT:

default: verilate-trace simulate

verilate:
	verilator --cc MyCPU.v --exe --build MyCPU_sim_notrace.cpp

verilate-trace:
	verilator --cc MyCPU.v --trace --exe --build MyCPU_sim_trace.cpp

simulate:
	obj_dir/VMyCPU

clean:
	rm -rf obj_dir

init: verilate-trace
