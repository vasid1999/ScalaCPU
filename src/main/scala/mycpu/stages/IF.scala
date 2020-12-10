package mycpu.stages

import chisel3._
import mycpu.modules._

class IF extends Module{
	val io = IO(new Bundle{
		// IMEM
		val pc                    = Input(UInt(32.W))
		val iaddr                 = Output(UInt(32.W))
		
		val idata_in              = Input(UInt(32.W))
		val idata_out             = Output(UInt(32.W))
	})
	
	// IMEM address mapping
	io.iaddr                     := io.pc
	
	// IMEM data decoding
	io.idata_out                 := io.idata_in
}
