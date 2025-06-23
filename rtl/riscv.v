`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE
// VSCODE plug-in version: Verilog-Hdl-Format-3.5.20250220
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            Please Write Company name
// All rights reserved
// File name:
// Last modified Date:     2025/06/12 15:05:29
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/06/12 15:05:29
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              riscv.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\riscv.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module riscv(
    input   wire 		  clk   		 	,
    input   wire 		  rst_n		     	,
    //指令
    input   wire [31:0]   inst_i		 	,
    output  wire [31:0]   inst_addr_o	 	,
    //read  mem
    output  wire 	   	  mem_rd_req_o		,
    output  wire [31:0]   mem_rd_addr_o		,
    input	wire [31:0]	  mem_rd_data_i		,
    //write mem
    output  wire	 	      mem_wr_req_o		,
    output  wire  [3:0]   mem_wr_sel_o		,
    output  wire  [31:0]  mem_wr_addr_o		,
    output  wire  [31:0]  mem_wr_data_o
  );

  //pc to rom
  wire [31:0] pc_reg_pc_o;
  assign inst_addr_o = pc_reg_pc_o;

  //if to if_id
  wire [31:0]  if_inst_addr_o;
  wire [31:0]  if_inst_o;

  //if_id to id

  wire [31:0]  if_id_inst_addr_o;
  wire [31:0]  if_id_inst_o;

  //ex to regs
  wire [4:0]  ex_rdaddr_o;
  wire [31:0] ex_rddata_o;
  wire 		ex_rd_wen_o;

  //id to regs
  wire [4:0] id_rs1_addr_o;
  wire [4:0] id_rs2_addr_o;

  //id to id_ex
  wire [31:0] id_inst_addr_o;
  wire [31:0] id_inst_o;
  wire [31:0] id_rs1_data_o;
  wire [31:0] id_rs2_data_o;

  wire [31:0] id_op1_o;
  wire [31:0] id_op2_o;
  wire [31:0] id_op1_jump_o;
  wire [31:0] id_op2_jump_o;

  wire id_rd_wen_o ;
  wire [31:0] id_rd_wdata_o;
  wire [4:0] id_rd_waddr_o;

  //id_ex to ex
  wire  [  31: 0]        id_ex_op1_o       ;
  wire [  31: 0]        id_ex_op2_o        ;
  wire [  31: 0]        id_ex_op1_jump_o   ;
  wire [  31: 0]        id_ex_op2_jump_o   ;
  wire [  31: 0]        id_ex_inst_addr_o  ;
  wire [  31: 0]        id_ex_inst_o       ;
  wire                  id_ex_reg_we_o     ;
  wire [   4: 0]        id_ex_reg_waddr_o  ;


  //ex to regs
  wire                  ex_rd_we_o                    ;
  wire  [   4: 0]        ex_rd_waddr_o                ;
  wire [  31: 0]         ex_rd_data_o                 ;

  //ex to mems
  wire                  ex_mem_we_o                   ;
  wire   [   31: 0]      ex_mem_waddr_o                ;
  wire   [   3: 0]      ex_mem_w_sel_o                ;
  wire   [  31: 0]       ex_mem_data_o                ;


  wire    [  31: 0]         ex_jump_addr_o            ;
  wire                      ex_jump_flag_o            ;
  wire                      ex_hold_flag_o            ;


  wire         [  31: 0]         ex_op1_o                ;
  wire         [  31: 0]         ex_op2_o                ;
  wire         [  31: 0]         ex_op1_jump_o           ;
  wire         [  31: 0]         ex_op2_jump_o           ;

  wire       [  31: 0]         ex_inst_addr_o            ;
  wire        [  31: 0]        ex_inst_o					;

  //ex_me
  wire         [  31: 0]         ex_me_op1_o                      ;
  wire         [  31: 0]         ex_me_op2_o                      ;
  wire         [  31: 0]         ex_me_op1_jump_o                 ;
  wire         [  31: 0]         ex_me_op2_jump_o                 ;

  wire         [  31: 0]         ex_me_inst_addr_o               ;
  wire         [  31: 0]         ex_me_inst_o                    ;


  wire                         ex_me_rd_we_o                   ;
  wire        [  4: 0]        ex_me_rd_waddr_o                ;
  wire        [  31: 0]        ex_me_rd_data_o                 ;


  wire                         ex_me_mem_we_o                  ;
  wire        [   31: 0]        ex_me_mem_waddr_o               ;
  wire        [   3: 0]        ex_me_mem_w_sel_o               ;
  wire        [  31: 0]        ex_me_mem_data_o                ;


  wire        [  31: 0]        ex_me_jump_addr_o               ;
  wire                         ex_me_jump_flag_o               ;
  wire                         ex_me_hold_flag_o               ;

  //me
  wire                	me_rd_we_o             ;
  wire   [   4: 0]        me_rd_waddr_o          ;
  wire   [  31: 0]        me_rd_data_o           ;


  wire                     me_mem_we_o           ;
  wire   [   4: 0]        me_mem_waddr_o         ;
  wire   [   3: 0]        me_mem_w_sel_o         ;
  wire   [  31: 0]        me_mem_data_o          ;


  wire   [  31: 0]        me_jump_addr_o         ;
  wire                    me_jump_flag_o         ;
  wire                    me_hold_flag_o         ;

  //me to wb
  wire					me_we_rd_we_o;
  wire	[4:0]			me_we_rd_waddr_o;
  wire	[31:0]			me_we_rd_data_o;

  //regs to id
  wire[31:0] regs_rs1_rdata_o;
  wire[31:0] regs_rs2_rdata_o;

  //ctrl to pc_reg
  wire[31:0] ctrl_jump_addr_o;
  wire  	   ctrl_jump_en_o;
  //ctrl to if_id id_ex
  wire 	   ctrl_hold_flag_o;

  //reg to id
  wire [31:0]reg_rs1_data_o;
  wire [31:0]reg_rs2_data_o;

  wire wb_rd_we_o;
  wire [4:0] wb_rd_waddr_o;
  wire [31:0]  wb_rd_data_o ;

  pc pc_inst(
       .clk            (clk)  ,
       .rst_n          (rst_n) ,
       .jump_addr_i    (ctrl_jump_addr_o) ,
       .jump_en_i      (ctrl_jump_en_o)  ,
       .pc_out         (pc_reg_pc_o)


     );

  if_id if_id_inst(
          .clk          (clk),
          .rst_n        (rst_n  ),
          .inst_i       (inst_i),
          .inst_addr_i  (pc_reg_pc_o),
          .inst_o       (if_inst_o),
          .inst_addr_o  (if_inst_addr_o)
        );

  id id_inst(
       .inst_i      (if_inst_o),
       .inst_addr_i (if_inst_addr_o),
       .rs1_data_i  (regs_rs1_rdata_o),
       .rs2_data_i  (regs_rs2_rdata_o),
       .op1_o       (id_op1_o),
       .op2_o       (id_op2_o),
       .op1_jump_o  (id_op1_jump_o),
       .op2_jump_o  (id_op2_jump_o),
       .inst_addr_o (id_inst_addr_o),
       .inst_o      (id_inst_o),
       .rs1_addr_o  (id_rs1_addr_o),
       .rs2_addr_o  (id_rs2_addr_o),
       .rs1_data_o  (id_rs1_data_o),
       .rs2_data_o  (id_rs2_data_o),
       .reg_we_o    (id_rd_wen_o),
       .reg_waddr_o (id_rd_waddr_o)

     );

  id_ex id_ex_inst(
          .clk          (clk),
          .rst_n        (rst_n),
          .op1_i        (id_op1_o),
          .op2_i        (id_op2_o),
          .op1_jump_i   (id_op1_jump_o),
          .op2_jump_i   (id_op2_jump_o),
          .inst_addr_i  (id_inst_addr_o),
          .inst_i       (id_inst_o),
          .reg_we_i     (id_rd_wen_o),
          .reg_waddr_i  (id_rd_waddr_o),

          .op1_o         (id_ex_op1_o),
          .op2_o         (id_ex_op2_o),
          .op1_jump_o    (id_ex_op1_jump_o),
          .op2_jump_o    (id_ex_op2_jump_o),
          .inst_addr_o   (id_ex_inst_addr_o),
          .inst_o        (id_ex_inst_o),
          .reg_we_o      (id_ex_reg_we_o),
          .reg_waddr_o   (id_ex_reg_waddr_o)

        );

  ex ex_inst(
       .clk         (clk),
       .rst_n       (rst_n),
       .op1_i       (id_ex_op1_o),
       .op2_i       (id_ex_op2_o),
       .op1_jump_i  (id_ex_op1_jump_o),
       .op2_jump_i  (id_ex_op2_jump_o),
       .inst_addr_i (id_ex_inst_addr_o),
       .inst_i      (id_ex_inst_o),
       .reg_we_i    (id_ex_reg_we_o),
       .reg_waddr_i (id_ex_reg_waddr_o),
       .mem_data_i  (mem_rd_data_i),  //
       .rd_we_o       (ex_rd_we_o),
       .rd_waddr_o    (ex_rd_waddr_o),
       .rd_data_o     (ex_rd_data_o),
       .mem_we_o     (ex_mem_we_o),
       .mem_waddr_o  (ex_mem_waddr_o),
       .mem_w_sel_o  (ex_mem_w_sel_o),
       .mem_data_o   (ex_mem_data_o),
       .jump_addr_o  (ex_jump_addr_o),
       .jump_flag_o  (ex_jump_flag_o),
       .hold_flag_o  (ex_hold_flag_o),
       .op1_o        (ex_op1_o),
       .op2_o        (ex_op2_o),
       .op1_jump_o   (ex_op1_jump_o),
       .op2_jump_o   (ex_op2_jump_o),
       .inst_addr_o  (ex_inst_addr_o),
       .inst_o       (ex_inst_o)

     );

  ex_me ex_me_inst(
          .clk          (clk),
          .rst_n        (rst_n),
          .inst_addr_i  (ex_inst_addr_o),
          .inst_i       (ex_inst_o),
          .rd_we_i      (ex_rd_we_o),
          .rd_waddr_i   (ex_rd_waddr_o),
          .rd_data_i    (ex_rd_data_o),
          .mem_we_i     (ex_mem_we_o),
          .mem_waddr_i  (ex_mem_waddr_o),
          .mem_w_sel_i  (ex_mem_w_sel_o),
          .mem_data_i   (ex_mem_data_o),
          .jump_addr_i  (ex_jump_addr_o),
          .jump_flag_i  (ex_jump_flag_o),
          .hold_flag_i  (ex_hold_flag_o),
          .op1_i        (ex_op1_o),
          .op2_i        (ex_op2_o),
          .op1_jump_i   (ex_op1_jump_o),
          .op2_jump_i  (ex_op2_jump_o),
          .op1_o        (ex_me_op1_o),
          .op2_o        (ex_me_op2_o),
          .op1_jump_o   (ex_me_op1_jump_o),
          .op2_jump_o   (ex_me_op2_jump_o),
          .inst_addr_o  (ex_me_inst_addr_o),
          .inst_o       (ex_me_inst_o),
          .rd_we_o      (ex_me_rd_we_o),
          .rd_waddr_o   (ex_me_rd_waddr_o),
          .rd_data_o    (ex_me_rd_data_o),
          .mem_we_o     (ex_me_mem_we_o),
          .mem_waddr_o  (ex_me_mem_waddr_o),
          .mem_w_sel_o  (ex_me_mem_w_sel_o),
          .mem_data_o   (ex_me_mem_data_o),
          .jump_addr_o  (ex_me_jump_addr_o),
          .jump_flag_o  (ex_me_jump_flag_o),
          .hold_flag_o  (ex_me_hold_flag_o)

        );
  me me_inst(
       .clk        (clk),
       .rst_n      (rst_n),
       .op1_i      (ex_me_op1_o),
       .op2_i      (ex_me_op2_o),
       .op1_jump_i (ex_me_op1_jump_o),
       .op2_jump_i (ex_me_op2_jump_o),
       .inst_addr_i(ex_me_inst_addr_o),
       .inst_i     (ex_me_inst_o),
       .rd_we_i    (ex_me_rd_we_o),
       .rd_waddr_i (ex_me_rd_waddr_o),
       .rd_data_i  (ex_me_rd_data_o),
       .mem_we_i   (ex_me_mem_we_o),
       .mem_waddr_i(ex_me_mem_waddr_o),
       .mem_w_sel_i(ex_me_mem_w_sel_o),
       .mem_data_i (ex_me_mem_data_o),
       .jump_addr_i(ex_me_jump_addr_o),
       .jump_flag_i(ex_me_jump_flag_o),
       .hold_flag_i(ex_me_hold_flag_o),
       .rd_we_o    (me_rd_we_o),
       .rd_waddr_o (me_rd_waddr_o),
       .rd_data_o  (me_rd_data_o),
       .mem_we_o   (mem_wr_req_o),
       .mem_waddr_o(mem_wr_addr_o),
       .mem_w_sel_o(mem_wr_sel_o),
       .mem_data_o (mem_wr_data_o),
       .jump_addr_o(me_jump_addr_o),
       .jump_flag_o(me_jump_flag_o),
       .hold_flag_o(me_hold_flag_o)

     );

  me_we me_wb_inst(
          .clk        (clk),
          .rst_n      (rst_n),
          .rd_we_i    (me_rd_we_o),
          .rd_waddr_i (me_rd_waddr_o),
          .rd_data_i  (me_rd_data_o),
          .rd_we_o    (me_we_rd_we_o),
          .rd_waddr_o (me_we_rd_waddr_o),
          .rd_data_o  (me_we_rd_data_o)

        );

  wb wb_inst(
       .clk        (clk),
       .rst_n      (rst_n),
       .rd_we_i    (me_we_rd_we_o),
       .rd_waddr_i (me_we_rd_waddr_o),
       .rd_data_i  (me_we_rd_data_o),
       .rd_we_o    (wb_rd_we_o),
       .rd_waddr_o (wb_rd_waddr_o),
       .rd_data_o  (wb_rd_data_o)

     );

  ctrl ctrl_inst(
         .jump_addr_i(ex_jump_addr_o),
         .jump_en_i(ex_jump_flag_o),
         .hold_flag_ex_i (ex_hold_flag_o),
         .jump_addr_o(ctrl_jump_addr_o),
         .jump_en_o(ctrl_jump_en_o),
         .hold_flag_o	   (ctrl_hold_flag_o)


       );

  regs regs_inst(
         .clk         (clk),
         .rst_n       (rst_n),
         .rs1_addr_i  (id_rs1_addr_o),
         .rs2_addr_i  (id_rs2_addr_o),
         .rs1_data_o  (regs_rs1_rdata_o),
         .rs2_data_o  (regs_rs2_rdata_o),
         .rd_waddr_i  (ex_rd_waddr_o),
         .rd_data_i   (ex_rd_data_o),
         .rd_we_i     (ex_rd_we_o)


       );

endmodule
