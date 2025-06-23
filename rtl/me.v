`include "defines.v" //定义文件
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
// Last modified Date:     2025/06/07 20:32:35
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/06/07 20:32:35
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              ME.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\ME.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//
//该模块是执行L型指令和S型指令 并且把rd寄存器打拍  组合逻辑

module me(
    input                               clk                        ,
    input                               rst_n                      ,

    input              [  31: 0]         op1_i                      ,
    input              [  31: 0]         op2_i                      ,
    input              [  31: 0]         op1_jump_i                 ,
    input              [  31: 0]         op2_jump_i                 ,

    input              [  31: 0]        inst_addr_i                ,
    input              [  31: 0]        inst_i                     ,
    //from ex
    input                               rd_we_i                    ,//写寄存器标志
    input              [   4: 0]        rd_waddr_i                 ,//写寄存器地址
    input              [  31: 0]        rd_data_i                  ,//写寄存器数据

    input                               mem_we_i                   ,//写内存器标志
    input              [   31: 0]        mem_waddr_i                ,//写内存器地址
    input              [   3: 0]        mem_w_sel_i                ,//写选择器
    input              [  31: 0]        mem_data_i                 ,//写内存数据


    input              [  31: 0]        jump_addr_i                ,//跳转的地址
    input                               jump_flag_i                ,//跳转标志
    input                               hold_flag_i                ,//暂停标志;

    // output             [  31: 0]        inst_addr_o                ,
    // output             [  31: 0]        inst_o                     ,

    //to reg
    output      reg                    rd_we_o                    ,//写寄存器标志
    output      reg    [   4: 0]        rd_waddr_o                 ,//写寄存器地址
    output      reg    [  31: 0]        rd_data_o                  ,//写寄存器数据

    //to mem
    output      reg                      mem_we_o                   ,//写内存器标志
    output      reg    [   31: 0]        mem_waddr_o                ,//写内存器地址
    output      reg    [   3: 0]        mem_w_sel_o                ,//写选择器
    output      reg    [  31: 0]        mem_data_o                 ,//写内存数据

    //to ctrl
    output      reg    [  31: 0]        jump_addr_o                ,//跳转的地址
    output      reg                     jump_flag_o                ,//跳转标志
    output      reg                     hold_flag_o                 //暂停标志;
  );
  //操作码   （立即数指令、寄存器指令、控制转移指令、、、）指出该指令需要完成操作的类型或性质；
  wire               [   6: 0]        opcode=inst_i[6:0]          ;
  wire               [   2: 0]        funct3=inst_i[14:12]        ;//功能1    （立即数：加法、无符号比较、有符号比较、、、）

  wire  [31:0] addr_offset = op1_jump_i + op2_jump_i; //跳转地址计算
  //用于load指令的地址计算
  wire [1:0]ld_addr_sel = addr_offset[1:0]; //地址选择器
  wire [1:0]st_addr_sel = addr_offset[1:0]; //地址选择器


  always@(*)
  begin
    case (opcode)
      `INST_TYPE_L:
      begin
        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = mem_waddr_i; //I类型指令不写内存
        mem_w_sel_o = mem_w_sel_i; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停

        case (funct3)
          3'b000 : //lb
          begin
            rd_we_o = rd_we_i; //写寄存器标志
            rd_waddr_o=rd_waddr_i;
            case (ld_addr_sel)
              2'b00:
              begin
                rd_data_o = {{24{mem_data_i[7]}},mem_data_i[7:0]}; //符号扩展
              end
              2'b01:
              begin
                rd_data_o = {{24{mem_data_i[15]}},mem_data_i[15:8]}; //符号扩展
              end
              2'b10:
              begin
                rd_data_o = {{24{mem_data_i[23]}},mem_data_i[23:16]}; //符号扩展

              end
              2'b11:
              begin
                rd_data_o = {{24{mem_data_i[31]}},mem_data_i[31:24]}; //符号扩展
              end

              default:
              begin
                rd_data_o=32'b0;
              end
            endcase
          end
          3'b001 : //lh
          begin
            rd_we_o = rd_we_i; //写寄存器标志
            rd_waddr_o=rd_waddr_i;
            case(ld_addr_sel[1])
              1'b0:
              begin
                rd_data_o = {{16{mem_data_i[15]}},mem_data_i[15:0]}; //符号扩展
              end
              1'b1:
              begin
                rd_data_o = {{16{mem_data_i[31]}},mem_data_i[31:16]}; //符号扩展
              end
              default:
              begin
                rd_data_o = 32'b0 ; //符号扩展
              end
            endcase
          end
          3'b010 : //lw
          begin
            rd_we_o = rd_we_i; //写寄存器标志
            rd_waddr_o=rd_waddr_i;
            rd_data_o = mem_data_i; //直接读取内存数据
          end
          3'b100 : //lbu
          begin
            rd_we_o = rd_we_i; //写寄存器标志
            rd_waddr_o=rd_waddr_i;
            case (ld_addr_sel)
              2'b00:
              begin
                rd_data_o = {24'b0,mem_data_i[7:0]}; //符号扩展
              end
              2'b01:
              begin
                rd_data_o = {24'b0,mem_data_i[15:8]}; //符号扩展
              end
              2'b10:
              begin
                rd_data_o = {24'b0,mem_data_i[23:16]}; //符号扩展

              end
              2'b11:
              begin
                rd_data_o = {24'b0,mem_data_i[31:24]}; //符号扩展
              end

              default:
              begin
                rd_data_o=32'b0;
              end
            endcase
          end
          3'b101: //lhu
          begin
            rd_we_o = rd_we_i; //写寄存器标志
            rd_waddr_o=rd_waddr_i;
            case(ld_addr_sel[1])
              1'b0:
              begin
                rd_data_o = {16'b0,mem_data_i[15:0]}; //符号扩展
              end
              1'b1:
              begin
                rd_data_o = {16'b0,mem_data_i[31:16]}; //符号扩展
              end
              default:
              begin
                rd_data_o = 32'b0 ; //符号扩展
              end
            endcase
          end
          default:
          begin
            rd_we_o = `WriteDisable; //写寄存器标志
            rd_waddr_o=`ZeroReg; //写寄存器地址
            rd_data_o = 32'b0; //I类型指令不写寄存器
          end
        endcase
      end
      `INST_TYPE_S:
      begin
        rd_we_o = 1'b0; //I类型指令不写内存
        rd_waddr_o = `ZeroReg; //I类型指令不写内存

        rd_data_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = mem_w_sel_i; //I类型指令不写内存
        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停
        case ( funct3)
          `INST_SB:
          begin
            mem_we_o=`WriteEnable; //写内存标志
            mem_waddr_o=mem_waddr_i; //写内存地址
            case (st_addr_sel)
              2'b00:
              begin
                mem_data_o = {mem_data_o[31:8],op2_i[7:0]}; //符号扩展
              end
              2'b01:
              begin
                mem_data_o = {mem_data_o[31:16],op2_i[15:8],mem_data_o[7:0]}; //符号扩展
              end
              2'b10:
              begin
                mem_data_o = {mem_data_o[31:24],op2_i[23:16],mem_data_o[15:0]}; //符号扩展

              end
              2'b11:
              begin
                mem_data_o = {op2_i[31:24],mem_data_i[23:0]}; //符号扩展
              end

              default:
              begin
                mem_data_o=32'b0;
              end
            endcase
          end
          `INST_SH:
          begin
            mem_we_o = `WriteEnable; //写寄存器标志
            mem_waddr_o=mem_waddr_i;
            case(st_addr_sel[1])
              1'b0:
              begin
                mem_data_o = {mem_data_i[31:16],op2_i[15:0]}; //符号扩展
              end
              1'b1:
              begin
                mem_data_o = {op2_i[31:16],mem_data_i[15:0]}; //符号扩展
              end
              default:
              begin
                rd_data_o = 32'b0 ; //符号扩展
              end
            endcase
          end
          `INST_SW:
          begin
            mem_we_o = `WriteEnable; //写寄存器标志
            mem_waddr_o=mem_waddr_i;
            mem_data_o = op2_i; //直接读取内存数据
          end
          default:
          begin
            mem_we_o=`WriteDisable; //写内存标志
            mem_waddr_o=mem_waddr_i; //写内存地址
            mem_data_o=32'b0;
          end
        endcase
      end
      default:
      begin

      end
    endcase


  end
endmodule
