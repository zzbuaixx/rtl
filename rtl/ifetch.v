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
// Last modified Date:     2025/05/23 10:52:22
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/05/23 10:52:22
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              ifetch.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\ifetch.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ifetch(
    input [31:0]              pc_addr_i                       ,
    input [31:0]              inst_i                          ,
    output  [31:0]            inst_addr_o                     ,
    output  [31:0]            inst_o                          
);
                                                                   
assign inst_addr_o = pc_addr_i;    
assign inst_o = inst_i; // 直接输出指令          


endmodule