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
// Last modified Date:     2025/05/23 11:27:10
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/05/23 11:27:10
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              if_id.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\if_id.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module if_id(
    input                               clk                        ,
    input                               rst_n                      ,
    input              [31:0]           inst_i                     , 
    input              [31:0]           inst_addr_i                ,       
    output             [31:0]           inst_o                     ,
    output             [31:0]           inst_addr_o                              
);
    wire [31:0] inst;                                                               
     dff #(.WIDTH(32)) dff_inst(
        .clk(clk)                  ,
        .rst_n(rst_n)            ,
        .d(inst_i)               ,
        //`define INST_NOP    32'h00000001
        .def_value(`INST_NOP )  , // 复位时使用nop指令
        .q(inst)               // 取指令   
     );
    assign inst_o = inst ;
    wire [31:0] inst_addr;  
     dff #(.WIDTH(32)) dff_inst_addr(
        .clk(clk)                  ,
        .rst_n(rst_n)            ,
          //`define ZeroWord 32'h0
        .def_value(`ZeroWord )  , // 复位时使用0地址
        .d(inst_addr_i)          ,
        .q(inst_addr_o)          // 取指令地址
     );   
    assign inst_addr_o = inst_addr ;
     
endmodule