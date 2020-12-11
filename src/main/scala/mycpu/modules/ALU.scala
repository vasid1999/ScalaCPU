package mycpu.modules

import chisel3._

class ALU extends Module{
	val io = IO(new Bundle{
		val in1 = Input(UInt(32.W))
		val in2 = Input(UInt(32.W))
		val op = Input(UInt(4.W))
		val out = Output(UInt(32.W))
	})
	when(io.op(2,0)===0.U){
		when(io.op(3)===1.U){
			io.out:=(io.in1.asSInt-io.in2.asSInt).asUInt//SInt?
		}.otherwise{
			io.out:=io.in1+io.in2
		}
	}.elsewhen(io.op(2,0)===1.U){
		io.out:=io.in1<<(io.in2(4,0))
	}.elsewhen(io.op(2,0)===2.U){
		io.out := io.in1.asSInt < io.in2.asSInt
	}.elsewhen(io.op(2,0)===3.U){
		io.out := io.in1 < io.in2
	}.elsewhen(io.op(2,0)===4.U){
		io.out := io.in1 ^ io.in2
	}.elsewhen(io.op(2,0)===5.U){
		when(io.op(3)===1.U){
			io.out:=(io.in1.asSInt>>(io.in2(4,0))).asUInt
		}.otherwise{
			io.out:=io.in1>>(io.in2(4,0))
		}
	}.elsewhen(io.op(2,0)===6.U){
		io.out := io.in1 | io.in2
	}.otherwise{
		io.out := io.in1 & io.in2
	}
}
