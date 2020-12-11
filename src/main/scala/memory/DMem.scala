package memory
import chisel3._

class DMem extends Module{
	val io = IO(new Bundle{
		val daddr  = Input(UInt(32.W))
		val we     = Input(UInt(4.W))
		val dwdata = Input(UInt(32.W))
		val drdata = Output(UInt(32.W))
	})
	// definitions
	val dmem = Seq(Mem(1024,UInt(8.W)),Mem(1024,UInt(8.W)),Mem(1024,UInt(8.W)),Mem(1024,UInt(8.W)))
	
	val daddr_msb = Wire(UInt(32.W))
	daddr_msb := io.daddr>>2
	
	// data write
	for(i<-0 to 3){
		when(io.we(i)===1.U){
			dmem(i)(daddr_msb) := io.dwdata(8*i+7,8*i)
		}
	}
	
	// data read
	io.drdata := 0.U
	for(i<-0 to 3){
		io.drdata := io.drdata<<8 | dmem(i)(daddr_msb)
	}
}
