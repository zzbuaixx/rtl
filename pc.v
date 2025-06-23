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
// Last modified Date:     2025/05/23 09:55:23
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/23 09:55:23
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              pc.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\pc.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module pc(
    input                               clk                        ,
    input                               rst_n                      ,
    input              [  31: 0]        jump_addr_i                ,
    input                               jump_en_i                  ,// 跳转标志
    output reg         [  31: 0]        pc_out                       
  );



  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      pc_out <= 32'h0000_0000;

    else if(jump_en_i)
      pc_out<=jump_addr_i;
    else

      pc_out <= pc_out + 3'd4; // PC+4
  end
  
endmodule
