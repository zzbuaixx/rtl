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
// Last modified Date:     2025/05/29 18:31:14
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/29 18:31:14
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              dual_ram.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\dual_ram.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module dual_ram #
  (
    parameter                           DATA_WIDTH                 = 32    ,
    parameter                           ADDR_WIDTH                 = 12    ,
    parameter                           RAM_DEPTH                  = 1 << ADDR_WIDTH


  )(
    input                                        clk                        ,
    input                                        rst_n                      ,
    input                                        w_en                       , // write enable
    input              [ADDR_WIDTH-1: 0]         w_addr_i                   ,
    input              [DATA_WIDTH-1: 0]         w_data_i                   ,
    input                                        r_en                       ,
    input              [ADDR_WIDTH-1: 0]         r_addr_i                   ,
    output          [DATA_WIDTH-1: 0]         r_data_o
  );

  reg [DATA_WIDTH-1: 0] r_data;
  reg [DATA_WIDTH-1:0] memory [0:RAM_DEPTH-1]; // Memory array

  assign r_data_o = r_data;
  always@(posedge clk)
  begin
    if(rst_n && w_en)
    begin
      memory[w_addr_i] <= w_data_i; // Write data to memory
    end

  end

  always @(posedge clk )
  begin
    if(rst_n && r_en)     
    begin
      r_data <= memory[r_addr_i]; // Read data from memory
    end
    else
    begin
      r_data <= 0; // Reset output if not enabled
    end
  end

endmodule
