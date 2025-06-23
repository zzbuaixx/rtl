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
// Last modified Date:     2025/05/23 09:59:38
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/23 09:59:38
// mail      :             Please Write mail
// Version:                V1.0    
// TEXT NAME:              Instmem.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\Instmem.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module Instmem(
    input           [31:0]              instaddr                        ,
    output   reg    [31:0]              inst_out
  );

  reg [31:0] instmem [0:400]; //  instruction memory

  initial
  begin
    $readmemh("./generated/inst_data.txt", instmem); // Read instruction memory from file
  end

  always @(instaddr)
  begin
    inst_out[31:0]   <= instmem[instaddr>>2 ]; // 低位

  end
  /*
    //使用小端模式 高位放高位
    always @(instaddr) begin
      inst_out[7:0]   <= instmem[instaddr  + 3 ]; // 低位
      inst_out[15:8]  <= instmem[instaddr  + 2 ];
      inst_out[23:16] <= instmem[instaddr  + 1 ];
      inst_out[31:24] <= instmem[instaddr  + 0 ]; // 高位
    end
  */
endmodule
