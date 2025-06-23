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
// Last modified Date:     2025/06/08 14:58:33
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/06/08 14:58:33
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              regs.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\regs.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module regs(
    input                               clk                        ,
    input                               rst_n                      ,

    //from id
    input              [   4: 0]        rs1_addr_i                 ,//寄存器rs1地址
    input              [   4: 0]        rs2_addr_i                 ,//寄存器rs2地址

    output reg         [  31: 0]        rs1_data_o                 ,//寄存器rs1数据
    output reg         [  31: 0]        rs2_data_o                 ,//寄存器rs2数据

    //from me

    input              [   4: 0]        rd_waddr_i                 ,//寄存器rd地址
    input              [  31: 0]        rd_data_i                  ,//寄存器rd数据
    input rd_we_i  //寄存器rd写使能
  );

  reg[31:0] regs[0:31];
  integer i;

  always@(*)
  begin
    if(rst_n==1'b0)
    begin
      rs1_data_o = `ZeroWord; //复位时寄存器清零
      regs[0] = 32'b0;
    end
    else if(rs1_addr_i == `ZeroReg) //如果是x0寄存器
      rs1_data_o = `ZeroWord;
    else if(rd_we_i && rd_waddr_i == rs1_addr_i)
      rs1_data_o = rd_data_i;
    else
      rs1_data_o = regs[rs1_addr_i] ;

  end

  always@(*)
  begin
    if(rst_n==1'b0)
      rs2_data_o = `ZeroWord; //复位时寄存器清零
    else if(rs2_addr_i == `ZeroReg) //如果是x0寄存器
      rs2_data_o = `ZeroWord;
    else if(rd_we_i && rd_waddr_i == rs2_addr_i)
      rs2_data_o = rd_data_i;
    else
      rs2_data_o = regs[rs2_addr_i];
  end



  always@(posedge clk)
  begin
    if(!rst_n)
    begin
      for(i=0;i<31;i=i+1)
      begin
        regs[i] <= 32'b0;
      end
    end

    else if(rd_we_i && rd_waddr_i != 5'b0)
    begin
      regs[rd_waddr_i] <= rd_data_i;
    end



  end

endmodule
