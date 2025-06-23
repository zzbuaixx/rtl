`include "defines.v"
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
// Last modified Date:     2025/05/28 15:26:02
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/28 15:26:02
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              id_ex.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\id_ex.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module id_ex(
    input                               clk                        ,
    input                               rst_n                      ,
    input              [  31: 0]        op1_i                      ,
    input              [  31: 0]        op2_i                      ,
    input              [  31: 0]        op1_jump_i                 ,
    input              [  31: 0]        op2_jump_i                 ,

    input              [  31: 0]        inst_addr_i                ,
    input              [  31: 0]        inst_i                     ,
   

    input                               reg_we_i                   ,//写寄存器标志
    input              [   4: 0]        reg_waddr_i                ,//写寄存器地址


    output              [  31: 0]        op1_o                      ,
    output              [  31: 0]        op2_o                      ,
    output              [  31: 0]        op1_jump_o                 ,
    output              [  31: 0]        op2_jump_o                 ,

    output              [  31: 0]        inst_addr_o                ,
    output              [  31: 0]        inst_o                     ,

   
    output                               reg_we_o                   ,//写寄存器标志
    output              [   4: 0]        reg_waddr_o                 //写寄存器地址



  );


   dff #(
      32
    )
     dff1
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(`INST_NOP)          , // 复位时使用nop指令      ,
      .d        (inst_i)             ,
      .q        (inst_o)
    );

    dff #(
      32
    )
     dff2
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(32'b0)          , // 复位时使用nop指令      ,
      .d        (op1_i)             ,
      .q        (op1_o)
    );

    dff #(
      32
    )
     dff3
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(32'b0)          , // 复位时使用0填充    ,
      .d        (op2_i)             ,
      .q        (op2_o)
    );

    dff #(
      32
    )
     dff4
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(32'b0)              , // 复位时使用0填充      ,
      .d        (op1_jump_i)         ,
      .q        (op1_jump_o)
    );

    dff #(
      32
    )
     dff5
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(32'b0)              , // 复位时使用0填充      ,
      .d        (op2_jump_i)         ,
      .q        (op2_jump_o)
    );

    dff #(
      32
    )
     dff6
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(32'b0)              , // 复位时使用0填充      ,
      .d        (inst_addr_i)         ,
      .q        (inst_addr_o)
    );

 

    dff #(
      1
    )
     dff7
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(1'b0)              , // 复位时使用0填充      ,
      .d        (reg_we_i)         ,
      .q        (reg_we_o)
    );

    dff #(
      5
    )
     dff8
    (
      .clk      (clk)                ,
      .rst_n    (rst_n)              ,
      .def_value(5'b0)              , // 复位时使用0填充      ,
      .d        (reg_waddr_i)         ,
      .q        (reg_waddr_o)
    );
  endmodule
