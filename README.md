# Scala CPU

This is work done as part of the B.Tech project at IIT Madras. The aim of the project is to explore resource-performance tradeoffs in existing hardware compilers.

This repo contains a simple 5-stage RISC-V processor which comes in two variants: single-cycle and pipelined. You can refer to the `MyCPU.scala` file, which contains drivers to generate Verilog code for either variant.

If you are new to this (like we were), here's a lightning-quick primer on all you need to know to use this:

1. Chisel3 - hardware construction language developed by UCB-BAR and used to design RISC-V hardware generators.
	* [Source repo][https://github.com/chipsalliance/chisel3]
	* Simple install - clone above repo, `cd` into directory and enter `sbt 'publishAll'` in terminal
	* Learn basics of Chisel3 from the [bootcamp][https://github.com/freechipsproject/chisel-bootcamp/], examine the [template][https://github.com/freechipsproject/chisel-template] project and use the [Chisel3 API][https://www.chisel-lang.org/api/latest/chisel3/index.html]

2. Instruction Set Architecture of CPU
	* RV32I ISA is used in this project
	* refer to the *riscv-spec.pdf* document found online
	* [convenient reference][https://web.archive.org/web/20200311232906/https://rv8.io/isa.html] for dataflow of the instructions

More details will be added as we will continue our work on building the testing apparatus.
