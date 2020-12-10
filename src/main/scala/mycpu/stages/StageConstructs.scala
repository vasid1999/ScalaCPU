package mycpu.stages

import chisel3._

object RegEnRst{
	def apply[T <: Data](rst:Bool,init:T,enable:Bool,next:T) = {
		val r = RegInit(init)
		when (rst) { r := init }
		.elsewhen (enable) { r := next }
		r
	}
}

class IF_ID extends Bundle{
	val pc                = UInt(32.W)
	val instr             = UInt(32.W)
}

class ID_EX extends Bundle{
	// ALU
	val rv1               = UInt(32.W)
	val pc                = UInt(32.W)
	val rv2               = UInt(32.W)
	val imm               = UInt(32.W)
	val shamt             = UInt(5.W)
	
	val aluI_type         = Bool()
	val br_type           = Bool()
	
	val alu_op            = UInt(4.W)
	val br_op             = UInt(3.W)
	val shamt_select      = Bool()
	
	// offsetSum
	val pc_NOT_rv1        = Bool()
	
	// RF write
	val lui_type          = Bool()
	val auipc_type        = Bool()
	val jal_type          = Bool()
	val jalr_type         = Bool()
	
	// DMEM write encoding
		// control Wires
		val st_type       = Bool()
		val dmem_op       = UInt(3.W)
	
	// further stages -> EX + following stages
	val ld_type           = Bool()
	val rd                = UInt(5.W)
	val we                = Bool()
}

class EX_MEM extends Bundle{
	val offsetSum         = UInt(32.W)
	val dwdata_out        = UInt(32.W)
	val dmem_we           = UInt(4.W)
	val indata            = UInt(32.W)
	
	// further stages -> WB + following stages
	val ld_type           = Bool()
	val dmem_op           = UInt(3.W)
	val rd                = UInt(5.W)
	val we                = Bool()
}

class MEM_WB extends Bundle{
	val ld_type           = Bool()
	val dmem_op           = UInt(3.W)
	val daddr             = UInt(32.W)
	val drdata_in         = UInt(32.W)
	val rd                = UInt(5.W)
	val indata            = UInt(32.W)
	val we                = Bool()
}
