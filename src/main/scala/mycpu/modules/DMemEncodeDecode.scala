package mycpu.modules

import chisel3._

class DMemWriteEncoder extends Module{
	val io = IO(new Bundle{
		// control inputs
		val st_type     = Input(Bool())
		val dmem_op     = Input(UInt(3.W))
		val daddr       = Input(UInt(32.W))
		
		// CPU port
		val dwdata_in   = Input(UInt(32.W))
		
		// DMEM port
		val dwdata_out  = Output(UInt(32.W))
		val dmem_we     = Output(UInt(4.W))
	})
	
	val bYTE = 8
	
	// st_type
	io.dwdata_out := io.dwdata_in
	io.dmem_we := "b0000".U //don't store!
	when(io.st_type){
		when(io.dmem_op==="b000".U){
			//SB
			io.dmem_we := ("b0001".U) << io.daddr(1,0)
			/* expanded logic:
			when(io.daddr(1,0)==="b00".U){
				io.dmem_we := "b0001".U
			}
			.elsewhen(io.daddr(1,0)==="b01".U){
				io.dmem_we := "b0010".U
			}
			.elsewhen(io.daddr(1,0)==="b10".U){
				io.dmem_we := "b0100".U
			}
			.otherwise{
				io.dmem_we := "b1000".U
			}*/
			io.dwdata_out := io.dwdata_in << util.Cat(Seq(io.daddr(1,0),0.U(3.W)))
			/* - only the daddr(1,0)'th DMEM byte is to be changed, so shift the value to be stored to that
			   - bytes to the left of the byte to be stored won't matter, since dmem_we is one-hot wrt bytes
			   - "b000".U is additionally appended because one flip of a daddr bit involves moving to the next byte i.e. 8 data bits, or 3 address bits */
		}.elsewhen(io.dmem_op==="b001".U){
			//SH
			io.dmem_we := ("b0011".U) << util.Cat(Seq(io.daddr(1),0.U(1.W)))
			/* expanded logic:
			when(io.daddr(0)==="b0".U){
				io.dmem_we := "b0011".U
			}
			.otherwise{
				io.dmem_we := "b1100".U
			}*/
			io.dwdata_out := io.dwdata_in << util.Cat(Seq(io.daddr(1),0.U(4.W)))
			/* - only the daddr(1)'th DMEM nibble is to be changed, so shift the value to be stored to that
			   - bytes to the left of the nibble to be stored won't matter, since dmem_we is one-hot wrt nibbles
			   - "b0000".U is additionally appended because one flip of a daddr bit involves moving to the next nibble i.e. 16 data bits, or 4 address bits */
		}.elsewhen(io.dmem_op==="b010".U){
			//SW
			io.dmem_we := "b1111".U
		}
	}
}

class DMemReadDecoder extends Module{
	val io = IO(new Bundle{
		// control inputs
		val ld_type     = Input(Bool())
		val dmem_op     = Input(UInt(3.W))
		val daddr       = Input(UInt(32.W))
		
		// CPU port
		val drdata_out  = Output(UInt(32.W))
		
		// DMEM port
		val drdata_in   = Input(UInt(32.W))
	})
	
	val bYTE = 8
	val drdata_in_vec     = Wire(Vec(4,UInt(bYTE.W)))
	val drdata_out_vec    = Wire(Vec(4,UInt(bYTE.W)))
	
	for(i <- 0 to 3){
		drdata_in_vec(i) := io.drdata_in(bYTE*(i+1)-1,bYTE*i)
	}
	
	// ld_type
	for(i<-0 to 3){
		drdata_out_vec(i) := drdata_in_vec(i)
	}
	when(io.dmem_op==="b000".U){
		//LB
		drdata_out_vec(0) := drdata_in_vec(io.daddr(1,0))
		drdata_out_vec(1) := Mux(drdata_out_vec(0)(bYTE-1)===1.U,"hFF".U,0.U)
		drdata_out_vec(2) := Mux(drdata_out_vec(0)(bYTE-1)===1.U,"hFF".U,0.U)
		drdata_out_vec(3) := Mux(drdata_out_vec(0)(bYTE-1)===1.U,"hFF".U,0.U)
	}.elsewhen(io.dmem_op==="b001".U){
		//LH
		drdata_out_vec(0) := drdata_in_vec(io.daddr(1,0) & "b10".U) // AND masking the LSB 
		drdata_out_vec(1) := drdata_in_vec(io.daddr(1,0) | "b01".U) // OR masking the LSB
		drdata_out_vec(2) := Mux(drdata_out_vec(1)(bYTE-1)===1.U,"hFF".U,0.U)
		drdata_out_vec(3) := Mux(drdata_out_vec(1)(bYTE-1)===1.U,"hFF".U,0.U)
	}.elsewhen(io.dmem_op==="b010".U){
		//LW
	}.elsewhen(io.dmem_op==="b100".U){
		//LBU
		drdata_out_vec(0) := drdata_in_vec(io.daddr(1,0))
		drdata_out_vec(1) := 0.U
		drdata_out_vec(2) := 0.U
		drdata_out_vec(3) := 0.U
	}.elsewhen(io.dmem_op==="b101".U){
		//LHU
		drdata_out_vec(0) := drdata_in_vec(io.daddr(1,0) & "b10".U) // AND masking the LSB 
		drdata_out_vec(1) := drdata_in_vec(io.daddr(1,0) | "b01".U) // OR masking the LSB
		drdata_out_vec(2) := 0.U
		drdata_out_vec(3) := 0.U
	}
	io.drdata_out := drdata_out_vec.asUInt
}

class DummyVec extends Module{
	val io = IO(new Bundle{
		val a = Input(UInt(32.W))
		val b = Output(UInt(32.W))
	})
	val x = Wire(Vec(4,UInt(8.W)))
	val y = Seq()
	
	for(i<-0 to 3){
		x(i) := io.a(8*i+7,8*i)
	}
	io.b := x.asUInt()+1.U
}
