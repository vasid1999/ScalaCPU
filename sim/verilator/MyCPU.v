module IF(
  input  [31:0] io_pc,
  output [31:0] io_iaddr,
  input  [31:0] io_idata_in,
  output [31:0] io_idata_out
);
  assign io_iaddr = io_pc; // @[IF.scala 17:38]
  assign io_idata_out = io_idata_in; // @[IF.scala 20:38]
endmodule
module InstDecoder(
  input  [31:0] io_instr,
  output        io_aluI_type,
  output        io_alu_type,
  output        io_ld_type,
  output        io_st_type,
  output        io_br_type,
  output        io_lui_type,
  output        io_auipc_type,
  output        io_jal_type,
  output        io_jalr_type,
  output        io_pc_NOT_rv1,
  output [3:0]  io_alu_op,
  output [2:0]  io_br_op,
  output [2:0]  io_dmem_op,
  output [4:0]  io_rs1,
  output [4:0]  io_rs2,
  output [4:0]  io_rd,
  output        io_rf_we,
  output [31:0] io_imm,
  output [4:0]  io_shamt,
  output        io_shamt_select
);
  wire [6:0] instr_op = io_instr[6:0]; // @[InstDecoder.scala 49:29]
  wire  _T_1 = instr_op == 7'h33; // @[InstDecoder.scala 51:42]
  wire  _T_2 = instr_op == 7'h13; // @[InstDecoder.scala 52:42]
  wire  _T_13 = io_br_type | io_auipc_type; // @[InstDecoder.scala 61:45]
  wire [3:0] _T_17 = {io_instr[30],io_instr[14:12]}; // @[Cat.scala 29:58]
  wire  _T_19 = io_instr[14:13] == 2'h0; // @[InstDecoder.scala 65:37]
  wire  _T_21 = io_instr[14:13] == 2'h2; // @[InstDecoder.scala 67:43]
  wire  _T_23 = io_instr[14:13] == 2'h3; // @[InstDecoder.scala 69:43]
  wire [3:0] _GEN_0 = _T_23 ? 4'h3 : _T_17; // @[InstDecoder.scala 69:54]
  wire [3:0] _GEN_1 = _T_21 ? 4'h2 : _GEN_0; // @[InstDecoder.scala 67:54]
  wire [3:0] _GEN_2 = _T_19 ? 4'h8 : _GEN_1; // @[InstDecoder.scala 65:48]
  wire  _T_29 = io_alu_type | io_ld_type; // @[InstDecoder.scala 81:33]
  wire  _T_30 = _T_29 | io_lui_type; // @[InstDecoder.scala 81:47]
  wire  _T_31 = _T_30 | io_auipc_type; // @[InstDecoder.scala 81:62]
  wire  _T_32 = _T_31 | io_jal_type; // @[InstDecoder.scala 81:79]
  wire  _T_34 = io_lui_type | io_auipc_type; // @[InstDecoder.scala 85:25]
  wire [31:0] _T_35 = io_instr & 32'hfffff000; // @[InstDecoder.scala 86:36]
  wire [11:0] _T_38 = io_instr[31] ? 12'hfff : 12'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_45 = {_T_38,io_instr[20],io_instr[19:12],io_instr[30:21],1'h0}; // @[Cat.scala 29:58]
  wire  _T_46 = io_jalr_type | io_ld_type; // @[InstDecoder.scala 89:32]
  wire  _T_47 = _T_46 | io_aluI_type; // @[InstDecoder.scala 89:44]
  wire [19:0] _T_50 = io_instr[31] ? 20'hfffff : 20'h0; // @[Bitwise.scala 72:12]
  wire [31:0] _T_52 = {_T_50,io_instr[31:20]}; // @[Cat.scala 29:58]
  wire [31:0] _T_62 = {_T_50,io_instr[7],io_instr[30:25],io_instr[11:8],1'h0}; // @[Cat.scala 29:58]
  wire [31:0] _T_69 = {_T_50,io_instr[31:25],io_instr[11:7]}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_4 = io_st_type ? _T_69 : 32'h0; // @[InstDecoder.scala 93:31]
  wire [31:0] _GEN_5 = io_br_type ? _T_62 : _GEN_4; // @[InstDecoder.scala 91:31]
  wire [31:0] _GEN_6 = _T_47 ? _T_52 : _GEN_5; // @[InstDecoder.scala 89:59]
  wire [31:0] _GEN_7 = io_jal_type ? _T_45 : _GEN_6; // @[InstDecoder.scala 87:32]
  wire  _T_73 = io_instr[14:12] == 3'h1; // @[InstDecoder.scala 97:74]
  wire  _T_75 = io_instr[14:12] == 3'h5; // @[InstDecoder.scala 97:102]
  wire  _T_76 = _T_73 | _T_75; // @[InstDecoder.scala 97:85]
  assign io_aluI_type = instr_op == 7'h13; // @[InstDecoder.scala 52:31]
  assign io_alu_type = _T_1 | _T_2; // @[InstDecoder.scala 53:31]
  assign io_ld_type = instr_op == 7'h3; // @[InstDecoder.scala 54:31]
  assign io_st_type = instr_op == 7'h23; // @[InstDecoder.scala 55:31]
  assign io_br_type = instr_op == 7'h63; // @[InstDecoder.scala 56:31]
  assign io_lui_type = instr_op == 7'h37; // @[InstDecoder.scala 57:31]
  assign io_auipc_type = instr_op == 7'h17; // @[InstDecoder.scala 58:31]
  assign io_jal_type = instr_op == 7'h6f; // @[InstDecoder.scala 59:31]
  assign io_jalr_type = instr_op == 7'h67; // @[InstDecoder.scala 60:31]
  assign io_pc_NOT_rv1 = _T_13 | io_jal_type; // @[InstDecoder.scala 61:31]
  assign io_alu_op = io_br_type ? _GEN_2 : _T_17; // @[InstDecoder.scala 63:19 InstDecoder.scala 66:35 InstDecoder.scala 68:35 InstDecoder.scala 70:35]
  assign io_br_op = io_instr[14:12]; // @[InstDecoder.scala 73:18]
  assign io_dmem_op = io_instr[14:12]; // @[InstDecoder.scala 76:20]
  assign io_rs1 = io_instr[19:15]; // @[InstDecoder.scala 78:16]
  assign io_rs2 = io_instr[24:20]; // @[InstDecoder.scala 79:16]
  assign io_rd = io_instr[11:7]; // @[InstDecoder.scala 80:16]
  assign io_rf_we = _T_32 | io_jalr_type; // @[InstDecoder.scala 81:18]
  assign io_imm = _T_34 ? _T_35 : _GEN_7; // @[InstDecoder.scala 84:16 InstDecoder.scala 86:24 InstDecoder.scala 88:24 InstDecoder.scala 90:24 InstDecoder.scala 92:24 InstDecoder.scala 94:24]
  assign io_shamt = io_instr[24:20]; // @[InstDecoder.scala 96:18]
  assign io_shamt_select = _T_2 & _T_76; // @[InstDecoder.scala 97:25]
endmodule
module RegFile(
  input         clock,
  input  [4:0]  io_rs1,
  input  [4:0]  io_rs2,
  input  [4:0]  io_rd,
  input  [31:0] io_indata,
  input         io_we,
  output [31:0] io_rv1,
  output [31:0] io_rv2
);
`ifdef RANDOMIZE_MEM_INIT
  reg [31:0] _RAND_0;
`endif // RANDOMIZE_MEM_INIT
  reg [31:0] data [0:31]; // @[RF.scala 15:23]
  wire [31:0] data__T_3_data; // @[RF.scala 15:23]
  wire [4:0] data__T_3_addr; // @[RF.scala 15:23]
  wire [31:0] data__T_4_data; // @[RF.scala 15:23]
  wire [4:0] data__T_4_addr; // @[RF.scala 15:23]
  wire [31:0] data__T_data; // @[RF.scala 15:23]
  wire [4:0] data__T_addr; // @[RF.scala 15:23]
  wire  data__T_mask; // @[RF.scala 15:23]
  wire  data__T_en; // @[RF.scala 15:23]
  wire  _T_1 = io_rd == 5'h0; // @[RF.scala 17:46]
  assign data__T_3_addr = io_rs1;
  assign data__T_3_data = data[data__T_3_addr]; // @[RF.scala 15:23]
  assign data__T_4_addr = io_rs2;
  assign data__T_4_data = data[data__T_4_addr]; // @[RF.scala 15:23]
  assign data__T_data = _T_1 ? 32'h0 : io_indata;
  assign data__T_addr = io_rd;
  assign data__T_mask = 1'h1;
  assign data__T_en = io_we;
  assign io_rv1 = data__T_3_data; // @[RF.scala 19:16]
  assign io_rv2 = data__T_4_data; // @[RF.scala 20:16]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_MEM_INIT
  _RAND_0 = {1{`RANDOM}};
  for (initvar = 0; initvar < 32; initvar = initvar+1)
    data[initvar] = _RAND_0[31:0];
`endif // RANDOMIZE_MEM_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if(data__T_en & data__T_mask) begin
      data[data__T_addr] <= data__T_data; // @[RF.scala 15:23]
    end
  end
endmodule
module DMemReadDecoder(
  input  [2:0]  io_dmem_op,
  input  [31:0] io_daddr,
  output [31:0] io_drdata_out,
  input  [31:0] io_drdata_in
);
  wire [7:0] drdata_in_vec_0 = io_drdata_in[7:0]; // @[DMemDecode.scala 86:49]
  wire [7:0] drdata_in_vec_1 = io_drdata_in[15:8]; // @[DMemDecode.scala 86:49]
  wire [7:0] drdata_in_vec_2 = io_drdata_in[23:16]; // @[DMemDecode.scala 86:49]
  wire [7:0] drdata_in_vec_3 = io_drdata_in[31:24]; // @[DMemDecode.scala 86:49]
  wire  _T_4 = io_dmem_op == 3'h0; // @[DMemDecode.scala 93:24]
  wire [7:0] _GEN_1 = 2'h1 == io_daddr[1:0] ? drdata_in_vec_1 : drdata_in_vec_0; // @[DMemDecode.scala 95:35]
  wire [7:0] _GEN_2 = 2'h2 == io_daddr[1:0] ? drdata_in_vec_2 : _GEN_1; // @[DMemDecode.scala 95:35]
  wire [7:0] _GEN_3 = 2'h3 == io_daddr[1:0] ? drdata_in_vec_3 : _GEN_2; // @[DMemDecode.scala 95:35]
  wire  _T_15 = io_dmem_op == 3'h1; // @[DMemDecode.scala 99:30]
  wire [1:0] _T_17 = io_daddr[1:0] & 2'h2; // @[DMemDecode.scala 101:66]
  wire [7:0] _GEN_5 = 2'h1 == _T_17 ? drdata_in_vec_1 : drdata_in_vec_0; // @[DMemDecode.scala 101:35]
  wire [7:0] _GEN_6 = 2'h2 == _T_17 ? drdata_in_vec_2 : _GEN_5; // @[DMemDecode.scala 101:35]
  wire [7:0] _GEN_7 = 2'h3 == _T_17 ? drdata_in_vec_3 : _GEN_6; // @[DMemDecode.scala 101:35]
  wire  _T_26 = io_dmem_op == 3'h2; // @[DMemDecode.scala 105:30]
  wire  _T_27 = io_dmem_op == 3'h4; // @[DMemDecode.scala 107:30]
  wire  _T_29 = io_dmem_op == 3'h5; // @[DMemDecode.scala 113:30]
  wire [7:0] _GEN_24 = _T_29 ? _GEN_7 : drdata_in_vec_0; // @[DMemDecode.scala 113:42]
  wire [7:0] _GEN_28 = _T_27 ? _GEN_3 : _GEN_24; // @[DMemDecode.scala 107:42]
  wire [7:0] _GEN_32 = _T_26 ? drdata_in_vec_0 : _GEN_28; // @[DMemDecode.scala 105:42]
  wire [7:0] _GEN_36 = _T_15 ? _GEN_7 : _GEN_32; // @[DMemDecode.scala 99:42]
  wire [7:0] drdata_out_vec_0 = _T_4 ? _GEN_3 : _GEN_36; // @[DMemDecode.scala 93:36]
  wire [7:0] _T_8 = drdata_out_vec_0[7] ? 8'hff : 8'h0; // @[DMemDecode.scala 96:41]
  wire [1:0] _T_19 = io_daddr[1:0] | 2'h1; // @[DMemDecode.scala 102:66]
  wire [7:0] _GEN_9 = 2'h1 == _T_19 ? drdata_in_vec_1 : drdata_in_vec_0; // @[DMemDecode.scala 102:35]
  wire [7:0] _GEN_10 = 2'h2 == _T_19 ? drdata_in_vec_2 : _GEN_9; // @[DMemDecode.scala 102:35]
  wire [7:0] _GEN_11 = 2'h3 == _T_19 ? drdata_in_vec_3 : _GEN_10; // @[DMemDecode.scala 102:35]
  wire [7:0] _GEN_25 = _T_29 ? _GEN_11 : drdata_in_vec_1; // @[DMemDecode.scala 113:42]
  wire [7:0] _GEN_29 = _T_27 ? 8'h0 : _GEN_25; // @[DMemDecode.scala 107:42]
  wire [7:0] _GEN_33 = _T_26 ? drdata_in_vec_1 : _GEN_29; // @[DMemDecode.scala 105:42]
  wire [7:0] _GEN_37 = _T_15 ? _GEN_11 : _GEN_33; // @[DMemDecode.scala 99:42]
  wire [7:0] drdata_out_vec_1 = _T_4 ? _T_8 : _GEN_37; // @[DMemDecode.scala 93:36]
  wire [7:0] _T_22 = drdata_out_vec_1[7] ? 8'hff : 8'h0; // @[DMemDecode.scala 103:41]
  wire [7:0] _GEN_26 = _T_29 ? 8'h0 : drdata_in_vec_2; // @[DMemDecode.scala 113:42]
  wire [7:0] _GEN_27 = _T_29 ? 8'h0 : drdata_in_vec_3; // @[DMemDecode.scala 113:42]
  wire [7:0] _GEN_30 = _T_27 ? 8'h0 : _GEN_26; // @[DMemDecode.scala 107:42]
  wire [7:0] _GEN_31 = _T_27 ? 8'h0 : _GEN_27; // @[DMemDecode.scala 107:42]
  wire [7:0] _GEN_34 = _T_26 ? drdata_in_vec_2 : _GEN_30; // @[DMemDecode.scala 105:42]
  wire [7:0] _GEN_35 = _T_26 ? drdata_in_vec_3 : _GEN_31; // @[DMemDecode.scala 105:42]
  wire [7:0] _GEN_38 = _T_15 ? _T_22 : _GEN_34; // @[DMemDecode.scala 99:42]
  wire [7:0] _GEN_39 = _T_15 ? _T_22 : _GEN_35; // @[DMemDecode.scala 99:42]
  wire [7:0] drdata_out_vec_2 = _T_4 ? _T_8 : _GEN_38; // @[DMemDecode.scala 93:36]
  wire [7:0] drdata_out_vec_3 = _T_4 ? _T_8 : _GEN_39; // @[DMemDecode.scala 93:36]
  wire [15:0] _T_34 = {drdata_out_vec_1,drdata_out_vec_0}; // @[DMemDecode.scala 120:41]
  wire [15:0] _T_35 = {drdata_out_vec_3,drdata_out_vec_2}; // @[DMemDecode.scala 120:41]
  assign io_drdata_out = {_T_35,_T_34}; // @[DMemDecode.scala 120:23]
endmodule
module ID_WB(
  input         clock,
  input  [31:0] io_instr,
  output        io_aluI_type,
  output        io_ld_type,
  output        io_st_type,
  output        io_br_type,
  output        io_lui_type,
  output        io_auipc_type,
  output        io_jal_type,
  output        io_jalr_type,
  output        io_pc_NOT_rv1,
  output [3:0]  io_alu_op,
  output [2:0]  io_br_op,
  output [2:0]  io_dmem_op,
  output [4:0]  io_id_rd,
  output        io_id_we,
  output [31:0] io_imm,
  output [4:0]  io_shamt,
  output        io_shamt_select,
  output [31:0] io_rv1,
  output [31:0] io_rv2,
  input  [4:0]  io_ex_rd,
  input  [31:0] io_ex_indata,
  input         io_ex_ld_type,
  input         io_ex_we,
  input  [4:0]  io_mem_rd,
  input  [31:0] io_mem_indata,
  input         io_mem_ld_type,
  input         io_mem_we,
  output        io_forwarding_stall,
  input  [2:0]  io_wb_dmem_op,
  input  [31:0] io_wb_daddr,
  input  [31:0] io_drdata_in,
  input  [4:0]  io_wb_rd,
  input  [31:0] io_wb_indata,
  input         io_wb_ld_type,
  input         io_wb_we
);
  wire [31:0] id_io_instr; // @[ID_WB.scala 74:39]
  wire  id_io_aluI_type; // @[ID_WB.scala 74:39]
  wire  id_io_alu_type; // @[ID_WB.scala 74:39]
  wire  id_io_ld_type; // @[ID_WB.scala 74:39]
  wire  id_io_st_type; // @[ID_WB.scala 74:39]
  wire  id_io_br_type; // @[ID_WB.scala 74:39]
  wire  id_io_lui_type; // @[ID_WB.scala 74:39]
  wire  id_io_auipc_type; // @[ID_WB.scala 74:39]
  wire  id_io_jal_type; // @[ID_WB.scala 74:39]
  wire  id_io_jalr_type; // @[ID_WB.scala 74:39]
  wire  id_io_pc_NOT_rv1; // @[ID_WB.scala 74:39]
  wire [3:0] id_io_alu_op; // @[ID_WB.scala 74:39]
  wire [2:0] id_io_br_op; // @[ID_WB.scala 74:39]
  wire [2:0] id_io_dmem_op; // @[ID_WB.scala 74:39]
  wire [4:0] id_io_rs1; // @[ID_WB.scala 74:39]
  wire [4:0] id_io_rs2; // @[ID_WB.scala 74:39]
  wire [4:0] id_io_rd; // @[ID_WB.scala 74:39]
  wire  id_io_rf_we; // @[ID_WB.scala 74:39]
  wire [31:0] id_io_imm; // @[ID_WB.scala 74:39]
  wire [4:0] id_io_shamt; // @[ID_WB.scala 74:39]
  wire  id_io_shamt_select; // @[ID_WB.scala 74:39]
  wire  rf_clock; // @[ID_WB.scala 75:39]
  wire [4:0] rf_io_rs1; // @[ID_WB.scala 75:39]
  wire [4:0] rf_io_rs2; // @[ID_WB.scala 75:39]
  wire [4:0] rf_io_rd; // @[ID_WB.scala 75:39]
  wire [31:0] rf_io_indata; // @[ID_WB.scala 75:39]
  wire  rf_io_we; // @[ID_WB.scala 75:39]
  wire [31:0] rf_io_rv1; // @[ID_WB.scala 75:39]
  wire [31:0] rf_io_rv2; // @[ID_WB.scala 75:39]
  wire [2:0] dmemRdDecoder_io_dmem_op; // @[ID_WB.scala 76:39]
  wire [31:0] dmemRdDecoder_io_daddr; // @[ID_WB.scala 76:39]
  wire [31:0] dmemRdDecoder_io_drdata_out; // @[ID_WB.scala 76:39]
  wire [31:0] dmemRdDecoder_io_drdata_in; // @[ID_WB.scala 76:39]
  wire  _T = id_io_rs1 == 5'h0; // @[ID_WB.scala 122:31]
  wire  _T_1 = io_ex_rd == id_io_rs1; // @[ID_WB.scala 125:47]
  wire  _T_2 = io_ex_we & _T_1; // @[ID_WB.scala 125:36]
  wire [31:0] _GEN_1 = io_ex_ld_type ? rf_io_rv1 : io_ex_indata; // @[ID_WB.scala 126:44]
  wire  _T_3 = io_mem_rd == id_io_rs1; // @[ID_WB.scala 134:50]
  wire  _T_4 = io_mem_we & _T_3; // @[ID_WB.scala 134:38]
  wire [31:0] _GEN_3 = io_mem_ld_type ? rf_io_rv1 : io_mem_indata; // @[ID_WB.scala 135:45]
  wire  _T_5 = io_wb_rd == id_io_rs1; // @[ID_WB.scala 143:48]
  wire  _T_6 = io_wb_we & _T_5; // @[ID_WB.scala 143:37]
  wire [31:0] _GEN_4 = _T_6 ? rf_io_indata : rf_io_rv1; // @[ID_WB.scala 143:61]
  wire  _GEN_5 = _T_4 & io_mem_ld_type; // @[ID_WB.scala 134:63]
  wire [31:0] _GEN_6 = _T_4 ? _GEN_3 : _GEN_4; // @[ID_WB.scala 134:63]
  wire  _GEN_7 = _T_2 ? io_ex_ld_type : _GEN_5; // @[ID_WB.scala 125:60]
  wire [31:0] _GEN_8 = _T_2 ? _GEN_1 : _GEN_6; // @[ID_WB.scala 125:60]
  wire  _GEN_10 = _T ? 1'h0 : _GEN_7; // @[ID_WB.scala 122:38]
  wire  _T_7 = id_io_rs2 == 5'h0; // @[ID_WB.scala 148:31]
  wire  _T_8 = io_ex_rd == id_io_rs2; // @[ID_WB.scala 151:47]
  wire  _T_9 = io_ex_we & _T_8; // @[ID_WB.scala 151:36]
  wire  _GEN_11 = io_ex_ld_type | _GEN_10; // @[ID_WB.scala 152:44]
  wire [31:0] _GEN_12 = io_ex_ld_type ? rf_io_rv2 : io_ex_indata; // @[ID_WB.scala 152:44]
  wire  _T_10 = io_mem_rd == id_io_rs2; // @[ID_WB.scala 160:50]
  wire  _T_11 = io_mem_we & _T_10; // @[ID_WB.scala 160:38]
  wire  _GEN_13 = io_mem_ld_type | _GEN_10; // @[ID_WB.scala 161:45]
  wire [31:0] _GEN_14 = io_mem_ld_type ? rf_io_rv2 : io_mem_indata; // @[ID_WB.scala 161:45]
  wire  _T_12 = io_wb_rd == id_io_rs2; // @[ID_WB.scala 169:48]
  wire  _T_13 = io_wb_we & _T_12; // @[ID_WB.scala 169:37]
  wire [31:0] _GEN_15 = _T_13 ? rf_io_indata : rf_io_rv2; // @[ID_WB.scala 169:61]
  wire  _GEN_16 = _T_11 ? _GEN_13 : _GEN_10; // @[ID_WB.scala 160:63]
  wire [31:0] _GEN_17 = _T_11 ? _GEN_14 : _GEN_15; // @[ID_WB.scala 160:63]
  wire  _GEN_18 = _T_9 ? _GEN_11 : _GEN_16; // @[ID_WB.scala 151:60]
  wire [31:0] _GEN_19 = _T_9 ? _GEN_12 : _GEN_17; // @[ID_WB.scala 151:60]
  InstDecoder id ( // @[ID_WB.scala 74:39]
    .io_instr(id_io_instr),
    .io_aluI_type(id_io_aluI_type),
    .io_alu_type(id_io_alu_type),
    .io_ld_type(id_io_ld_type),
    .io_st_type(id_io_st_type),
    .io_br_type(id_io_br_type),
    .io_lui_type(id_io_lui_type),
    .io_auipc_type(id_io_auipc_type),
    .io_jal_type(id_io_jal_type),
    .io_jalr_type(id_io_jalr_type),
    .io_pc_NOT_rv1(id_io_pc_NOT_rv1),
    .io_alu_op(id_io_alu_op),
    .io_br_op(id_io_br_op),
    .io_dmem_op(id_io_dmem_op),
    .io_rs1(id_io_rs1),
    .io_rs2(id_io_rs2),
    .io_rd(id_io_rd),
    .io_rf_we(id_io_rf_we),
    .io_imm(id_io_imm),
    .io_shamt(id_io_shamt),
    .io_shamt_select(id_io_shamt_select)
  );
  RegFile rf ( // @[ID_WB.scala 75:39]
    .clock(rf_clock),
    .io_rs1(rf_io_rs1),
    .io_rs2(rf_io_rs2),
    .io_rd(rf_io_rd),
    .io_indata(rf_io_indata),
    .io_we(rf_io_we),
    .io_rv1(rf_io_rv1),
    .io_rv2(rf_io_rv2)
  );
  DMemReadDecoder dmemRdDecoder ( // @[ID_WB.scala 76:39]
    .io_dmem_op(dmemRdDecoder_io_dmem_op),
    .io_daddr(dmemRdDecoder_io_daddr),
    .io_drdata_out(dmemRdDecoder_io_drdata_out),
    .io_drdata_in(dmemRdDecoder_io_drdata_in)
  );
  assign io_aluI_type = id_io_aluI_type; // @[ID_WB.scala 85:30]
  assign io_ld_type = id_io_ld_type; // @[ID_WB.scala 87:30]
  assign io_st_type = id_io_st_type; // @[ID_WB.scala 88:30]
  assign io_br_type = id_io_br_type; // @[ID_WB.scala 89:30]
  assign io_lui_type = id_io_lui_type; // @[ID_WB.scala 90:30]
  assign io_auipc_type = id_io_auipc_type; // @[ID_WB.scala 91:30]
  assign io_jal_type = id_io_jal_type; // @[ID_WB.scala 92:30]
  assign io_jalr_type = id_io_jalr_type; // @[ID_WB.scala 93:30]
  assign io_pc_NOT_rv1 = id_io_pc_NOT_rv1; // @[ID_WB.scala 94:30]
  assign io_alu_op = id_io_alu_op; // @[ID_WB.scala 96:30]
  assign io_br_op = id_io_br_op; // @[ID_WB.scala 97:30]
  assign io_dmem_op = id_io_dmem_op; // @[ID_WB.scala 100:30]
  assign io_id_rd = id_io_rd; // @[ID_WB.scala 104:30]
  assign io_id_we = id_io_rf_we; // @[ID_WB.scala 105:30]
  assign io_imm = id_io_imm; // @[ID_WB.scala 107:30]
  assign io_shamt = id_io_shamt; // @[ID_WB.scala 108:30]
  assign io_shamt_select = id_io_shamt_select; // @[ID_WB.scala 109:30]
  assign io_rv1 = _T ? 32'h0 : _GEN_8; // @[ID_WB.scala 116:30 ID_WB.scala 123:32 ID_WB.scala 131:40 ID_WB.scala 140:40 ID_WB.scala 145:32]
  assign io_rv2 = _T_7 ? 32'h0 : _GEN_19; // @[ID_WB.scala 117:30 ID_WB.scala 149:32 ID_WB.scala 157:40 ID_WB.scala 166:40 ID_WB.scala 171:32]
  assign io_forwarding_stall = _T_7 ? _GEN_10 : _GEN_18; // @[ID_WB.scala 121:37 ID_WB.scala 128:53 ID_WB.scala 137:53 ID_WB.scala 154:53 ID_WB.scala 163:53]
  assign id_io_instr = io_instr; // @[ID_WB.scala 81:30]
  assign rf_clock = clock;
  assign rf_io_rs1 = id_io_rs1; // @[ID_WB.scala 112:30]
  assign rf_io_rs2 = id_io_rs2; // @[ID_WB.scala 113:30]
  assign rf_io_rd = io_wb_rd; // @[ID_WB.scala 195:41]
  assign rf_io_indata = io_wb_ld_type ? dmemRdDecoder_io_drdata_out : io_wb_indata; // @[ID_WB.scala 196:41]
  assign rf_io_we = io_wb_we; // @[ID_WB.scala 197:41]
  assign dmemRdDecoder_io_dmem_op = io_wb_dmem_op; // @[ID_WB.scala 189:41]
  assign dmemRdDecoder_io_daddr = io_wb_daddr; // @[ID_WB.scala 190:41]
  assign dmemRdDecoder_io_drdata_in = io_drdata_in; // @[ID_WB.scala 192:41]
endmodule
module ALU(
  input  [31:0] io_in1,
  input  [31:0] io_in2,
  input  [3:0]  io_op,
  output [31:0] io_out
);
  wire  _T_1 = io_op[2:0] == 3'h0; // @[ALU.scala 12:24]
  wire [31:0] _T_9 = $signed(io_in1) - $signed(io_in2); // @[ALU.scala 14:63]
  wire [31:0] _T_11 = io_in1 + io_in2; // @[ALU.scala 16:39]
  wire [31:0] _GEN_0 = io_op[3] ? _T_9 : _T_11; // @[ALU.scala 13:37]
  wire  _T_13 = io_op[2:0] == 3'h1; // @[ALU.scala 18:30]
  wire [62:0] _GEN_9 = {{31'd0}, io_in1}; // @[ALU.scala 19:31]
  wire [62:0] _T_15 = _GEN_9 << io_in2[4:0]; // @[ALU.scala 19:31]
  wire  _T_17 = io_op[2:0] == 3'h2; // @[ALU.scala 20:30]
  wire  _T_20 = $signed(io_in1) < $signed(io_in2); // @[ALU.scala 21:41]
  wire  _T_22 = io_op[2:0] == 3'h3; // @[ALU.scala 22:30]
  wire  _T_23 = io_in1 < io_in2; // @[ALU.scala 23:34]
  wire  _T_25 = io_op[2:0] == 3'h4; // @[ALU.scala 24:30]
  wire [31:0] _T_26 = io_in1 ^ io_in2; // @[ALU.scala 25:34]
  wire  _T_28 = io_op[2:0] == 3'h5; // @[ALU.scala 26:30]
  wire [31:0] _T_34 = $signed(io_in1) >>> io_in2[4:0]; // @[ALU.scala 28:64]
  wire [31:0] _T_36 = io_in1 >> io_in2[4:0]; // @[ALU.scala 30:39]
  wire [31:0] _GEN_1 = io_op[3] ? _T_34 : _T_36; // @[ALU.scala 27:37]
  wire  _T_38 = io_op[2:0] == 3'h6; // @[ALU.scala 32:30]
  wire [31:0] _T_39 = io_in1 | io_in2; // @[ALU.scala 33:34]
  wire [31:0] _T_40 = io_in1 & io_in2; // @[ALU.scala 35:34]
  wire [31:0] _GEN_2 = _T_38 ? _T_39 : _T_40; // @[ALU.scala 32:37]
  wire [31:0] _GEN_3 = _T_28 ? _GEN_1 : _GEN_2; // @[ALU.scala 26:37]
  wire [31:0] _GEN_4 = _T_25 ? _T_26 : _GEN_3; // @[ALU.scala 24:37]
  wire [31:0] _GEN_5 = _T_22 ? {{31'd0}, _T_23} : _GEN_4; // @[ALU.scala 22:37]
  wire [31:0] _GEN_6 = _T_17 ? {{31'd0}, _T_20} : _GEN_5; // @[ALU.scala 20:37]
  wire [62:0] _GEN_7 = _T_13 ? _T_15 : {{31'd0}, _GEN_6}; // @[ALU.scala 18:37]
  wire [62:0] _GEN_8 = _T_1 ? {{31'd0}, _GEN_0} : _GEN_7; // @[ALU.scala 12:31]
  assign io_out = _GEN_8[31:0]; // @[ALU.scala 14:31 ALU.scala 16:31 ALU.scala 19:23 ALU.scala 21:24 ALU.scala 23:24 ALU.scala 25:24 ALU.scala 28:31 ALU.scala 30:31 ALU.scala 33:24 ALU.scala 35:24]
endmodule
module DMemWriteEncoder(
  input         io_st_type,
  input  [2:0]  io_dmem_op,
  input  [31:0] io_daddr,
  input  [31:0] io_dwdata_in,
  output [31:0] io_dwdata_out,
  output [3:0]  io_dmem_we
);
  wire  _T = io_dmem_op == 3'h0; // @[DMemDecode.scala 26:32]
  wire [3:0] _T_2 = 4'h1 << io_daddr[1:0]; // @[DMemDecode.scala 28:51]
  wire [4:0] _T_4 = {io_daddr[1:0],3'h0}; // @[Cat.scala 29:58]
  wire [62:0] _GEN_7 = {{31'd0}, io_dwdata_in}; // @[DMemDecode.scala 42:55]
  wire [62:0] _T_5 = _GEN_7 << _T_4; // @[DMemDecode.scala 42:55]
  wire  _T_6 = io_dmem_op == 3'h1; // @[DMemDecode.scala 46:38]
  wire [1:0] _T_8 = {io_daddr[1],1'h0}; // @[Cat.scala 29:58]
  wire [4:0] _T_9 = 5'h3 << _T_8; // @[DMemDecode.scala 48:51]
  wire [4:0] _T_11 = {io_daddr[1],4'h0}; // @[Cat.scala 29:58]
  wire [62:0] _T_12 = _GEN_7 << _T_11; // @[DMemDecode.scala 56:55]
  wire  _T_13 = io_dmem_op == 3'h2; // @[DMemDecode.scala 60:38]
  wire [3:0] _GEN_0 = _T_13 ? 4'hf : 4'h0; // @[DMemDecode.scala 60:50]
  wire [4:0] _GEN_1 = _T_6 ? _T_9 : {{1'd0}, _GEN_0}; // @[DMemDecode.scala 46:50]
  wire [62:0] _GEN_2 = _T_6 ? _T_12 : {{31'd0}, io_dwdata_in}; // @[DMemDecode.scala 46:50]
  wire [4:0] _GEN_3 = _T ? {{1'd0}, _T_2} : _GEN_1; // @[DMemDecode.scala 26:44]
  wire [62:0] _GEN_4 = _T ? _T_5 : _GEN_2; // @[DMemDecode.scala 26:44]
  wire [4:0] _GEN_5 = io_st_type ? _GEN_3 : 5'h0; // @[DMemDecode.scala 25:25]
  wire [62:0] _GEN_6 = io_st_type ? _GEN_4 : {{31'd0}, io_dwdata_in}; // @[DMemDecode.scala 25:25]
  assign io_dwdata_out = _GEN_6[31:0]; // @[DMemDecode.scala 23:23 DMemDecode.scala 42:39 DMemDecode.scala 56:39]
  assign io_dmem_we = _GEN_5[3:0]; // @[DMemDecode.scala 24:20 DMemDecode.scala 28:36 DMemDecode.scala 48:36 DMemDecode.scala 62:36]
endmodule
module EX(
  input  [31:0] io_rv1,
  input  [31:0] io_pc,
  input  [31:0] io_rv2,
  input  [31:0] io_imm,
  input  [4:0]  io_shamt,
  input         io_aluI_type,
  input         io_br_type,
  input  [3:0]  io_alu_op,
  input  [2:0]  io_br_op,
  input         io_shamt_select,
  input         io_pc_NOT_rv1,
  output [31:0] io_offsetSum,
  input         io_lui_type,
  input         io_auipc_type,
  input         io_jal_type,
  input         io_jalr_type,
  output [31:0] io_indata,
  input         io_st_type,
  input  [2:0]  io_dmem_op,
  output [31:0] io_dwdata_out,
  output [3:0]  io_dmem_we,
  output [31:0] io_pc_next,
  output        io_br_condition
);
  wire [31:0] alu_io_in1; // @[EX.scala 51:25]
  wire [31:0] alu_io_in2; // @[EX.scala 51:25]
  wire [3:0] alu_io_op; // @[EX.scala 51:25]
  wire [31:0] alu_io_out; // @[EX.scala 51:25]
  wire  dmemWrEncoder_io_st_type; // @[EX.scala 52:35]
  wire [2:0] dmemWrEncoder_io_dmem_op; // @[EX.scala 52:35]
  wire [31:0] dmemWrEncoder_io_daddr; // @[EX.scala 52:35]
  wire [31:0] dmemWrEncoder_io_dwdata_in; // @[EX.scala 52:35]
  wire [31:0] dmemWrEncoder_io_dwdata_out; // @[EX.scala 52:35]
  wire [3:0] dmemWrEncoder_io_dmem_we; // @[EX.scala 52:35]
  wire [31:0] _T = io_shamt_select ? {{27'd0}, io_shamt} : io_imm; // @[EX.scala 56:52]
  wire [31:0] _T_2 = io_pc_NOT_rv1 ? io_pc : io_rv1; // @[EX.scala 63:35]
  wire  _T_5 = io_jal_type | io_jalr_type; // @[EX.scala 70:31]
  wire [31:0] _T_7 = io_pc + 32'h4; // @[EX.scala 71:36]
  wire [31:0] _GEN_0 = _T_5 ? _T_7 : alu_io_out; // @[EX.scala 70:46]
  wire [31:0] _GEN_1 = io_auipc_type ? io_offsetSum : _GEN_0; // @[EX.scala 68:34]
  wire  alu_zero = alu_io_out == 32'h0; // @[EX.scala 88:31]
  wire  _T_9 = io_br_op == 3'h0; // @[EX.scala 91:30]
  wire  _T_10 = _T_9 & alu_zero; // @[EX.scala 91:42]
  wire  _T_11 = io_br_op == 3'h1; // @[EX.scala 91:67]
  wire  _T_12 = ~alu_zero; // @[EX.scala 91:82]
  wire  _T_13 = _T_11 & _T_12; // @[EX.scala 91:79]
  wire  _T_14 = _T_10 | _T_13; // @[EX.scala 91:55]
  wire  _T_15 = io_br_op == 3'h4; // @[EX.scala 91:105]
  wire  _T_17 = _T_15 & _T_12; // @[EX.scala 91:117]
  wire  _T_18 = _T_14 | _T_17; // @[EX.scala 91:93]
  wire  _T_19 = io_br_op == 3'h5; // @[EX.scala 91:143]
  wire  _T_20 = _T_19 & alu_zero; // @[EX.scala 91:155]
  wire  _T_21 = _T_18 | _T_20; // @[EX.scala 91:131]
  wire  _T_22 = io_br_op == 3'h6; // @[EX.scala 91:180]
  wire  _T_24 = _T_22 & _T_12; // @[EX.scala 91:192]
  wire  _T_25 = _T_21 | _T_24; // @[EX.scala 91:168]
  wire  _T_26 = io_br_op == 3'h7; // @[EX.scala 91:218]
  wire  _T_27 = _T_26 & alu_zero; // @[EX.scala 91:230]
  wire  br_check = _T_25 | _T_27; // @[EX.scala 91:206]
  wire  _T_29 = io_br_type & br_check; // @[EX.scala 94:26]
  wire  _T_30 = _T_29 | io_jal_type; // @[EX.scala 94:39]
  wire [31:0] _T_32 = {io_offsetSum[31:1],1'h0}; // @[Cat.scala 29:58]
  wire [31:0] _GEN_3 = io_jalr_type ? _T_32 : io_pc; // @[EX.scala 96:33]
  ALU alu ( // @[EX.scala 51:25]
    .io_in1(alu_io_in1),
    .io_in2(alu_io_in2),
    .io_op(alu_io_op),
    .io_out(alu_io_out)
  );
  DMemWriteEncoder dmemWrEncoder ( // @[EX.scala 52:35]
    .io_st_type(dmemWrEncoder_io_st_type),
    .io_dmem_op(dmemWrEncoder_io_dmem_op),
    .io_daddr(dmemWrEncoder_io_daddr),
    .io_dwdata_in(dmemWrEncoder_io_dwdata_in),
    .io_dwdata_out(dmemWrEncoder_io_dwdata_out),
    .io_dmem_we(dmemWrEncoder_io_dmem_we)
  );
  assign io_offsetSum = _T_2 + io_imm; // @[EX.scala 63:29]
  assign io_indata = io_lui_type ? io_imm : _GEN_1; // @[EX.scala 67:27 EX.scala 69:27 EX.scala 71:27 EX.scala 73:27]
  assign io_dwdata_out = dmemWrEncoder_io_dwdata_out; // @[EX.scala 83:43]
  assign io_dmem_we = dmemWrEncoder_io_dmem_we; // @[EX.scala 84:43]
  assign io_pc_next = _T_30 ? io_offsetSum : _GEN_3; // @[EX.scala 93:20 EX.scala 95:28 EX.scala 97:28]
  assign io_br_condition = _T_30 | io_jalr_type; // @[EX.scala 99:25]
  assign alu_io_in1 = io_rv1; // @[EX.scala 55:29]
  assign alu_io_in2 = io_aluI_type ? _T : io_rv2; // @[EX.scala 56:29]
  assign alu_io_op = io_alu_op; // @[EX.scala 57:29]
  assign dmemWrEncoder_io_st_type = io_st_type; // @[EX.scala 77:43]
  assign dmemWrEncoder_io_dmem_op = io_dmem_op; // @[EX.scala 78:43]
  assign dmemWrEncoder_io_daddr = io_offsetSum; // @[EX.scala 79:43]
  assign dmemWrEncoder_io_dwdata_in = io_rv2; // @[EX.scala 81:43]
endmodule
module MEM(
  input  [31:0] io_daddr_in,
  input  [31:0] io_dwdata_in,
  input  [3:0]  io_dmem_we_in,
  output [31:0] io_drdata_out,
  output [31:0] io_daddr_out,
  output [31:0] io_dwdata_out,
  output [3:0]  io_dmem_we_out,
  input  [31:0] io_drdata_in
);
  assign io_drdata_out = io_drdata_in; // @[MEM.scala 27:29]
  assign io_daddr_out = io_daddr_in; // @[MEM.scala 23:29]
  assign io_dwdata_out = io_dwdata_in; // @[MEM.scala 24:29]
  assign io_dmem_we_out = io_dmem_we_in; // @[MEM.scala 25:29]
endmodule
module MyCPU(
  input         clock,
  input         reset,
  output [31:0] io_iaddr,
  input  [31:0] io_idata,
  output [31:0] io_daddr,
  output [3:0]  io_dmem_we,
  output [31:0] io_dwdata,
  input  [31:0] io_drdata
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
`endif // RANDOMIZE_REG_INIT
  wire [31:0] IF_io_pc; // @[MyCPU.scala 22:49]
  wire [31:0] IF_io_iaddr; // @[MyCPU.scala 22:49]
  wire [31:0] IF_io_idata_in; // @[MyCPU.scala 22:49]
  wire [31:0] IF_io_idata_out; // @[MyCPU.scala 22:49]
  wire  ID_WB_clock; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_instr; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_aluI_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_ld_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_st_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_br_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_lui_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_auipc_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_jal_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_jalr_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_pc_NOT_rv1; // @[MyCPU.scala 23:49]
  wire [3:0] ID_WB_io_alu_op; // @[MyCPU.scala 23:49]
  wire [2:0] ID_WB_io_br_op; // @[MyCPU.scala 23:49]
  wire [2:0] ID_WB_io_dmem_op; // @[MyCPU.scala 23:49]
  wire [4:0] ID_WB_io_id_rd; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_id_we; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_imm; // @[MyCPU.scala 23:49]
  wire [4:0] ID_WB_io_shamt; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_shamt_select; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_rv1; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_rv2; // @[MyCPU.scala 23:49]
  wire [4:0] ID_WB_io_ex_rd; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_ex_indata; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_ex_ld_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_ex_we; // @[MyCPU.scala 23:49]
  wire [4:0] ID_WB_io_mem_rd; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_mem_indata; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_mem_ld_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_mem_we; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_forwarding_stall; // @[MyCPU.scala 23:49]
  wire [2:0] ID_WB_io_wb_dmem_op; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_wb_daddr; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_drdata_in; // @[MyCPU.scala 23:49]
  wire [4:0] ID_WB_io_wb_rd; // @[MyCPU.scala 23:49]
  wire [31:0] ID_WB_io_wb_indata; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_wb_ld_type; // @[MyCPU.scala 23:49]
  wire  ID_WB_io_wb_we; // @[MyCPU.scala 23:49]
  wire [31:0] EX_io_rv1; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_pc; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_rv2; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_imm; // @[MyCPU.scala 24:49]
  wire [4:0] EX_io_shamt; // @[MyCPU.scala 24:49]
  wire  EX_io_aluI_type; // @[MyCPU.scala 24:49]
  wire  EX_io_br_type; // @[MyCPU.scala 24:49]
  wire [3:0] EX_io_alu_op; // @[MyCPU.scala 24:49]
  wire [2:0] EX_io_br_op; // @[MyCPU.scala 24:49]
  wire  EX_io_shamt_select; // @[MyCPU.scala 24:49]
  wire  EX_io_pc_NOT_rv1; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_offsetSum; // @[MyCPU.scala 24:49]
  wire  EX_io_lui_type; // @[MyCPU.scala 24:49]
  wire  EX_io_auipc_type; // @[MyCPU.scala 24:49]
  wire  EX_io_jal_type; // @[MyCPU.scala 24:49]
  wire  EX_io_jalr_type; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_indata; // @[MyCPU.scala 24:49]
  wire  EX_io_st_type; // @[MyCPU.scala 24:49]
  wire [2:0] EX_io_dmem_op; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_dwdata_out; // @[MyCPU.scala 24:49]
  wire [3:0] EX_io_dmem_we; // @[MyCPU.scala 24:49]
  wire [31:0] EX_io_pc_next; // @[MyCPU.scala 24:49]
  wire  EX_io_br_condition; // @[MyCPU.scala 24:49]
  wire [31:0] MEM_io_daddr_in; // @[MyCPU.scala 25:49]
  wire [31:0] MEM_io_dwdata_in; // @[MyCPU.scala 25:49]
  wire [3:0] MEM_io_dmem_we_in; // @[MyCPU.scala 25:49]
  wire [31:0] MEM_io_drdata_out; // @[MyCPU.scala 25:49]
  wire [31:0] MEM_io_daddr_out; // @[MyCPU.scala 25:49]
  wire [31:0] MEM_io_dwdata_out; // @[MyCPU.scala 25:49]
  wire [3:0] MEM_io_dmem_we_out; // @[MyCPU.scala 25:49]
  wire [31:0] MEM_io_drdata_in; // @[MyCPU.scala 25:49]
  reg [31:0] pc; // @[MyCPU.scala 28:50]
  wire [31:0] pc_next_default = pc + 32'h4; // @[MyCPU.scala 30:46]
  wire  _T_3 = ~ID_WB_io_forwarding_stall; // @[MyCPU.scala 38:112]
  reg [31:0] IF_ID_out_pc; // @[StageConstructs.scala 7:32]
  reg [31:0] IF_ID_out_instr; // @[StageConstructs.scala 7:32]
  wire [31:0] IF_ID_in_instr = IF_io_idata_out; // @[MyCPU.scala 33:50 MyCPU.scala 56:24]
  wire  _T_4 = ID_WB_io_forwarding_stall | EX_io_br_condition; // @[MyCPU.scala 39:95]
  reg [31:0] ID_EX_out_rv1; // @[StageConstructs.scala 7:32]
  reg [31:0] ID_EX_out_pc; // @[StageConstructs.scala 7:32]
  reg [31:0] ID_EX_out_rv2; // @[StageConstructs.scala 7:32]
  reg [31:0] ID_EX_out_imm; // @[StageConstructs.scala 7:32]
  reg [4:0] ID_EX_out_shamt; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_aluI_type; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_br_type; // @[StageConstructs.scala 7:32]
  reg [3:0] ID_EX_out_alu_op; // @[StageConstructs.scala 7:32]
  reg [2:0] ID_EX_out_br_op; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_shamt_select; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_pc_NOT_rv1; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_lui_type; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_auipc_type; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_jal_type; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_jalr_type; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_st_type; // @[StageConstructs.scala 7:32]
  reg [2:0] ID_EX_out_dmem_op; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_ld_type; // @[StageConstructs.scala 7:32]
  reg [4:0] ID_EX_out_rd; // @[StageConstructs.scala 7:32]
  reg  ID_EX_out_we; // @[StageConstructs.scala 7:32]
  wire  ID_EX_in_we = ID_WB_io_id_we; // @[MyCPU.scala 34:50 MyCPU.scala 87:43]
  wire [4:0] ID_EX_in_rd = ID_WB_io_id_rd; // @[MyCPU.scala 34:50 MyCPU.scala 86:43]
  wire  ID_EX_in_ld_type = ID_WB_io_ld_type; // @[MyCPU.scala 34:50 MyCPU.scala 85:43]
  wire [2:0] ID_EX_in_dmem_op = ID_WB_io_dmem_op; // @[MyCPU.scala 34:50 MyCPU.scala 83:43]
  wire  ID_EX_in_st_type = ID_WB_io_st_type; // @[MyCPU.scala 34:50 MyCPU.scala 82:43]
  wire  ID_EX_in_jalr_type = ID_WB_io_jalr_type; // @[MyCPU.scala 34:50 MyCPU.scala 80:43]
  wire  ID_EX_in_jal_type = ID_WB_io_jal_type; // @[MyCPU.scala 34:50 MyCPU.scala 79:43]
  wire  ID_EX_in_auipc_type = ID_WB_io_auipc_type; // @[MyCPU.scala 34:50 MyCPU.scala 78:43]
  wire  ID_EX_in_lui_type = ID_WB_io_lui_type; // @[MyCPU.scala 34:50 MyCPU.scala 77:43]
  wire  ID_EX_in_pc_NOT_rv1 = ID_WB_io_pc_NOT_rv1; // @[MyCPU.scala 34:50 MyCPU.scala 75:43]
  wire  ID_EX_in_shamt_select = ID_WB_io_shamt_select; // @[MyCPU.scala 34:50 MyCPU.scala 73:43]
  wire [2:0] ID_EX_in_br_op = ID_WB_io_br_op; // @[MyCPU.scala 34:50 MyCPU.scala 72:43]
  wire [3:0] ID_EX_in_alu_op = ID_WB_io_alu_op; // @[MyCPU.scala 34:50 MyCPU.scala 71:43]
  wire  ID_EX_in_br_type = ID_WB_io_br_type; // @[MyCPU.scala 34:50 MyCPU.scala 69:43]
  wire  ID_EX_in_aluI_type = ID_WB_io_aluI_type; // @[MyCPU.scala 34:50 MyCPU.scala 68:43]
  wire [4:0] ID_EX_in_shamt = ID_WB_io_shamt; // @[MyCPU.scala 34:50 MyCPU.scala 66:43]
  wire [31:0] ID_EX_in_imm = ID_WB_io_imm; // @[MyCPU.scala 34:50 MyCPU.scala 65:43]
  wire [31:0] ID_EX_in_rv2 = ID_WB_io_rv2; // @[MyCPU.scala 34:50 MyCPU.scala 64:43]
  wire [31:0] ID_EX_in_rv1 = ID_WB_io_rv1; // @[MyCPU.scala 34:50 MyCPU.scala 62:43]
  reg [31:0] EX_MEM_out_offsetSum; // @[StageConstructs.scala 7:32]
  reg [31:0] EX_MEM_out_dwdata_out; // @[StageConstructs.scala 7:32]
  reg [3:0] EX_MEM_out_dmem_we; // @[StageConstructs.scala 7:32]
  reg [31:0] EX_MEM_out_indata; // @[StageConstructs.scala 7:32]
  reg  EX_MEM_out_ld_type; // @[StageConstructs.scala 7:32]
  reg [2:0] EX_MEM_out_dmem_op; // @[StageConstructs.scala 7:32]
  reg [4:0] EX_MEM_out_rd; // @[StageConstructs.scala 7:32]
  reg  EX_MEM_out_we; // @[StageConstructs.scala 7:32]
  wire [31:0] EX_MEM_in_indata = EX_io_indata; // @[MyCPU.scala 35:50 MyCPU.scala 117:43]
  wire [3:0] EX_MEM_in_dmem_we = EX_io_dmem_we; // @[MyCPU.scala 35:50 MyCPU.scala 116:43]
  wire [31:0] EX_MEM_in_dwdata_out = EX_io_dwdata_out; // @[MyCPU.scala 35:50 MyCPU.scala 115:43]
  wire [31:0] EX_MEM_in_offsetSum = EX_io_offsetSum; // @[MyCPU.scala 35:50 MyCPU.scala 114:43]
  reg  MEM_WB_out_ld_type; // @[StageConstructs.scala 7:32]
  reg [2:0] MEM_WB_out_dmem_op; // @[StageConstructs.scala 7:32]
  reg [31:0] MEM_WB_out_daddr; // @[StageConstructs.scala 7:32]
  reg [31:0] MEM_WB_out_drdata_in; // @[StageConstructs.scala 7:32]
  reg [4:0] MEM_WB_out_rd; // @[StageConstructs.scala 7:32]
  reg [31:0] MEM_WB_out_indata; // @[StageConstructs.scala 7:32]
  reg  MEM_WB_out_we; // @[StageConstructs.scala 7:32]
  wire [31:0] MEM_WB_in_drdata_in = MEM_io_drdata_out; // @[MyCPU.scala 36:50 MyCPU.scala 135:43]
  IF IF ( // @[MyCPU.scala 22:49]
    .io_pc(IF_io_pc),
    .io_iaddr(IF_io_iaddr),
    .io_idata_in(IF_io_idata_in),
    .io_idata_out(IF_io_idata_out)
  );
  ID_WB ID_WB ( // @[MyCPU.scala 23:49]
    .clock(ID_WB_clock),
    .io_instr(ID_WB_io_instr),
    .io_aluI_type(ID_WB_io_aluI_type),
    .io_ld_type(ID_WB_io_ld_type),
    .io_st_type(ID_WB_io_st_type),
    .io_br_type(ID_WB_io_br_type),
    .io_lui_type(ID_WB_io_lui_type),
    .io_auipc_type(ID_WB_io_auipc_type),
    .io_jal_type(ID_WB_io_jal_type),
    .io_jalr_type(ID_WB_io_jalr_type),
    .io_pc_NOT_rv1(ID_WB_io_pc_NOT_rv1),
    .io_alu_op(ID_WB_io_alu_op),
    .io_br_op(ID_WB_io_br_op),
    .io_dmem_op(ID_WB_io_dmem_op),
    .io_id_rd(ID_WB_io_id_rd),
    .io_id_we(ID_WB_io_id_we),
    .io_imm(ID_WB_io_imm),
    .io_shamt(ID_WB_io_shamt),
    .io_shamt_select(ID_WB_io_shamt_select),
    .io_rv1(ID_WB_io_rv1),
    .io_rv2(ID_WB_io_rv2),
    .io_ex_rd(ID_WB_io_ex_rd),
    .io_ex_indata(ID_WB_io_ex_indata),
    .io_ex_ld_type(ID_WB_io_ex_ld_type),
    .io_ex_we(ID_WB_io_ex_we),
    .io_mem_rd(ID_WB_io_mem_rd),
    .io_mem_indata(ID_WB_io_mem_indata),
    .io_mem_ld_type(ID_WB_io_mem_ld_type),
    .io_mem_we(ID_WB_io_mem_we),
    .io_forwarding_stall(ID_WB_io_forwarding_stall),
    .io_wb_dmem_op(ID_WB_io_wb_dmem_op),
    .io_wb_daddr(ID_WB_io_wb_daddr),
    .io_drdata_in(ID_WB_io_drdata_in),
    .io_wb_rd(ID_WB_io_wb_rd),
    .io_wb_indata(ID_WB_io_wb_indata),
    .io_wb_ld_type(ID_WB_io_wb_ld_type),
    .io_wb_we(ID_WB_io_wb_we)
  );
  EX EX ( // @[MyCPU.scala 24:49]
    .io_rv1(EX_io_rv1),
    .io_pc(EX_io_pc),
    .io_rv2(EX_io_rv2),
    .io_imm(EX_io_imm),
    .io_shamt(EX_io_shamt),
    .io_aluI_type(EX_io_aluI_type),
    .io_br_type(EX_io_br_type),
    .io_alu_op(EX_io_alu_op),
    .io_br_op(EX_io_br_op),
    .io_shamt_select(EX_io_shamt_select),
    .io_pc_NOT_rv1(EX_io_pc_NOT_rv1),
    .io_offsetSum(EX_io_offsetSum),
    .io_lui_type(EX_io_lui_type),
    .io_auipc_type(EX_io_auipc_type),
    .io_jal_type(EX_io_jal_type),
    .io_jalr_type(EX_io_jalr_type),
    .io_indata(EX_io_indata),
    .io_st_type(EX_io_st_type),
    .io_dmem_op(EX_io_dmem_op),
    .io_dwdata_out(EX_io_dwdata_out),
    .io_dmem_we(EX_io_dmem_we),
    .io_pc_next(EX_io_pc_next),
    .io_br_condition(EX_io_br_condition)
  );
  MEM MEM ( // @[MyCPU.scala 25:49]
    .io_daddr_in(MEM_io_daddr_in),
    .io_dwdata_in(MEM_io_dwdata_in),
    .io_dmem_we_in(MEM_io_dmem_we_in),
    .io_drdata_out(MEM_io_drdata_out),
    .io_daddr_out(MEM_io_daddr_out),
    .io_dwdata_out(MEM_io_dwdata_out),
    .io_dmem_we_out(MEM_io_dmem_we_out),
    .io_drdata_in(MEM_io_drdata_in)
  );
  assign io_iaddr = IF_io_iaddr; // @[MyCPU.scala 45:40]
  assign io_daddr = MEM_io_daddr_out; // @[MyCPU.scala 46:40]
  assign io_dmem_we = MEM_io_dmem_we_out; // @[MyCPU.scala 47:40]
  assign io_dwdata = MEM_io_dwdata_out; // @[MyCPU.scala 48:40]
  assign IF_io_pc = pc; // @[MyCPU.scala 51:18]
  assign IF_io_idata_in = io_idata; // @[MyCPU.scala 52:24]
  assign ID_WB_clock = clock;
  assign ID_WB_io_instr = IF_ID_out_instr; // @[MyCPU.scala 59:24]
  assign ID_WB_io_ex_rd = ID_EX_out_rd; // @[MyCPU.scala 145:40]
  assign ID_WB_io_ex_indata = EX_io_indata; // @[MyCPU.scala 146:40]
  assign ID_WB_io_ex_ld_type = ID_EX_out_ld_type; // @[MyCPU.scala 147:40]
  assign ID_WB_io_ex_we = ID_EX_out_we; // @[MyCPU.scala 148:40]
  assign ID_WB_io_mem_rd = EX_MEM_out_rd; // @[MyCPU.scala 150:40]
  assign ID_WB_io_mem_indata = EX_MEM_out_indata; // @[MyCPU.scala 151:40]
  assign ID_WB_io_mem_ld_type = EX_MEM_out_ld_type; // @[MyCPU.scala 152:40]
  assign ID_WB_io_mem_we = EX_MEM_out_we; // @[MyCPU.scala 153:40]
  assign ID_WB_io_wb_dmem_op = MEM_WB_out_dmem_op; // @[MyCPU.scala 141:40]
  assign ID_WB_io_wb_daddr = MEM_WB_out_daddr; // @[MyCPU.scala 142:40]
  assign ID_WB_io_drdata_in = MEM_WB_out_drdata_in; // @[MyCPU.scala 143:40]
  assign ID_WB_io_wb_rd = MEM_WB_out_rd; // @[MyCPU.scala 155:40]
  assign ID_WB_io_wb_indata = MEM_WB_out_indata; // @[MyCPU.scala 156:40]
  assign ID_WB_io_wb_ld_type = MEM_WB_out_ld_type; // @[MyCPU.scala 157:40]
  assign ID_WB_io_wb_we = MEM_WB_out_we; // @[MyCPU.scala 158:40]
  assign EX_io_rv1 = ID_EX_out_rv1; // @[MyCPU.scala 90:40]
  assign EX_io_pc = ID_EX_out_pc; // @[MyCPU.scala 91:40]
  assign EX_io_rv2 = ID_EX_out_rv2; // @[MyCPU.scala 92:40]
  assign EX_io_imm = ID_EX_out_imm; // @[MyCPU.scala 93:40]
  assign EX_io_shamt = ID_EX_out_shamt; // @[MyCPU.scala 94:40]
  assign EX_io_aluI_type = ID_EX_out_aluI_type; // @[MyCPU.scala 96:40]
  assign EX_io_br_type = ID_EX_out_br_type; // @[MyCPU.scala 97:40]
  assign EX_io_alu_op = ID_EX_out_alu_op; // @[MyCPU.scala 99:40]
  assign EX_io_br_op = ID_EX_out_br_op; // @[MyCPU.scala 100:40]
  assign EX_io_shamt_select = ID_EX_out_shamt_select; // @[MyCPU.scala 101:40]
  assign EX_io_pc_NOT_rv1 = ID_EX_out_pc_NOT_rv1; // @[MyCPU.scala 103:40]
  assign EX_io_lui_type = ID_EX_out_lui_type; // @[MyCPU.scala 105:40]
  assign EX_io_auipc_type = ID_EX_out_auipc_type; // @[MyCPU.scala 106:40]
  assign EX_io_jal_type = ID_EX_out_jal_type; // @[MyCPU.scala 107:40]
  assign EX_io_jalr_type = ID_EX_out_jalr_type; // @[MyCPU.scala 108:40]
  assign EX_io_st_type = ID_EX_out_st_type; // @[MyCPU.scala 110:40]
  assign EX_io_dmem_op = ID_EX_out_dmem_op; // @[MyCPU.scala 111:40]
  assign MEM_io_daddr_in = EX_MEM_out_offsetSum; // @[MyCPU.scala 125:40]
  assign MEM_io_dwdata_in = EX_MEM_out_dwdata_out; // @[MyCPU.scala 126:40]
  assign MEM_io_dmem_we_in = EX_MEM_out_dmem_we; // @[MyCPU.scala 127:40]
  assign MEM_io_drdata_in = io_drdata; // @[MyCPU.scala 129:40]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  pc = _RAND_0[31:0];
  _RAND_1 = {1{`RANDOM}};
  IF_ID_out_pc = _RAND_1[31:0];
  _RAND_2 = {1{`RANDOM}};
  IF_ID_out_instr = _RAND_2[31:0];
  _RAND_3 = {1{`RANDOM}};
  ID_EX_out_rv1 = _RAND_3[31:0];
  _RAND_4 = {1{`RANDOM}};
  ID_EX_out_pc = _RAND_4[31:0];
  _RAND_5 = {1{`RANDOM}};
  ID_EX_out_rv2 = _RAND_5[31:0];
  _RAND_6 = {1{`RANDOM}};
  ID_EX_out_imm = _RAND_6[31:0];
  _RAND_7 = {1{`RANDOM}};
  ID_EX_out_shamt = _RAND_7[4:0];
  _RAND_8 = {1{`RANDOM}};
  ID_EX_out_aluI_type = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  ID_EX_out_br_type = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  ID_EX_out_alu_op = _RAND_10[3:0];
  _RAND_11 = {1{`RANDOM}};
  ID_EX_out_br_op = _RAND_11[2:0];
  _RAND_12 = {1{`RANDOM}};
  ID_EX_out_shamt_select = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  ID_EX_out_pc_NOT_rv1 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  ID_EX_out_lui_type = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  ID_EX_out_auipc_type = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  ID_EX_out_jal_type = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  ID_EX_out_jalr_type = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  ID_EX_out_st_type = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  ID_EX_out_dmem_op = _RAND_19[2:0];
  _RAND_20 = {1{`RANDOM}};
  ID_EX_out_ld_type = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  ID_EX_out_rd = _RAND_21[4:0];
  _RAND_22 = {1{`RANDOM}};
  ID_EX_out_we = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  EX_MEM_out_offsetSum = _RAND_23[31:0];
  _RAND_24 = {1{`RANDOM}};
  EX_MEM_out_dwdata_out = _RAND_24[31:0];
  _RAND_25 = {1{`RANDOM}};
  EX_MEM_out_dmem_we = _RAND_25[3:0];
  _RAND_26 = {1{`RANDOM}};
  EX_MEM_out_indata = _RAND_26[31:0];
  _RAND_27 = {1{`RANDOM}};
  EX_MEM_out_ld_type = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  EX_MEM_out_dmem_op = _RAND_28[2:0];
  _RAND_29 = {1{`RANDOM}};
  EX_MEM_out_rd = _RAND_29[4:0];
  _RAND_30 = {1{`RANDOM}};
  EX_MEM_out_we = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  MEM_WB_out_ld_type = _RAND_31[0:0];
  _RAND_32 = {1{`RANDOM}};
  MEM_WB_out_dmem_op = _RAND_32[2:0];
  _RAND_33 = {1{`RANDOM}};
  MEM_WB_out_daddr = _RAND_33[31:0];
  _RAND_34 = {1{`RANDOM}};
  MEM_WB_out_drdata_in = _RAND_34[31:0];
  _RAND_35 = {1{`RANDOM}};
  MEM_WB_out_rd = _RAND_35[4:0];
  _RAND_36 = {1{`RANDOM}};
  MEM_WB_out_indata = _RAND_36[31:0];
  _RAND_37 = {1{`RANDOM}};
  MEM_WB_out_we = _RAND_37[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
  always @(posedge clock) begin
    if (reset) begin
      pc <= 32'h0;
    end else if (_T_3) begin
      if (EX_io_br_condition) begin
        pc <= EX_io_pc_next;
      end else begin
        pc <= pc_next_default;
      end
    end
    if (reset) begin
      IF_ID_out_pc <= 32'h0;
    end else if (EX_io_br_condition) begin
      IF_ID_out_pc <= 32'h0;
    end else if (_T_3) begin
      IF_ID_out_pc <= pc;
    end
    if (reset) begin
      IF_ID_out_instr <= 32'h0;
    end else if (EX_io_br_condition) begin
      IF_ID_out_instr <= 32'h0;
    end else if (_T_3) begin
      IF_ID_out_instr <= IF_ID_in_instr;
    end
    if (reset) begin
      ID_EX_out_rv1 <= 32'h0;
    end else if (_T_4) begin
      ID_EX_out_rv1 <= 32'h0;
    end else begin
      ID_EX_out_rv1 <= ID_EX_in_rv1;
    end
    if (reset) begin
      ID_EX_out_pc <= 32'h0;
    end else if (_T_4) begin
      ID_EX_out_pc <= 32'h0;
    end else begin
      ID_EX_out_pc <= IF_ID_out_pc;
    end
    if (reset) begin
      ID_EX_out_rv2 <= 32'h0;
    end else if (_T_4) begin
      ID_EX_out_rv2 <= 32'h0;
    end else begin
      ID_EX_out_rv2 <= ID_EX_in_rv2;
    end
    if (reset) begin
      ID_EX_out_imm <= 32'h0;
    end else if (_T_4) begin
      ID_EX_out_imm <= 32'h0;
    end else begin
      ID_EX_out_imm <= ID_EX_in_imm;
    end
    if (reset) begin
      ID_EX_out_shamt <= 5'h0;
    end else if (_T_4) begin
      ID_EX_out_shamt <= 5'h0;
    end else begin
      ID_EX_out_shamt <= ID_EX_in_shamt;
    end
    if (reset) begin
      ID_EX_out_aluI_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_aluI_type <= 1'h0;
    end else begin
      ID_EX_out_aluI_type <= ID_EX_in_aluI_type;
    end
    if (reset) begin
      ID_EX_out_br_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_br_type <= 1'h0;
    end else begin
      ID_EX_out_br_type <= ID_EX_in_br_type;
    end
    if (reset) begin
      ID_EX_out_alu_op <= 4'h0;
    end else if (_T_4) begin
      ID_EX_out_alu_op <= 4'h0;
    end else begin
      ID_EX_out_alu_op <= ID_EX_in_alu_op;
    end
    if (reset) begin
      ID_EX_out_br_op <= 3'h0;
    end else if (_T_4) begin
      ID_EX_out_br_op <= 3'h0;
    end else begin
      ID_EX_out_br_op <= ID_EX_in_br_op;
    end
    if (reset) begin
      ID_EX_out_shamt_select <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_shamt_select <= 1'h0;
    end else begin
      ID_EX_out_shamt_select <= ID_EX_in_shamt_select;
    end
    if (reset) begin
      ID_EX_out_pc_NOT_rv1 <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_pc_NOT_rv1 <= 1'h0;
    end else begin
      ID_EX_out_pc_NOT_rv1 <= ID_EX_in_pc_NOT_rv1;
    end
    if (reset) begin
      ID_EX_out_lui_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_lui_type <= 1'h0;
    end else begin
      ID_EX_out_lui_type <= ID_EX_in_lui_type;
    end
    if (reset) begin
      ID_EX_out_auipc_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_auipc_type <= 1'h0;
    end else begin
      ID_EX_out_auipc_type <= ID_EX_in_auipc_type;
    end
    if (reset) begin
      ID_EX_out_jal_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_jal_type <= 1'h0;
    end else begin
      ID_EX_out_jal_type <= ID_EX_in_jal_type;
    end
    if (reset) begin
      ID_EX_out_jalr_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_jalr_type <= 1'h0;
    end else begin
      ID_EX_out_jalr_type <= ID_EX_in_jalr_type;
    end
    if (reset) begin
      ID_EX_out_st_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_st_type <= 1'h0;
    end else begin
      ID_EX_out_st_type <= ID_EX_in_st_type;
    end
    if (reset) begin
      ID_EX_out_dmem_op <= 3'h0;
    end else if (_T_4) begin
      ID_EX_out_dmem_op <= 3'h0;
    end else begin
      ID_EX_out_dmem_op <= ID_EX_in_dmem_op;
    end
    if (reset) begin
      ID_EX_out_ld_type <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_ld_type <= 1'h0;
    end else begin
      ID_EX_out_ld_type <= ID_EX_in_ld_type;
    end
    if (reset) begin
      ID_EX_out_rd <= 5'h0;
    end else if (_T_4) begin
      ID_EX_out_rd <= 5'h0;
    end else begin
      ID_EX_out_rd <= ID_EX_in_rd;
    end
    if (reset) begin
      ID_EX_out_we <= 1'h0;
    end else if (_T_4) begin
      ID_EX_out_we <= 1'h0;
    end else begin
      ID_EX_out_we <= ID_EX_in_we;
    end
    if (reset) begin
      EX_MEM_out_offsetSum <= 32'h0;
    end else begin
      EX_MEM_out_offsetSum <= EX_MEM_in_offsetSum;
    end
    if (reset) begin
      EX_MEM_out_dwdata_out <= 32'h0;
    end else begin
      EX_MEM_out_dwdata_out <= EX_MEM_in_dwdata_out;
    end
    if (reset) begin
      EX_MEM_out_dmem_we <= 4'h0;
    end else begin
      EX_MEM_out_dmem_we <= EX_MEM_in_dmem_we;
    end
    if (reset) begin
      EX_MEM_out_indata <= 32'h0;
    end else begin
      EX_MEM_out_indata <= EX_MEM_in_indata;
    end
    if (reset) begin
      EX_MEM_out_ld_type <= 1'h0;
    end else begin
      EX_MEM_out_ld_type <= ID_EX_out_ld_type;
    end
    if (reset) begin
      EX_MEM_out_dmem_op <= 3'h0;
    end else begin
      EX_MEM_out_dmem_op <= ID_EX_out_dmem_op;
    end
    if (reset) begin
      EX_MEM_out_rd <= 5'h0;
    end else begin
      EX_MEM_out_rd <= ID_EX_out_rd;
    end
    if (reset) begin
      EX_MEM_out_we <= 1'h0;
    end else begin
      EX_MEM_out_we <= ID_EX_out_we;
    end
    if (reset) begin
      MEM_WB_out_ld_type <= 1'h0;
    end else begin
      MEM_WB_out_ld_type <= EX_MEM_out_ld_type;
    end
    if (reset) begin
      MEM_WB_out_dmem_op <= 3'h0;
    end else begin
      MEM_WB_out_dmem_op <= EX_MEM_out_dmem_op;
    end
    if (reset) begin
      MEM_WB_out_daddr <= 32'h0;
    end else begin
      MEM_WB_out_daddr <= EX_MEM_out_offsetSum;
    end
    if (reset) begin
      MEM_WB_out_drdata_in <= 32'h0;
    end else begin
      MEM_WB_out_drdata_in <= MEM_WB_in_drdata_in;
    end
    if (reset) begin
      MEM_WB_out_rd <= 5'h0;
    end else begin
      MEM_WB_out_rd <= EX_MEM_out_rd;
    end
    if (reset) begin
      MEM_WB_out_indata <= 32'h0;
    end else begin
      MEM_WB_out_indata <= EX_MEM_out_indata;
    end
    if (reset) begin
      MEM_WB_out_we <= 1'h0;
    end else begin
      MEM_WB_out_we <= EX_MEM_out_we;
    end
  end
endmodule
