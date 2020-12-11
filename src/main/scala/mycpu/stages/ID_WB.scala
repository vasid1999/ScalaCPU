package mycpu.stages

import chisel3._
import mycpu.modules._

class ID_WB(forwarding:Boolean) extends Module{
	val io = IO(new Bundle{
		// ---ID STAGE---
		// InstDecoder
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
		val id_rd            = Output(UInt(5.W))
		val id_we            = Output(Bool())
		
		val imm              = Output(UInt(32.W))
		val shamt            = Output(UInt(5.W))
		val shamt_select     = Output(Bool())
		
		// RegFile
		val rv1              = Output(UInt(32.W))
		val rv2              = Output(UInt(32.W))
		
		// Register Forwarding
		// from EX
		val ex_rd            = Input(UInt(5.W))
		val ex_indata        = Input(UInt(32.W))
		val ex_ld_type       = Input(Bool())
		val ex_we            = Input(Bool())
		
		// from MEM
		val mem_rd           = Input(UInt(5.W))
		val mem_indata       = Input(UInt(32.W))
		val mem_ld_type      = Input(Bool())
		val mem_we           = Input(Bool())
		
		// control signals
		val forwarding_stall = Output(Bool())
		
		// ---WB STAGE---
		// DMEM read decoding
		val wb_dmem_op       = Input(UInt(3.W))
		val wb_daddr         = Input(UInt(32.W))
		
		val drdata_in        = Input(UInt(32.W))
		
		// RF write-back
		val wb_rd            = Input(UInt(5.W))
		val wb_indata        = Input(UInt(32.W))
		val wb_ld_type       = Input(Bool())
		val wb_we            = Input(Bool())
	})
	
// constituent modules
	val id                = Module(new InstDecoder)
	val rf                = Module(new RegFile)
	val dmemRdDecoder     = Module(new DMemReadDecoder)

// ---ID STAGE---

// InstDecoder inputs
	id.io.instr          := io.instr

// InstDecoder outputs
	io.aluR_type         := id.io.aluR_type        
	io.aluI_type         := id.io.aluI_type        
	io.alu_type          := id.io.alu_type         
	io.ld_type           := id.io.ld_type          
	io.st_type           := id.io.st_type          
	io.br_type           := id.io.br_type          
	io.lui_type          := id.io.lui_type         
	io.auipc_type        := id.io.auipc_type       
	io.jal_type          := id.io.jal_type         
	io.jalr_type         := id.io.jalr_type        
	io.pc_NOT_rv1        := id.io.pc_NOT_rv1       
	
	io.alu_op            := id.io.alu_op           
	io.br_op             := id.io.br_op            
	
	io.dmem_we           := id.io.dmem_we          
	io.dmem_op           := id.io.dmem_op          
	
	io.rs1               := id.io.rs1              
	io.rs2               := id.io.rs2              
	io.id_rd             := id.io.rd               
	io.id_we             := id.io.rf_we            
	
	io.imm               := id.io.imm              
	io.shamt             := id.io.shamt            
	io.shamt_select      := id.io.shamt_select     
	
// RF inputs
	rf.io.rs1            := id.io.rs1
	rf.io.rs2            := id.io.rs2
	
// RF outputs
	io.rv1               := rf.io.rv1
	io.rv2               := rf.io.rv2
	
// Register forwarding
	if(forwarding){
		io.forwarding_stall := false.B
		when(id.io.rs1===0.U){
			io.rv1 := 0.U
		}
		.elsewhen(io.ex_we && io.ex_rd===id.io.rs1){
			when(io.ex_ld_type){
				// flush ID/EX and stall pc and IF/ID update
				io.forwarding_stall := true.B
			}.otherwise{
				// accept forwarded data
				io.rv1 := io.ex_indata
				// update ID/EX and resume pc and IF/ID update
			}
		}.elsewhen(io.mem_we && io.mem_rd===id.io.rs1){
			when(io.mem_ld_type){
				// flush ID/EX and stall pc and IF/ID update
				io.forwarding_stall := true.B
			}.otherwise{
				// accept forwarded data
				io.rv1 := io.mem_indata
				// update ID/EX and resume pc and IF/ID update
			}
		}.elsewhen(io.wb_we && io.wb_rd===id.io.rs1){
			// accept forwarded data and everything else proceeds as normal
			io.rv1 := rf.io.indata
		}
		
		when(id.io.rs2===0.U){
			io.rv2 := 0.U
		}
		.elsewhen(io.ex_we && io.ex_rd===id.io.rs2){
			when(io.ex_ld_type){
				// flush ID/EX and stall pc and IF/ID update
				io.forwarding_stall := true.B
			}.otherwise{
				// accept forwarded data
				io.rv2 := io.ex_indata
				// update ID/EX and resume pc and IF/ID update
			}
		}.elsewhen(io.mem_we && io.mem_rd===id.io.rs2){
			when(io.mem_ld_type){
				// flush ID/EX and stall pc and IF/ID update
				io.forwarding_stall := true.B
			}.otherwise{
				// accept forwarded data
				io.rv2 := io.mem_indata
				// update ID/EX and resume pc and IF/ID update
			}
		}.elsewhen(io.wb_we && io.wb_rd===id.io.rs2){
			// accept forwarded data and everything else proceeds as normal
			io.rv2 := rf.io.indata
		}
	}
	else{
		io.forwarding_stall := false.B
		when(id.io.rs1===0.U){
			io.rv1 := 0.U
		}
		when(id.io.rs2===0.U){
			io.rv2 := 0.U
		}
	}


// ---WB STAGE---

// DMEM read decoder inputs
	dmemRdDecoder.io.ld_type        := io.wb_ld_type
	dmemRdDecoder.io.dmem_op        := io.wb_dmem_op
	dmemRdDecoder.io.daddr          := io.wb_daddr
	
	dmemRdDecoder.io.drdata_in      := io.drdata_in

// RF inputs
	rf.io.rd                        := io.wb_rd
	rf.io.indata                    := Mux(io.wb_ld_type,dmemRdDecoder.io.drdata_out,io.wb_indata)
	rf.io.we                        := io.wb_we
}
