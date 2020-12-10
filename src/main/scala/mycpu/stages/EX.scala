package mycpu.stages

import chisel3._
import mycpu.modules._

class EX extends Module{
	val io = IO(new Bundle{
		// ALU
		val rv1               = Input(UInt(32.W))
		val pc                = Input(UInt(32.W))
		val rv2               = Input(UInt(32.W))
		val imm               = Input(UInt(32.W))
		val shamt             = Input(UInt(5.W))
		
		val aluI_type         = Input(Bool())
		val br_type           = Input(Bool())
		
		val alu_op            = Input(UInt(4.W))
		val br_op             = Input(UInt(3.W))
		val shamt_select      = Input(Bool())
		
		val out               = Output(UInt(32.W))
		
		// offsetSum
		val pc_NOT_rv1        = Input(Bool())
		val offsetSum         = Output(UInt(32.W))
		
		// RF write
		val lui_type          = Input(Bool())
		val auipc_type        = Input(Bool())
		val jal_type          = Input(Bool())
		val jalr_type         = Input(Bool())
		val indata            = Output(UInt(32.W))
		
		// DMEM write encoding
			// control inputs
			val st_type       = Input(Bool())
			val dmem_op       = Input(UInt(3.W))
		
			// DMEM port
			val dwdata_out    = Output(UInt(32.W))
			val dmem_we       = Output(UInt(4.W))
		
		
		// branching
		val pc_next           = Output(UInt(32.W))
		val br_condition      = Output(Bool())
	})
	
	// module declaration
	val alu = Module(new ALU)
	val dmemWrEncoder = Module(new DMemWriteEncoder)
	
	// ALU inputs
	alu.io.in1          := io.rv1
	alu.io.in2          := Mux(io.aluI_type,Mux(io.shamt_select,io.shamt,io.imm),io.rv2)
	alu.io.op           := io.alu_op
	
	// ALU outputs
	io.out              := alu.io.out
	
	// offsetSum
	io.offsetSum        := Mux(io.pc_NOT_rv1,io.pc,io.rv1) + io.imm//.asSInt
	
	// RF write (splitting the original 5-input MUX (in SCCPU) into stagewise MUXes)
	when(io.lui_type){
		io.indata := io.imm
	}.elsewhen(io.auipc_type){
		io.indata := io.offsetSum
	}.elsewhen(io.jal_type||io.jalr_type){
		io.indata := io.pc + 4.U
	}.otherwise{
		io.indata := alu.io.out
	}
	
	// DMEM write encoding
	dmemWrEncoder.io.st_type          := io.st_type
	dmemWrEncoder.io.dmem_op          := io.dmem_op
	dmemWrEncoder.io.daddr            := io.offsetSum
	
	dmemWrEncoder.io.dwdata_in        := io.rv2
	
	io.dwdata_out                     := dmemWrEncoder.io.dwdata_out
	io.dmem_we                        := dmemWrEncoder.io.dmem_we
	
	// branching
	val alu_zero = Wire(Bool())
	alu_zero := alu.io.out===0.U
	
	val br_check = Wire(Bool())
	br_check := (io.br_op==="b000".U && alu_zero) || (io.br_op==="b001".U && ~alu_zero) || (io.br_op==="b100".U && ~alu_zero) || (io.br_op==="b101".U && alu_zero) || (io.br_op==="b110".U && ~alu_zero) || (io.br_op==="b111".U && alu_zero)
	
	io.pc_next := io.pc
	when((io.br_type && br_check) || io.jal_type){
		io.pc_next := io.offsetSum
	}.elsewhen(io.jalr_type){
		io.pc_next := util.Cat(Seq(io.offsetSum(31,1),"b0".U)) // offsetSum & "hFFFFFFFE".U
	}
	io.br_condition := (io.br_type && br_check) || io.jal_type || io.jalr_type
}
