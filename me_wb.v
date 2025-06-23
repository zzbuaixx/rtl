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
// Last modified Date:     2025/06/08 16:05:16
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name 
// Created date:           2025/06/08 16:05:16
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              me_we.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\me_we.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module me_we(
    input               clk                        ,
    input               rst_n                      ,
    input              rd_we_i,           // ME阶段传来的写使能
    input      [4:0]   rd_waddr_i,        // ME阶段传来的写寄存器地址
    input      [31:0]  rd_data_i,         // ME阶段传来的写回数据 

    output              rd_we_o,           // ME阶段传来的写使能
    output      [4:0]   rd_waddr_o,        // ME阶段传来的写寄存器地址
    output      [31:0]  rd_data_o      // ME阶段传来的写回数据 
       
);
                                                                   
          
    dff #(
    1
    )
    dff1
    (
    .clk        (clk),
    .rst_n      (rst_n),
    .def_value  (1'b0)   ,
    .d          (rd_we_i)  ,
    .q          (rd_we_o)  
    );

        dff #(
    5
    )
    dff2
    (
    .clk        (clk),
    .rst_n      (rst_n),
    .def_value  (5'b0)   ,
    .d          (rd_waddr_i)  ,
    .q          (rd_waddr_o)  
    );

        dff #(
    32
    )
    dff3
    (
    .clk        (clk),
    .rst_n      (rst_n),
    .def_value  (32'b0)   ,
    .d          (rd_data_i)  ,
    .q          (rd_data_o)  
    );

endmodule