package mycpu.stages

import chisel3._
import mycpu.modules._

class MEM extends Module{
	val io = IO(new Bundle{
		// to rest of CPU
		val daddr_in     = Input(UInt(32.W))
		val dwdata_in    = Input(UInt(32.W))
		val dmem_we_in   = Input(UInt(4.W))
		
		val drdata_out   = Output(UInt(32.W))
		
		// to DMEM
		val daddr_out    = Output(UInt(32.W))
		val dwdata_out   = Output(UInt(32.W))
		val dmem_we_out  = Output(UInt(4.W))
		
		val drdata_in    = Input(UInt(32.W))
	})
	
	io.daddr_out        := io.daddr_in
	io.dwdata_out       := io.dwdata_in
	io.dmem_we_out      := io.dmem_we_in
	
	io.drdata_out       := io.drdata_in
	
}
