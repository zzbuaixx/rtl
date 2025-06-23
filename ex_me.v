`timescale 1ns / 1ps
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
// Last modified Date:     2025/06/07 20:35:53
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/06/07 20:35:53
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              ex_me.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\ex_me.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ex_me(
    input                               clk                        ,
    input                               rst_n                      ,

    input              [  31: 0]         inst_addr_i                ,
    input              [  31: 0]         inst_i                     ,
    //from ex
    input                               rd_we_i                    ,//写寄存器标志
    input              [   4: 0]        rd_waddr_i                 ,//写寄存器地址
    input              [  31: 0]        rd_data_i                  ,//写寄存器数据

    input                               mem_we_i                   ,//写内存器标志
    input              [  31: 0]        mem_waddr_i                ,//写内存器地址
    input              [   3: 0]        mem_w_sel_i                ,//写选择器
    input              [  31: 0]        mem_data_i                 ,//写内存数据


    input              [  31: 0]        jump_addr_i                ,//跳转的地址
    input                               jump_flag_i                ,//跳转标志
    input                               hold_flag_i                ,//暂停标志;


    //这些也不能少  后面得用到

    //from id_ex
    input              [  31: 0]         op1_i                      ,
    input              [  31: 0]         op2_i                      ,
    input              [  31: 0]         op1_jump_i                 ,
    input              [  31: 0]         op2_jump_i                 ,

    //同上
    //from id_ex
    output              [  31: 0]         op1_o                      ,
    output              [  31: 0]         op2_o                      ,
    output              [  31: 0]         op1_jump_o                 ,
    output              [  31: 0]         op2_jump_o                 ,

    output              [  31: 0]         inst_addr_o               ,
    output              [  31: 0]         inst_o                    ,

    //to reg
    output                              rd_we_o                    ,//写寄存器标志
    output             [   4: 0]        rd_waddr_o                 ,//写寄存器地址
    output             [  31: 0]        rd_data_o                  ,//写寄存器数据

    //to mem
    output                              mem_we_o                   ,//写内存器标志
    output             [  31: 0]        mem_waddr_o                ,//写内存器地址
    output             [   3: 0]        mem_w_sel_o                ,//写选择器
    output             [  31: 0]        mem_data_o                 ,//写内存数据

    //to ctrl
    output             [  31: 0]        jump_addr_o                ,//跳转的地址
    output                              jump_flag_o                ,//跳转标志
    output                              hold_flag_o                 //暂停标志;



  );


  dff #(
        .WIDTH(1)
      )
      dff1
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(1'b0)                   , // 复位时使用nop指令      ,
        .d        (rd_we_i)            ,
        .q        (rd_we_o)
      );

  dff #(
        .WIDTH(5)
      )
      dff2
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroReg)           , // 复位时使用nop指令      ,
        .d        (rd_waddr_i)         ,
        .q        (rd_waddr_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff3
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (rd_data_i)         ,
        .q        (rd_data_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff4
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (jump_addr_i)         ,
        .q        (jump_addr_o)
      );

  dff #(
        .WIDTH(1)
      )
      dff5
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(1'b0)           , // 复位时使用nop指令      ,
        .d        (jump_flag_i)         ,
        .q        (jump_flag_o)
      );

  dff #(
        .WIDTH(1)
      )
      dff6
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(1'b0)           , // 复位时使用nop指令      ,
        .d        (hold_flag_i)         ,
        .q        (hold_flag_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff7
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (inst_addr_i)         ,
        .q        (inst_addr_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff8
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`INST_NOP)           , // 复位时使用nop指令      ,
        .d        (inst_i)         ,
        .q        (inst_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff9
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (op1_i)         ,
        .q        (op1_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff10
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (op2_i)         ,
        .q        (op2_o)
      );


  dff #(
        .WIDTH(32)
      )
      dff11
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (op1_jump_i)         ,
        .q        (op1_jump_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff12
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (op2_jump_i)         ,
        .q        (op2_jump_o)
      );


  dff #(
        .WIDTH(1)
      )
      dff13
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(1'b0)           , // 复位时使用nop指令      ,
        .d        (mem_we_i)         ,
        .q        (mem_we_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff14
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (mem_waddr_i)         ,
        .q        (mem_waddr_o)
      );

  dff #(
        .WIDTH(4)
      )
      dff15
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(4'b0000)           , // 复位时使用nop指令      ,
        .d        (mem_w_sel_i)         ,
        .q        (mem_w_sel_o)
      );

  dff #(
        .WIDTH(32)
      )
      dff16
      (
        .clk      (clk)                ,
        .rst_n    (rst_n)              ,
        .def_value(`ZeroWord)           , // 复位时使用nop指令      ,
        .d        (mem_data_i)         ,
        .q        (mem_data_o)
      );




endmodule
