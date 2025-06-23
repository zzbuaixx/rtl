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
// Last modified Date:     2025/05/23 11:29:19
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/23 11:29:19
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              dff.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\dff.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module dff #(
    parameter WIDTH = 32
  )
  (
    input                               clk                        ,
    input                               rst_n                      ,
    input          [WIDTH-1:0]          def_value                  ,
    input          [WIDTH-1:0]          d                          ,
    output         [WIDTH-1:0]          q
  );

    reg [WIDTH-1:0]          q_r;
  always @(posedge clk or negedge rst_n)
  begin
    if(!rst_n)
      q_r<=def_value; // 复位时使用nop指令
    else
      q_r<=d;
  end

  assign q = q_r ;

endmodule
