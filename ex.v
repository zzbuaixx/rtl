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
// Last modified Date:     2025/05/28 16:13:27
// Last Version:           V1.0
// Descriptions:
//----------------------------------------------------------------------------------------
// Created by:             Please Write You Name
// Created date:           2025/05/28 16:13:27
// mail      :             Please Write mail
// Version:                V1.0
// TEXT NAME:              ex.v
// PATH:                   C:\Users\ZXJ\Desktop\riscv\ex.v
// Descriptions:
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ex(
    input                                clk                        ,
    input                                rst_n                      ,

    //from id_ex
    input              [  31: 0]         op1_i                      ,
    input              [  31: 0]         op2_i                      ,
    input              [  31: 0]         op1_jump_i                 ,
    input              [  31: 0]         op2_jump_i                 ,

    input              [  31: 0]         inst_addr_i                ,
    input              [  31: 0]         inst_i                     ,


    input                                reg_we_i                   ,//写寄存器标志
    input              [   4: 0]         reg_waddr_i                ,//写寄存器地址
    //from mem
    input              [   31:0]          mem_data_i                   ,//读内存数据

    //to reg
    output   reg                         rd_we_o                   ,//写寄存器标志
    output   reg        [   4: 0]        rd_waddr_o                ,//写寄存器地址
    output   reg       [  31: 0]         rd_data_o                 ,//写寄存器数据

    //to mem
    output    reg                         mem_we_o                   ,//写内存器标志
    output    reg          [   31: 0]      mem_waddr_o                , //写内存器地址
    output    reg          [   3: 0]      mem_w_sel_o                 ,//写选择器
    output    reg         [  31: 0]       mem_data_o                 ,//写内存数据

    //to ctrl
    output reg          [  31: 0]         jump_addr_o                ,//跳转的地址
    output reg                            jump_flag_o                ,//跳转标志
    output reg                            hold_flag_o                ,//暂停标志;

    //from id_ex
    output              [  31: 0]         op1_o                      ,
    output              [  31: 0]         op2_o                      ,
    output              [  31: 0]         op1_jump_o                 ,
    output              [  31: 0]         op2_jump_o                ,
    //
    output            [  31: 0]           inst_addr_o                ,
    output             [  31: 0]          inst_o


  );

  assign inst_addr_o=inst_addr_i;
  assign inst_o=inst_i;
  assign op1_o=op1_i;
  assign op2_o=op2_i;
  assign op1_jump_o=op1_jump_i;
  assign op2_jump_o=op2_jump_i;

  //将指令分为各个部部分
  //function7 rs2 rs1 funct3  rd opcode

  wire               [   6: 0]        funct7=inst_i[31:25]        ;
  wire               [   4: 0]        rs2=inst_i[24:20]           ;//源寄存器2、立即数
  wire               [   4: 0]        rs1=inst_i[19:15]           ;//源寄存器1、立即数
  wire               [   2: 0]        funct3=inst_i[14:12]        ;//功能1    （立即数：加法、无符号比较、有符号比较、、、）
  wire               [   4: 0]        rd=inst_i[11:7]             ;//目标寄存器、立即数
  wire               [   6: 0]        opcode=inst_i[6:0]          ;//操作码   （立即数指令、寄存器指令、控制转移指令、、、）指出该指令需要完成操作的类型或性质；
  wire               [  11: 0]        imm12=inst_i[31:20]         ;//12位立即数
  wire               [   4: 0]        shamt=inst_i[24:20]         ;//移位数



  wire                                SLTI=($signed(op1_i)<$signed(op2_i))?1'b1:1'b0  ;//有符号比较
  wire                                SLTIU=(op1_i<op2_i)?1'b1:1'b0  ;//无符号比较


  wire               [  31: 0]        SLLI                      =op1_i << shamt;//op1_i左移shamt
  wire               [  31: 0]        SRLI                      =op1_i >> shamt;//op1_i右移shamt

  wire               [  31: 0]        srai_mark                 =32'hffff_ffff;
  wire               [  31: 0]        SRAI                      =(op1_i>>shamt)|(({32{op1_i[31]}})&(srai_mark<<(32-shamt)));//op1_i算术右移shamt


  wire               [  31: 0]        op1_add_op2               =op1_i + op2_i;//op1_i和op2_i相加
  wire               [  31: 0]        op1_and_op2               =op1_i & op2_i;//op1_i和op2_i相与
  wire                  [31:0]         op1_or_op2                =op1_i | op2_i;//op1_i和op2_i相或
  wire               [  31: 0]        op1_xor_op2               =op1_i ^ op2_i;//op1_i和op2_i相异或

  wire  [31:0] SLL= op1_i << op2_i[4:0]; //op1_i左移op2_i的低5位
  wire [31:0]  SRL= op1_i >> op2_i[4:0]; //op1_i右移op2_i的低5位
  wire [31:0] SRA= (op1_i>>op2_i[4:0])|(({32{op1_i[31]}})&(srai_mark<<(32-op2_i[4:0]))); //op1_i算术右移op2_i的低5位

  wire  [31:0] addr_offset = $signed(op1_jump_i) + $signed(op2_jump_i); //跳转地址计算
  //用于load指令的地址计算
  wire [1:0]ld_addr_sel = addr_offset[1:0]; //地址选择器
  wire [1:0]st_addr_sel = addr_offset[1:0]; //地址选择器
  //用于B型指令的
  wire op1_eq_op2 = (op1_i == op2_i) ? 1'b1 : 1'b0; //op1_i和op2_i相等
  wire op1_lt_op2 = ($signed(op1_i) < $signed(op2_i)) ? 1'b1 : 1'b0; //op1_i和op2_i有符号比较
  wire op1_ltu_op2 = (op1_i < op2_i) ? 1'b1 : 1'b0; //op1_i和op2_i无符号比较


  //乘法指令
  wire[64-1:0] mul_temp;
  wire[64-1:0] mul_temp_invert;


  reg[31:0] mul_op1;
  reg[31:0] mul_op2;

  assign op1_invert = ~op1_i + 1;
  assign op2_invert = ~op2_i + 1;

  assign mul_temp = mul_op1 * mul_op2;
  assign mul_temp_invert = ~mul_temp + 1;//将负数的补码取反加1
  // 处理乘法指令（硬件中所有数据，以补码的形式存储！！!）
  always @ (*)
  begin
    if ((opcode == `INST_TYPE_R_M) && (funct7 == 7'b0000001))
    begin
      case (funct3)
        `INST_MUL, `INST_MULHU:
        begin
          mul_op1 = op1_i;
          mul_op2 = op2_i;
        end
        //mulhsu指令将操作数寄存器rsl与rs2中的32位整数相乘，
        //其中rsl当作有符号数、rs2当作无符号数，将结果的高32位写回寄存器rd中
        `INST_MULHSU:
        begin         //符号数乘无符号数，将符号数取反加1
          mul_op1 = (op1_i[31] == 1'b1)? (op1_invert): op1_i;
          mul_op2 = op2_i;
        end
        //mulh指令将操作数寄存器rsl与rs2中的32位整数当作有符号数相乘
        //结果的高32位写回寄存器rd中。
        `INST_MULH:
        begin           //无符号数乘法，将两个操作数都取反加1
          mul_op1 = (op1_i[31] == 1'b1)? (op1_invert): op1_i;
          mul_op2 = (op2_i[31] == 1'b1)? (op2_invert): op2_i;
        end
        default:
        begin
          mul_op1 = op1_i;
          mul_op2 = op2_i;
        end
      endcase
    end
    else
    begin
      mul_op1 = op1_i;
      mul_op2 = op2_i;
    end
  end


  always@(*)
  begin
    case (opcode)
      `INST_TYPE_I :
      begin

        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = 4'b0; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停

        case (funct3)
          `INST_ADDI:
          begin
            rd_data_o = op1_add_op2; //op1_i和op2_i相加
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_SLTI:
          begin
            rd_data_o = {31'b0,SLTI}; //op1_i和op2_i相加
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_SLTIU:
          begin
            rd_data_o = {31'b0,SLTIU}; //op1_i和op2_i相加
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_XORI:
          begin
            rd_data_o = op1_xor_op2; //op1_i和op2_i相异或
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_ORI:
          begin
            rd_data_o = op1_or_op2; //op1_i和op2_i相或
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_ANDI:
          begin
            rd_data_o = op1_and_op2; //op1_i和op2_i相与
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_SLLI:
          begin
            rd_data_o = SLLI; //
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o = rd; //写寄存器地址
          end
          `INST_SRI:
          begin
            case(funct7)
              `INST_SRLI:
              begin
                rd_data_o = SRLI; //op1_i右移shamt
                rd_we_o = reg_we_i; //写寄存器标志
                rd_waddr_o = rd; //写寄存器地址
              end
              `INST_SRAI:
              begin
                rd_data_o = SRAI; //op1_i右移shamt
                rd_we_o = reg_we_i; //写寄存器标志
                rd_waddr_o = rd; //写寄存器地址
              end
              default:
              begin
                rd_data_o = 32'b0; //op1_i右移shamt
                rd_we_o =`WriteDisable; //写寄存器标志
                rd_waddr_o = `ZeroReg; //写寄存器地址
              end
            endcase
          end

          default:
          begin
            mem_we_o = 1'b0; //I类型指令不写内存
            mem_waddr_o = 32'b0; //I类型指令不写内存
            mem_w_sel_o = 4'b0; //I类型指令不写内存
            mem_data_o = 32'b0; //I类型指令不写内存

            jump_addr_o = 32'b0; //I类型指令不跳转
            jump_flag_o = 1'b0; //I类型指令不跳转
            hold_flag_o = 1'b0; //I类型指令不暂停

          end
        endcase
      end


      `INST_TYPE_R_M://先写R型指令
      begin
        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = 4'b0; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停
        if(funct7 == 7'b0000_000 || funct7 == 7'b0100_000)   //R type inst
        begin
          case (funct3)
            `INST_ADD_SUB :
            begin
              case(funct7)
                7'b0000_000:
                begin
                  rd_data_o = op1_add_op2; //op1_i和op2_i相加
                  rd_we_o = reg_we_i; //写寄存器标志
                  rd_waddr_o = rd; //写寄存器地址
                end
                7'b0100_000:
                begin
                  rd_data_o = op1_i - op2_i; //op1_i和op2_i相减
                  rd_we_o = reg_we_i; //写寄存器标志
                  rd_waddr_o = rd; //写寄存器地址
                end
                default:
                begin
                  rd_data_o = 32'b0; //o
                  rd_we_o = `WriteDisable; //写寄存器标志
                  rd_waddr_o = `ZeroReg; //写寄存器地址
                end
              endcase
            end
            `INST_SLL:
            begin
              rd_data_o = SLL; //op1_i左移op2_i的低5位
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_SLT:
            begin
              rd_data_o = {31'b0,SLTI}; //op1_i和op2_i相加
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_SLTU:
            begin
              rd_data_o = {31'b0,SLTIU}; //op1_i和op2_i相加
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_XOR:
            begin
              rd_data_o = op1_xor_op2; //op1_i和op2_i相异或
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_SR:
            begin
              case (funct7)
                7'b0000_000  :
                begin
                  rd_data_o = SRL; //op1_i右移op2_i的低5位
                  rd_we_o = reg_we_i; //写寄存器标志
                  rd_waddr_o = rd; //写寄存器地址
                end
                7'b0100_000 :
                begin
                  rd_data_o = SRA; //op1_i算术右移op2_i的低5位
                  rd_we_o = reg_we_i; //写寄存器标志
                  rd_waddr_o = rd; //写寄存器地址
                end
                default:
                begin
                  rd_data_o = 32'b0; //o
                  rd_we_o = `WriteDisable; //写寄存器标志
                  rd_waddr_o = `ZeroReg; //写寄存器地址
                end
              endcase
            end
            `INST_OR:
            begin
              rd_data_o = op1_or_op2; //o
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_AND:
            begin
              rd_data_o = op1_and_op2; //o
              rd_we_o = reg_we_i; //写寄存器标志
              rd_waddr_o = rd; //写寄存器地址
            end
            default:
            begin
              rd_data_o = 32'b0; //o
              rd_we_o = `WriteDisable; //写寄存器标志
              rd_waddr_o = `ZeroReg; //写寄存器地址
            end
          endcase
        end
        else if (funct7 == 7'b0000001)
        begin
          case (funct3)
            `INST_MUL:
            begin
              jump_flag_o = 1'b0;
              hold_flag_o = 1'b0;
              jump_addr_o = `ZeroWord;

              mem_w_sel_o = 4'b0; //I类型指令不写内存
              mem_data_o = `ZeroWord;
              //mem_raddr_o = `ZeroWord;
              mem_waddr_o = `ZeroWord;
              mem_we_o = `WriteDisable;
              rd_data_o = mul_temp[31:0];
              rd_waddr_o = rd; //写寄存器地址
            end
            `INST_MULHU:
            begin
              jump_flag_o = 1'b0;
              hold_flag_o = 1'b0;
              jump_addr_o = `ZeroWord;

              mem_w_sel_o = 4'b0; //I类型指令不写内存
              mem_data_o = `ZeroWord;
              //  mem_raddr_o = `ZeroWord;
              mem_waddr_o = `ZeroWord;
              mem_we_o = `WriteDisable;
              rd_data_o = mul_temp[63:32];
              rd_waddr_o = rd; //写寄存器地址
            end
            //mulh指令将操作数寄存器rsl与rs2中的32位整数当作有符号数相乘
            //结果的高32位写回寄存器rd中。
            `INST_MULH:
            begin
              jump_flag_o = 1'b0;
              hold_flag_o = 1'b0;
              jump_addr_o = `ZeroWord;

              mem_w_sel_o = 4'b0; //I类型指令不写内存
              mem_data_o = `ZeroWord;
              //mem_raddr_o = `ZeroWord;
              mem_waddr_o = `ZeroWord;
              mem_we_o = `WriteDisable;
              rd_waddr_o = rd; //写寄存器地址
              case ({op1_i[31], op2_i[31]})
                2'b00:
                begin
                  rd_data_o = mul_temp[63:32];
                end
                2'b11:
                begin
                  rd_data_o = mul_temp[63:32];
                end
                2'b10:
                begin
                  rd_data_o = mul_temp_invert[63:32];
                end
                default:
                begin
                  rd_data_o = mul_temp_invert[63:32];
                end
              endcase
            end
            `INST_MULHSU:
            begin
              jump_flag_o = 1'b0;
              hold_flag_o = 1'b0;
              jump_addr_o = `ZeroWord;

              mem_w_sel_o = 4'b0; //I类型指令不写内存
              mem_data_o = `ZeroWord;
              // mem_raddr_o = `ZeroWord;
              mem_waddr_o = `ZeroWord;
              mem_we_o = `WriteDisable;
              rd_waddr_o = rd; //写寄存器地址
              if (op1_i[31] == 1'b1)
              begin
                rd_data_o = mul_temp_invert[63:32];
              end
              else
              begin
                rd_data_o = mul_temp[63:32];
              end
            end
            default:
            begin
              jump_flag_o = 1'b0;
              hold_flag_o = 1'b0;
              jump_addr_o = `ZeroWord;

              mem_w_sel_o = 4'b0; //I类型指令不写内存
              mem_data_o = `ZeroWord;
              //mem_raddr_o = `ZeroWord;
              mem_waddr_o = `ZeroWord;
              mem_we_o = `WriteDisable;
              rd_waddr_o = `ZeroWord;
              rd_data_o =`ZeroWord;
            end
          endcase
        end
        else
        begin
          jump_flag_o = 1'b0;
          hold_flag_o = 1'b0;
          jump_addr_o = `ZeroWord;
          mem_data_o = `ZeroWord;
          //mem_raddr_o = `ZeroWord;
          mem_waddr_o = `ZeroWord;
          mem_we_o = `WriteDisable;
          rd_data_o = `ZeroWord;

        end

      end
      //B型指令
      `INST_TYPE_B:
      begin
        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = 4'b0; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        rd_data_o = 32'b0; //I类型指令不跳转
        rd_waddr_o = `ZeroReg; //I类型指令不跳转
        rd_we_o = reg_we_i; //I类型指令不暂停
        hold_flag_o = 1'b0; //I类型指令不暂停
        case (funct3)
          `INST_BEQ:
          begin
            jump_flag_o = op1_eq_op2;
            jump_addr_o = addr_offset;
          end
          `INST_BNE:
          begin
            jump_flag_o = ~op1_eq_op2;
            jump_addr_o = addr_offset;
          end
          `INST_BLT:
          begin

            jump_flag_o = op1_lt_op2; //op1_i和op2_i有符号比较
            jump_addr_o = addr_offset; //跳转地址计算

          end
          `INST_BGE:
          begin
            jump_flag_o = ~op1_lt_op2; //op1_i和op2_i有符号比较
            jump_addr_o = addr_offset; //跳转地址计算
          end
          `INST_BLTU:
          begin
            jump_flag_o = op1_ltu_op2; //op1_i和op2_i无符号比较
            jump_addr_o = addr_offset; //跳转地址计算
          end
          `INST_BGEU:
          begin
            jump_flag_o = ~op1_ltu_op2; //op1_i和op2_i无符号比较
            jump_addr_o = addr_offset; //跳转地址计算
          end
          default:
          begin
            jump_addr_o = 32'b0; //I类型指令不跳转
            jump_flag_o = 1'b0; //I类型指令不跳转
          end
        endcase
      end

      `INST_TYPE_L:
      begin
        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = 4'b0; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停

        case (funct3)
          3'b000 : //lb
          begin
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o=reg_waddr_i;
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
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o=reg_waddr_i;
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
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o=reg_waddr_i;
            rd_data_o = mem_data_i; //直接读取内存数据
          end
          3'b100 : //lbu
          begin
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o=rd;
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
            rd_we_o = reg_we_i; //写寄存器标志
            rd_waddr_o=reg_waddr_i;
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

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停
        mem_w_sel_o = 4'b1111;
        case ( funct3)
          `INST_SB:
          begin
            mem_we_o=`WriteEnable; //写内存标志
            mem_waddr_o=addr_offset; //写内存地址
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
            mem_waddr_o=addr_offset;
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
            mem_waddr_o=addr_offset;
            mem_data_o = op2_i; //直接读取内存数据
          end
          default:
          begin
            mem_we_o=`WriteDisable; //写内存标志
            mem_waddr_o=addr_offset; //写内存地址
            mem_data_o=32'b0;
          end
        endcase
      end


      `INST_JAL:
      begin
        rd_data_o = op1_add_op2;
        rd_waddr_o = reg_waddr_i;
        rd_we_o  = `WriteEnable; //写寄存器标志
        jump_addr_o = addr_offset;
        jump_flag_o	= 1'b1;
        hold_flag_o = 1'b0;
        mem_we_o=`WriteDisable; //写内存标志
        mem_waddr_o=32'b0; //写内存地址
        mem_data_o=32'b0;
      end
      `INST_JALR:
      begin
        rd_data_o     = op1_add_op2;
        rd_waddr_o     = reg_waddr_i;
        rd_we_o      = `WriteEnable;
        jump_addr_o   = addr_offset;
        jump_flag_o	  = 1'b1;
        hold_flag_o   = 1'b0;
        mem_we_o=`WriteDisable; //写内存标志
        mem_waddr_o=32'b0; //写内存地址
        mem_data_o=32'b0;
      end
      `INST_LUI:
      begin
        rd_data_o = op1_i;
        rd_waddr_o = reg_waddr_i;
        rd_we_o  = 1'b1;
        jump_addr_o = 32'b0;
        jump_flag_o	= 1'b0;
        hold_flag_o = 1'b0;
        mem_we_o=`WriteDisable; //写内存标志
        mem_waddr_o=32'b0; //写内存地址
        mem_data_o=32'b0;
      end
      `INST_AUIPC:
      begin
        rd_data_o = op1_add_op2;
        rd_waddr_o = reg_waddr_i;
        rd_we_o  = 1'b1;
        jump_addr_o = 32'b0;
        jump_flag_o	= 1'b0;
        hold_flag_o = 1'b0;
        mem_we_o=`WriteDisable; //写内存标志
        mem_waddr_o=32'b0; //写内存地址
        mem_data_o=32'b0;
      end


      default:
      begin
        mem_we_o = 1'b0; //I类型指令不写内存
        mem_waddr_o = 32'b0; //I类型指令不写内存
        mem_w_sel_o = 4'b0; //I类型指令不写内存
        mem_data_o = 32'b0; //I类型指令不写内存

        jump_addr_o = 32'b0; //I类型指令不跳转
        jump_flag_o = 1'b0; //I类型指令不跳转
        hold_flag_o = 1'b0; //I类型指令不暂停
      end
    endcase
  end

endmodule
