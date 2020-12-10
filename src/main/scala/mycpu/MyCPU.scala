package mycpu

import chisel3._
import mycpu.stages._

class MyCPU(pipelined:Boolean) extends Module{
	val io = IO(new Bundle{
		// IMEM
		val iaddr        = Output(UInt(32.W))
		val idata        = Input(UInt(32.W))
		
		// DMEM
		val daddr        = Output(UInt(32.W))
		val dmem_we      = Output(UInt(4.W))
		val dwdata       = Output(UInt(32.W))
		val drdata       = Input(UInt(32.W))
		
		// do this using flipped construct?
	})
	
// stage declaration
	var IF                          = Module(new IF)
	var ID_WB                       = Module(new ID_WB(pipelined))
	var EX                          = Module(new EX)
	var MEM                         = Module(new MEM)
	
// top declaration
	var pc                          = RegInit(UInt(32.W),0.U)
	var pc_next_default             = Wire(UInt(32.W))
	pc_next_default                := pc + 4.U
	
// stage connections declaration
	val IF_ID_in                       = Wire(new IF_ID)
	val ID_EX_in                       = Wire(new ID_EX)
	val EX_MEM_in                      = Wire(new EX_MEM)
	val MEM_WB_in                      = Wire(new MEM_WB)
	
	val IF_ID_out                       = if(pipelined) RegEnRst(EX.io.br_condition,0.U.asTypeOf(IF_ID_in),~ID_WB.io.forwarding_stall,IF_ID_in) else WireDefault(IF_ID_in)
	val ID_EX_out                       = if(pipelined) RegEnRst(ID_WB.io.forwarding_stall||EX.io.br_condition,0.U.asTypeOf(ID_EX_in),true.B,ID_EX_in) else WireDefault(ID_EX_in)
	val EX_MEM_out                      = if(pipelined) RegEnRst(false.B,0.U.asTypeOf(EX_MEM_in),true.B,EX_MEM_in) else WireDefault(EX_MEM_in)
	val MEM_WB_out                      = if(pipelined) RegEnRst(false.B,0.U.asTypeOf(MEM_WB_in),true.B,MEM_WB_in) else WireDefault(MEM_WB_in)
	
// interconnections
	// external outputs
	io.iaddr                       := IF.io.iaddr
	io.daddr                       := MEM.io.daddr_out
	io.dmem_we                     := MEM.io.dmem_we_out
	io.dwdata                      := MEM.io.dwdata_out
	
	// IF in
	IF.io.pc := pc
	IF.io.idata_in := io.idata
	
	// IF/ID in
	IF_ID_in.pc := pc
	IF_ID_in.instr := IF.io.idata_out
	
	// ID in
	ID_WB.io.instr := IF_ID_out.instr
	
	// ID/EX in
	ID_EX_in.rv1                      := ID_WB.io.rv1               
	ID_EX_in.pc                       := IF_ID_out.pc                
	ID_EX_in.rv2                      := ID_WB.io.rv2               
	ID_EX_in.imm                      := ID_WB.io.imm               
	ID_EX_in.shamt                    := ID_WB.io.shamt             
	
	ID_EX_in.aluI_type                := ID_WB.io.aluI_type         
	ID_EX_in.br_type                  := ID_WB.io.br_type           
	
	ID_EX_in.alu_op                   := ID_WB.io.alu_op            
	ID_EX_in.br_op                    := ID_WB.io.br_op             
	ID_EX_in.shamt_select             := ID_WB.io.shamt_select      
	
	ID_EX_in.pc_NOT_rv1               := ID_WB.io.pc_NOT_rv1        
	
	ID_EX_in.lui_type                 := ID_WB.io.lui_type          
	ID_EX_in.auipc_type               := ID_WB.io.auipc_type        
	ID_EX_in.jal_type                 := ID_WB.io.jal_type          
	ID_EX_in.jalr_type                := ID_WB.io.jalr_type         
	
	ID_EX_in.st_type                  := ID_WB.io.st_type       
	ID_EX_in.dmem_op                  := ID_WB.io.dmem_op       
	
	ID_EX_in.ld_type                  := ID_WB.io.ld_type           
	ID_EX_in.rd                       := ID_WB.io.id_rd                
	ID_EX_in.we                       := ID_WB.io.id_we         
	
