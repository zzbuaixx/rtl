`timescale 1ns / 1ps
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
// Last modified Date:     2025/05/23 12:13:54
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/23 12:13:54
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              id.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\id.v
// Descriptions:
//      +++表示不懂
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module id(
    //from if_id
    input              [  31: 0]        inst_i                     ,
    input              [  31: 0]        inst_addr_i                ,
    //from regs
    input              [  31: 0]        rs1_data_i                 ,//寄存器输入数据1
    input              [  31: 0]        rs2_data_i                 ,//寄存器输入数据2

    // from csr reg +++
    // input  wire        [  31: 0]        csr_rdata_i                ,// CSR寄存器输入数据

    //----------------------------以上输入----------以下输出--------------------------------------------------
    //to regs
    output reg         [   4: 0]        rs1_addr_o                 ,
    output reg         [   4: 0]        rs2_addr_o                 ,

    //to csr
    output reg         [   4: 0]        csr_raddr_o                ,


    //to execute
    output reg         [  31: 0]        op1_o                      ,
    output reg         [  31: 0]        op2_o                      ,
    output reg         [  31: 0]        op1_jump_o                 ,
    output reg         [  31: 0]        op2_jump_o                 ,

    output reg         [  31: 0]        inst_addr_o                ,
    output reg         [  31: 0]        inst_o                     ,

    output reg         [  31: 0]        rs1_data_o                 ,//寄存器输入数据1
    output reg         [  31: 0]        rs2_data_o                 ,//寄存器输入数据2

    output reg                          reg_we_o                   ,//写寄存器标志
    output reg         [   4: 0]        reg_waddr_o                ,//写寄存器地址
    // output reg                          csr_we_o                   ,//写csr寄存器标志
    // output reg         [  31: 0]        csr_rdata_o                ,// CSR寄存器数据      与输入时内容相同
    output reg         [   4: 0]        csr_waddr_o                 // 写CSR寄存器地址
  );


  //将指令分为各个部部分
  //function7 rs2 rs1 funct3  rd opcode

  wire               [   6: 0]        funct7=inst_i[31:25]        ;
  wire               [   4: 0]        rs2=inst_i[24:20]           ;//源寄存器2、立即数
  wire               [   4: 0]        rs1=inst_i[19:15]           ;//源寄存器1、立即数
  wire               [   2: 0]        funct3=inst_i[14:12]        ;//功能1    （立即数：加法、无符号比较、有符号比较、、、）
  wire               [   4: 0]                    rd=inst_i[11:7]             ;//目标寄存器、立即数
  wire               [   6: 0]        opcode=inst_i[6:0]          ;//操作码   （立即数指令、寄存器指令、控制转移指令、、、）指出该指令需要完成操作的类型或性质；

  always@( *)
  begin
    inst_o=inst_i;
    inst_addr_o=inst_addr_i;
    rs1_data_o=rs1_data_i;
    rs2_data_o=rs2_data_i;
    // csr_rdata_o  = csr_rdata_i;
    csr_raddr_o  = `ZeroWord; //32'h0
    csr_waddr_o  = `ZeroWord;
    //csr_we_o     = `WriteDisable;//1'b0
    op1_o        = `ZeroWord;
    op2_o        = `ZeroWord;
    op1_jump_o   = `ZeroWord;
    op2_jump_o   = `ZeroWord;
    case (opcode)
      `INST_TYPE_I :
      begin
        case(funct3)
          //当多个条件选项下需要执行相同的语句时，多个条件选项可以用逗号分开，放在同一个语句块的候选项中。
          `INST_ADDI, `INST_SLTI, `INST_SLTIU, `INST_XORI, `INST_ORI, `INST_ANDI, `INST_SLLI, `INST_SRI://因为SRLI和 SRAI的funct3相同，所以把他们合并
          begin
            reg_we_o = `WriteEnable; //1'b1
            reg_waddr_o = rd;
            rs1_addr_o = rs1;
            rs2_addr_o = `ZeroReg;
            op1_o = rs1_data_i;
            op2_o = {{20{inst_i[31]}}, inst_i[31:20]}; //立即数扩展
            //不进行跳转
            op1_jump_o = 32'b0; //
            op2_jump_o = 32'b0; //
          end


          default:

          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = `ZeroReg;
            rs2_addr_o = `ZeroReg;
            op1_jump_o = 32'b0; //
            op2_jump_o = 32'b0; //
          end
        endcase
      end
      //第二个大类 R and M type inst
      `INST_TYPE_R_M :
      begin
        if(funct7 == 7'b0000_000 || funct7 == 7'b0100_000)   //R type inst
        begin
          case(funct3)
            `INST_ADD_SUB, `INST_SLT, `INST_SLTU, `INST_XOR,`INST_OR, `INST_AND: //因为SRL和SRA的funct3相同，所以把他们合并
            begin
              reg_we_o = `WriteEnable; //1'b1
              reg_waddr_o = rd;
              rs1_addr_o = rs1;
              rs2_addr_o = rs2;
              op1_o = rs1_data_i;
              op2_o = rs2_data_i;
              op1_jump_o = 32'b0; //
              op2_jump_o = 32'b0; //
            end
            `INST_SLL,`INST_SR:
            begin
              reg_we_o = `WriteEnable; //1'b1
              reg_waddr_o = rd;
              rs1_addr_o = rs1;
              rs2_addr_o = rs2;
              op1_o = rs1_data_i;
              op2_o = {27'b0,rs2_data_i[4:0]}; //只取低5位
              op1_jump_o = 32'b0; //
              op2_jump_o = 32'b0; //
            end
            default:
            begin
              reg_we_o = `WriteDisable;
              reg_waddr_o = `ZeroReg;
              rs1_addr_o = `ZeroReg;
              rs2_addr_o = `ZeroReg;
              op1_jump_o = 32'b0; //
              op2_jump_o = 32'b0; //
            end
          endcase

        end
        else if (funct7 == 7'b0000_001) //M typr inst 未完成 待写
        begin
                //M指令 乘除法拓展指令
          case (funct3)
            `INST_MUL, `INST_MULHU, `INST_MULH, `INST_MULHSU:
            begin
              reg_we_o = `WriteEnable;
              reg_waddr_o = rd;
              rs1_addr_o = rs1;
              rs2_addr_o = rs2;
              op1_o = rs1_data_i;
              op2_o = rs2_data_i;
            end
            
            default:
            begin
              reg_we_o = `WriteDisable;
              reg_waddr_o = `ZeroReg;
              rs1_addr_o = `ZeroReg;
              rs2_addr_o = `ZeroReg;
            end
          endcase
        
        end

        else
        begin
          reg_we_o = `WriteDisable;
          reg_waddr_o = `ZeroReg;
          rs1_addr_o = `ZeroReg;
          rs2_addr_o = `ZeroReg;
          op1_jump_o = 32'b0; //
          op2_jump_o = 32'b0; //
        end
      end



      `INST_TYPE_B : //B type inst
      begin
        case(funct3)
          `INST_BEQ, `INST_BNE, `INST_BLT, `INST_BGE, `INST_BLTU, `INST_BGEU:
          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = rs1;
            rs2_addr_o = rs2;
            op1_o 	   = rs1_data_i;
            op2_o      = rs2_data_i;
            op1_jump_o = inst_addr_i;
            //imm[12|10:5|4:1|11] = inst_i[31|30:25|11:8|7]
            op2_jump_o = {{19{inst_i[31]}},inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8],1'b0}; //立即数扩展
          end
          default:
          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = `ZeroReg;
            rs2_addr_o = `ZeroReg;
            op1_jump_o = 32'b0; //
            op2_jump_o = 32'b0; //
          end
        endcase


      end
      `INST_TYPE_L : //L type inst

      begin
        case(funct3)
          `INST_LB, `INST_LH, `INST_LW, `INST_LBU, `INST_LHU:
          begin
            reg_we_o = `WriteEnable; //1'b1
            reg_waddr_o = rd;
            rs1_addr_o = rs1;
            rs2_addr_o = `ZeroReg;
            op1_o = 32'b0;
            op2_o = 32'b0; //立即数扩展
            op1_jump_o = rs1_data_i; //
            op2_jump_o = {{20{inst_i[31]}}, inst_i[31:20]}; //
          end
          default:
          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = `ZeroReg;
            rs2_addr_o = `ZeroReg;
            op1_jump_o = 32'b0; //
            op2_jump_o = 32'b0; //
          end
        endcase
      end

      `INST_TYPE_S : //S type inst
      begin
        case (funct3)
          `INST_SB, `INST_SH, `INST_SW:
          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = rs1;
            rs2_addr_o = rs2;
            op1_o = 32'b0;
            op2_o = rs2_data_i; //立即数扩展
            op1_jump_o = rs1_data_i; //
            op2_jump_o = {{20{inst_i[31]}}, inst_i[31:25], inst_i[11:7]}; //
          end
          default:
          begin
            reg_we_o = `WriteDisable;
            reg_waddr_o = `ZeroReg;
            rs1_addr_o = `ZeroReg;
            rs2_addr_o = `ZeroReg;
            op1_jump_o = 32'b0; //
            op2_jump_o = 32'b0; //
          end
        endcase
      end
      //J type inst
      `INST_JAL :
      begin
        reg_we_o = `WriteEnable; //1'b1
        reg_waddr_o = rd;
        rs1_addr_o = `ZeroReg;
        rs2_addr_o = `ZeroReg;
        op1_o = inst_addr_i; //当前指令地址
        op2_o = 3'd4; //加4
        op1_jump_o = inst_addr_i; //当前指令地址
        //imm[20|10:1|11|19:12] = inst_i[31|30:21|20|20:12]
        op2_jump_o = {{11{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20], inst_i[30:21], 1'b0}; //立即数扩展
      end
      `INST_JALR :
      begin
        reg_we_o = `WriteEnable; //1'b1
        reg_waddr_o = rd;
        rs1_addr_o = rs1;
        rs2_addr_o = `ZeroReg;
        op1_o = inst_addr_i; //寄存器数据
        op2_o = 3'd4; //立即数扩展
        op1_jump_o = rs1_data_i; //寄存器数据
        op2_jump_o = {{20{inst_i[31]}}, inst_i[31:20]}; //立即数扩展

      end
      `INST_LUI :
      begin
        reg_we_o = `WriteEnable; //1'b1
        reg_waddr_o = rd;
        rs1_addr_o = `ZeroReg;
        rs2_addr_o = `ZeroReg;
        op1_o = {inst_i[31:12],12'b0}; //寄存器数据
        op2_o = 32'd0; //立即数扩展
        op1_jump_o = 32'b0; //
        op2_jump_o = 32'b0; //
      end
      `INST_AUIPC :
      begin
        reg_we_o = `WriteEnable; //1'b1
        reg_waddr_o = rd;
        rs1_addr_o = `ZeroReg;
        rs2_addr_o = `ZeroReg;
        op1_o = inst_addr_i; //寄存器数据
        op2_o = {inst_i[31:12],12'b0}; //立即数扩展
        op1_jump_o = 32'b0; //
        op2_jump_o = 32'b0; //
      end
      default:
      begin
        reg_we_o = `WriteDisable;
        reg_waddr_o = `ZeroReg;
        rs1_addr_o = `ZeroReg;
        rs2_addr_o = `ZeroReg;
        op1_jump_o = 32'b0; //
        op2_jump_o = 32'b0; //
      end
    endcase
  end

endmodule
