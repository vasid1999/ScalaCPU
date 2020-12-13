# Scala CPU

This is work done as part of the B.Tech project at IIT Madras. The aim of the project is to explore resource-performance tradeoffs in existing hardware compilers. This repo contains Scala source code for a 5-stage RISC-V processor which comes in two variants: single-cycle and pipelined. Simulation code has also been added for Verilator.

If you are new to this (like we were), here's a lightning-quick primer on all you need to know to use this:

1. **Chisel3**\
Chisel3 is a hardware construction language embedded within the Scala programming language. It is being developed by UCB-BAR and is used mainly to design hardware generators.
	* Basic knowledge of Scala syntax can be found on the [Scala website](https://www.scala-lang.org/), specifically the [Tour of Scala](https://docs.scala-lang.org/tour/tour-of-scala.html) (it will be needed since Chisel3 is essentially a Scala library specialized for hardware construction - no need to go too much into detail, you can learn as you go)
	* Install and learn SBT - the Scala build tool, used to compile, run and test your Scala/Chisel3 project - by going through the [sbt by example](https://www.scala-sbt.org/1.x/docs/sbt-by-example.html) tutorial on the SBT website
	* You can learn how to use Chisel3 by:
		+ going through the [bootcamp](https://github.com/freechipsproject/chisel-bootcamp/)
		+ dissecting the [template project](https://github.com/freechipsproject/chisel-template)
		+ referring to the [Chisel3 cheatsheet](https://github.com/freechipsproject/chisel-cheatsheet) (open `main.tex` and download the PDF) and the [Chisel3 API](https://www.chisel-lang.org/api/latest/chisel3/index.html)
	* Once you are comfortable with the basics, you can clone the [Chisel3 repo](https://github.com/chipsalliance/chisel3) to start working on your projects locally
	* Simple install - clone above repo, `cd` into directory and enter `sbt 'publishLocal'` in terminal
	* In order to use Chisel3 locally, you will have to add it as a dependency in the `build.sbt` script of your project. Refer to the `build.sbt` of the template project (mentioned above) to see how they do it

2. **Instruction Set Architecture of CPU**
	* RV32I ISA is used in this project
	* Refer to the *riscv-spec.pdf* document found [here](https://riscv.org/technical/specifications/) in the ISA Specification section
	* Here's a [convenient reference](https://web.archive.org/web/20200311232906/https://rv8.io/isa.html) for dataflow of the instructions

3. **Using this project**
	* All modules used can be found at `src/main/scala`
	* To generate HDL for single-cycle and pipelined processors, first compile the project using `sbt 'compile'`, and then run `sbt 'runMain mycpu.SCCPU_Driver'` and `sbt 'runMain mycpu.PCPU_Driver'` respectively

4. **Verifying functionaliy using simulation**
	* Simulation can be carried out using tools in the `sim` directory
	* As of now, Verilator is used to perform simulation
	* The `README` file in the respective directories explain more about the tools and their usage

More details will be added as we will continue our work on building the testing apparatus. We also plan to look into the RocketChip in-order core and see what changes we can make to the current design.
