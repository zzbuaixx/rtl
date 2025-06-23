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
// Last modified Date:     2025/05/29 18:11:00
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/29 18:11:00
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              mem.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\mem.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module mem(
    input                               clk                        ,
    input                               rst_n                      ,
    input              [  31: 0]        w_addr_i                   ,// write address
    input              [  31: 0]        w_data_i                   ,// write data
    input              [   3: 0]        w_en_i                     ,// write enable
    input              [  31: 0]        r_addr_i                   ,// read address
    input                                r_en_i                     ,// read enable
    output             [  31: 0]        r_data_o
  );

  wire[11:0] w_addr =w_addr_i[11:0];
  wire[11:0] r_addr =r_addr_i[11:0];

  dual_ram #(
             .DATA_WIDTH(8),
             .ADDR_WIDTH(12)

           ) dual_ram_0 (
             .clk(clk),
             .rst_n(rst_n),
             .w_en(w_en_i[0]),
             .w_addr_i(w_addr),
             .w_data_i(w_data_i[7:0]),
             .r_en(r_en_i),
             .r_addr_i(r_addr),
             .r_data_o(r_data_o[7:0])
           );
  dual_ram #(
             .DATA_WIDTH(8),
             .ADDR_WIDTH(12)

           ) dual_ram_1 (
             .clk(clk),
             .rst_n(rst_n),
             .w_en(w_en_i[1]),
             .w_addr_i(w_addr),
             .w_data_i(w_data_i[15:8]),
             .r_en(r_en_i),
             .r_addr_i(r_addr),
             .r_data_o(r_data_o[15:8])
           );

  dual_ram #(
             .DATA_WIDTH(8),
             .ADDR_WIDTH(12)

           ) dual_ram_2 (
             .clk(clk),
             .rst_n(rst_n),
             .w_en(w_en_i[2]),
             .w_addr_i(w_addr),
             .w_data_i(w_data_i[23:16]),
             .r_en(r_en_i),
             .r_addr_i(r_addr),
             .r_data_o(r_data_o[23:16])
           );

  dual_ram #(
             .DATA_WIDTH(8),
             .ADDR_WIDTH(12)

           ) dual_ram_3 (
             .clk(clk),
             .rst_n(rst_n),
             .w_en(w_en_i[3]),
             .w_addr_i(w_addr),
             .w_data_i(w_data_i[31:24]),
             .r_en(r_en_i),
             .r_addr_i(r_addr),
             .r_data_o(r_data_o[31:24])
           );

endmodule
