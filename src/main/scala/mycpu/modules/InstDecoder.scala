package mycpu.modules

import chisel3._

class InstDecoder extends Module{
	val io = IO(new Bundle{
		val instr            = Input(UInt(32.W))
		
		val aluR_type        = Output(Bool())
		val aluI_type        = Output(Bool())
		val alu_type         = Output(Bool())
		val ld_type          = Output(Bool())
		val st_type          = Output(Bool())
		val br_type          = Output(Bool())
		val lui_type         = Output(Bool())
		val auipc_type       = Output(Bool())
		val jal_type         = Output(Bool())
		val jalr_type        = Output(Bool())
		val pc_NOT_rv1       = Output(Bool())
		
		val alu_op           = Output(UInt(4.W))
		val br_op            = Output(UInt(3.W))
		
		val dmem_we          = Output(Bool())
		val dmem_op          = Output(UInt(3.W))
		
		val rs1              = Output(UInt(5.W))
		val rs2              = Output(UInt(5.W))
		val rd               = Output(UInt(5.W))
		val rf_we            = Output(Bool())
		
		val imm              = Output(UInt(32.W))
		val shamt            = Output(UInt(5.W))
		val shamt_select     = Output(Bool())
	})
	var iopmap:Map[String,UInt] = Map(
	"alu_R"    -> "b0110011".U
	,"alu_I"   -> "b0010011".U
	,"ld"      -> "b0000011".U
	,"st"      -> "b0100011".U
	,"br"      -> "b1100011".U
	,"lui"     -> "b0110111".U
	,"auipc"   -> "b0010111".U
	,"jal"     -> "b1101111".U
	,"jalr"    -> "b1100111".U
	)
	
	val instr_op = Wire(UInt(7.W))
	instr_op := io.instr(6,0)
	
	io.aluR_type          := instr_op===iopmap("alu_R")
	io.aluI_type          := instr_op===iopmap("alu_I")
	io.alu_type           := instr_op===iopmap("alu_R") || instr_op===iopmap("alu_I")
	io.ld_type            := instr_op===iopmap("ld")
	io.st_type            := instr_op===iopmap("st")
	io.br_type            := instr_op===iopmap("br")
	io.lui_type           := instr_op===iopmap("lui")
	io.auipc_type         := instr_op===iopmap("auipc")
	io.jal_type           := instr_op===iopmap("jal")
	io.jalr_type          := instr_op===iopmap("jalr")
	io.pc_NOT_rv1         := io.br_type || io.auipc_type || io.jal_type
	
	io.alu_op := util.Cat(Seq(io.instr(30),io.instr(14,12)))
	when(io.br_type){
		when(io.instr(14,13)==="b00".U){
			io.alu_op := "b1000".U
		}.elsewhen(io.instr(14,13)==="b10".U){
			io.alu_op := "b0010".U
		}.elsewhen(io.instr(14,13)==="b11".U){
			io.alu_op := "b0011".U
		}
	}
	io.br_op := io.instr(14,12)
	
	io.dmem_we := io.st_type // use bit mask for different sizes
	io.dmem_op := io.instr(14,12)
	
	io.rs1 := io.instr(19,15)
	io.rs2 := io.instr(24,20)
	io.rd  := io.instr(11,7)
	io.rf_we := io.alu_type || io.ld_type || io.lui_type || io.auipc_type || io.jal_type || io.jalr_type
	// io.rf_we := instr_op===iopmap("alu") || instr_op===iopmap("ld") || instr_op===iopmap("lui") || instr_op===iopmap("auipc") || instr_op===iopmap("jal") || instr_op===iopmap("jalr")
	
	io.imm := 0.U
	when(io.lui_type||io.auipc_type){
		io.imm := io.instr & "hFFFFF000".U
	}.elsewhen(io.jal_type){
		io.imm := util.Cat(Seq(util.Fill(12,io.instr(31)),io.instr(20),io.instr(19,12),io.instr(30,21),0.U(1.W)))
	}.elsewhen(io.jalr_type||io.ld_type||io.aluI_type){
		io.imm := util.Cat(Seq(util.Fill(20,io.instr(31)),io.instr(31,20)))
	}.elsewhen(io.br_type){
		io.imm := util.Cat(Seq(util.Fill(20,io.instr(31)),io.instr(7),io.instr(30,25),io.instr(11,8),0.U(1.W)))
	}.elsewhen(io.st_type){
		io.imm := util.Cat(Seq(util.Fill(20,io.instr(31)),io.instr(31,25),io.instr(11,7)))
	}
	io.shamt := io.instr(24,20)
	io.shamt_select := instr_op===iopmap("alu_I") && (io.instr(14,12)==="b001".U||io.instr(14,12)==="b101".U)
}
