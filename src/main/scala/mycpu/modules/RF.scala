package mycpu.modules

import chisel3._

class RegFile extends Module{
	val io = IO(new Bundle{
		val rs1    = Input(UInt(5.W))
		val rs2    = Input(UInt(5.W))
		val rd     = Input(UInt(5.W))
		val indata = Input(UInt(32.W))
		val we     = Input(Bool())
		val rv1    = Output(UInt(32.W))
		val rv2    = Output(UInt(32.W))
	})
	val data = Mem(32,UInt(32.W))
	 
	when(io.we){ data(io.rd) := Mux(io.rd===0.U,0.U,io.indata) }
	
	io.rv1 := data(io.rs1)
	io.rv2 := data(io.rs2)
}
