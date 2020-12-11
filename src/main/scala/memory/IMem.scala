package memory
import chisel3._

class IMem extends Module{
	val io = IO(new Bundle{
		val iaddr = Input(UInt(32.W))
		val idata = Output(UInt(32.W))
	})
	val imem = SyncReadMem(1024,UInt(32.W))
	io.idata := imem(io.iaddr)
}