	// EX in
	EX.io.rv1                      := ID_EX_out.rv1               
	EX.io.pc                       := ID_EX_out.pc                
	EX.io.rv2                      := ID_EX_out.rv2               
	EX.io.imm                      := ID_EX_out.imm               
	EX.io.shamt                    := ID_EX_out.shamt             
	
	EX.io.aluI_type                := ID_EX_out.aluI_type         
	EX.io.br_type                  := ID_EX_out.br_type           
	
	EX.io.alu_op                   := ID_EX_out.alu_op            
	EX.io.br_op                    := ID_EX_out.br_op             
	EX.io.shamt_select             := ID_EX_out.shamt_select      
	
	EX.io.pc_NOT_rv1               := ID_EX_out.pc_NOT_rv1        
	
	EX.io.lui_type                 := ID_EX_out.lui_type          
	EX.io.auipc_type               := ID_EX_out.auipc_type        
	EX.io.jal_type                 := ID_EX_out.jal_type          
	EX.io.jalr_type                := ID_EX_out.jalr_type         
	
	EX.io.st_type                  := ID_EX_out.st_type       
	EX.io.dmem_op                  := ID_EX_out.dmem_op       
	
	// EX/MEM in
	EX_MEM_in.offsetSum               := EX.io.offsetSum               
	EX_MEM_in.dwdata_out              := EX.io.dwdata_out              
	EX_MEM_in.dmem_we                 := EX.io.dmem_we                 
	EX_MEM_in.indata                  := EX.io.indata                  
	
	EX_MEM_in.ld_type                 := ID_EX_out.ld_type                 
	EX_MEM_in.dmem_op                 := ID_EX_out.dmem_op                 
	EX_MEM_in.rd                      := ID_EX_out.rd                      
	EX_MEM_in.we                      := ID_EX_out.we                      
	
	// MEM in
	MEM.io.daddr_in                := EX_MEM_out.offsetSum    
	MEM.io.dwdata_in               := EX_MEM_out.dwdata_out   
	MEM.io.dmem_we_in              := EX_MEM_out.dmem_we 
	
	MEM.io.drdata_in               := io.drdata
	
	// MEM/WB in
	MEM_WB_in.ld_type                 := EX_MEM_out.ld_type
	MEM_WB_in.dmem_op                 := EX_MEM_out.dmem_op
	MEM_WB_in.daddr                   := EX_MEM_out.offsetSum
	MEM_WB_in.drdata_in               := MEM.io.drdata_out
	MEM_WB_in.rd                      := EX_MEM_out.rd
	MEM_WB_in.indata                  := EX_MEM_out.indata
	MEM_WB_in.we                      := EX_MEM_out.we
	
	// WB in
	ID_WB.io.wb_dmem_op            := MEM_WB_out.dmem_op
	ID_WB.io.wb_daddr              := MEM_WB_out.daddr
	ID_WB.io.drdata_in             := MEM_WB_out.drdata_in
	
	ID_WB.io.ex_rd                 := ID_EX_out.rd            
	ID_WB.io.ex_indata             := EX.io.indata        
	ID_WB.io.ex_ld_type            := ID_EX_out.ld_type       
	ID_WB.io.ex_we                 := ID_EX_out.we
	
	ID_WB.io.mem_rd                := EX_MEM_out.rd            
	ID_WB.io.mem_indata            := EX_MEM_out.indata        
	ID_WB.io.mem_ld_type           := EX_MEM_out.ld_type       
	ID_WB.io.mem_we                := EX_MEM_out.we 
	
	ID_WB.io.wb_rd                 := MEM_WB_out.rd
	ID_WB.io.wb_indata             := MEM_WB_out.indata
	ID_WB.io.wb_ld_type            := MEM_WB_out.ld_type
	ID_WB.io.wb_we                 := MEM_WB_out.we
	
// program counter update
	when(~ID_WB.io.forwarding_stall){
		when(EX.io.br_condition){
			pc := EX.io.pc_next
		}
		.otherwise{
			pc := pc_next_default
		}
	}
}

object SCCPU_Driver extends App {
	(new stage.ChiselStage).execute(args, Seq(stage.ChiselGeneratorAnnotation(() => new MyCPU(false))))
}

object PCPU_Driver extends App {
	(new stage.ChiselStage).execute(args, Seq(stage.ChiselGeneratorAnnotation(() => new MyCPU(true))))
}
