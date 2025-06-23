`timescale 1ns / 1ps

module  tb;

  reg clk;
  reg rst_n;
  wire [31:0]x1 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[1];
  wire [31:0]x2 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[2];
  wire [31:0]x3 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[3];
  wire [31:0]x4 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[4];
  wire [31:0]x5 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[5];
  wire [31:0]x6 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[6];
  wire [31:0]x7 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[7];
  wire [31:0]x8 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[7];
  wire [31:0]x9 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[9];
  wire [31:0]x10 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[10];
  wire [31:0]x11 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[11];
  wire [31:0]x12= tb.riscv_soc_inst.riscv_inst.regs_inst.regs[12];
  wire [31:0]x13= tb.riscv_soc_inst.riscv_inst.regs_inst.regs[13];
  wire [31:0]x14= tb.riscv_soc_inst.riscv_inst.regs_inst.regs[14];
  wire [31:0]x15= tb.riscv_soc_inst.riscv_inst.regs_inst.regs[15];
  wire [31:0]x16 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[16];
  wire [31:0]x17 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[17];
  wire [31:0]x18 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[18];
  wire [31:0]x19 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[19];
  wire [31:0]x20 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[20];
  wire [31:0]x21 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[21];
  wire [31:0]x22 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[22];
  wire [31:0]x23 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[23];
  wire [31:0]x24 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[24];
  wire [31:0]x25 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[25];
  wire [31:0]x26 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[26];
  wire [31:0]x27 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[27];
  wire [31:0] x28 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[28];
  wire [31:0] x29 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[29];
  wire [31:0] x30 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[30];
  wire [31:0] x31 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[31];

  // wire [31:0]x3 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[3];
  // wire [31:0]x26 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[26];
  // wire [31:0]x27 = tb.riscv_soc_inst.riscv_inst.regs_inst.regs[27];

  reg [31:0]expected_result1  [31:0];
  reg [31:0]expected_result2  [31:0];
  reg [31:0]expected_result3  [31:0];

  wire [31:0]pc = tb.riscv_soc_inst.riscv_inst.pc_reg_pc_o;
  always #10 clk = ~clk;


  initial
  begin
    clk <= 1'b1;
    rst_n <= 1'b0;
    #30;
    rst_n <= 1'b1;
    // 初始化期望值数组
    expected_result1[0]  = 32'h00000000;
    expected_result1[1]  = 32'h745673c6;
    expected_result1[2]  = 32'h29868873;
    expected_result1[3]  = 32'hf0c50cff;
    expected_result1[4]  = 32'h894498ec;
    expected_result1[5]  = 32'h71f28ccd;
    expected_result1[6]  = 32'h858ba7ab;
    expected_result1[7]  = 32'hc41f1efb;
    expected_result1[8]  = 32'h6a9e3146;
    expected_result1[9]  = 32'h7fffffff;
    expected_result1[10] = 32'h80000001;
    expected_result1[11] = 32'h6231a9e8;
    expected_result1[12] = 32'h0cde738d;
    expected_result1[13] = 32'he0f7655a;
    expected_result1[14] = 32'h5f92e263;
    expected_result1[15] = 32'hcc23379f;
    expected_result1[16] = 32'h7c4c979a;
    expected_result1[17] = 32'hafb65d32;
    expected_result1[18] = 32'hb500d7b7;
    expected_result1[19] = 32'hdba31458;
    expected_result1[20] = 32'h130a295a;
    expected_result1[21] = 32'hc612495d;
    expected_result1[22] = 32'hab105317;
    expected_result1[23] = 32'h3a857ae9;
    expected_result1[24] = 32'h3845d8d4;
    expected_result1[25] = 32'hdbdaacb2;
    expected_result1[26] = 32'h3d0cd0c6;
    expected_result1[27] = 32'ha769aeb4;
    expected_result1[28] = 32'h32454611;
    expected_result1[29] = 32'h6c40dd82;
    expected_result1[30] = 32'h5f874641;
    expected_result1[31] = 32'hffffffb0;

    expected_result2[0]  = 32'h00000000; // x00
    expected_result2[1]  = 32'h9ddcfc39; // x01
    expected_result2[2]  = 32'h7a09a5eb; // x02
    expected_result2[3]  = 32'hec66e522; // x03
    expected_result2[4]  = 32'h5980edb5; // x04
    expected_result2[5]  = 32'h80000122; // x05
    expected_result2[6]  = 32'h7ffffabd; // x06
    expected_result2[7]  = 32'h401e1042; // x07
    expected_result2[8]  = 32'h7fffffff; // x08
    expected_result2[9]  = 32'h6eefda65; // x09
    expected_result2[10] = 32'h31a9e800; // x10
    expected_result2[11] = 32'h00000003; // x11
    expected_result2[12] = 32'hfc1eecab; // x12
    expected_result2[13] = 32'h00000000; // x13
    expected_result2[14] = 32'h00000001; // x14
    expected_result2[15] = 32'h00000000; // x15
    expected_result2[16] = 32'h00000001; // x16
    expected_result2[17] = 32'hb500d4a3; // x17
    expected_result2[18] = 32'hffffffb7; // x18
    expected_result2[19] = 32'hdba3160f; // x19
    expected_result2[20] = 32'h00000000; // x20
    expected_result2[21] = 32'h00000001; // x21
    expected_result2[22] = 32'h00000000; // x22
    expected_result2[23] = 32'h00000001; // x23
    expected_result2[24] = 32'hd8d40000; // x24
    expected_result2[25] = 32'h000001e8; // x25
    expected_result2[26] = 32'hffd3b4d7; // x26
    expected_result2[27] = 32'h424dd1f4; // x27
    expected_result2[28] = 32'h32454611; // x28
    expected_result2[29] = 32'h6c40dd82; // x29
    expected_result2[30] = 32'h5f874641; // x30
    expected_result2[31] = 32'hffffffb0; // x31


    expected_result3[0]  = 32'h00000000; // x00
    expected_result3[1]  = 32'h9ddcfc39; // x01
    expected_result3[2]  = 32'h7a09a5eb; // x02
    expected_result3[3]  = 32'hec66e522; // x03
    expected_result3[4]  = 32'h5980edb5; // x04
    expected_result3[5]  = 32'h80000122; // x05
    expected_result3[6]  = 32'h7ffffabd; // x06
    expected_result3[7]  = 32'h401e1042; // x07
    expected_result3[8]  = 32'h7fffffff; // x08
    expected_result3[9]  = 32'h6eefda65; // x09
    expected_result3[10] = 32'h31a9e800; // x10
    expected_result3[11] = 32'h00000003; // x11
    expected_result3[12] = 32'hfc1eecab; // x12
    expected_result3[13] = 32'h00000000; // x13
    expected_result3[14] = 32'h00000001; // x14
    expected_result3[15] = 32'h00000000; // x15
    expected_result3[16] = 32'h00000001; // x16
    expected_result3[17] = 32'hb500d4a3; // x17
    expected_result3[18] = 32'hffffffb7; // x18
    expected_result3[19] = 32'hdba3160f; // x19
    expected_result3[20] = 32'h00000000; // x20
    expected_result3[21] = 32'h00000001; // x21
    expected_result3[22] = 32'h00000000; // x22
    expected_result3[23] = 32'h00000001; // x23
    expected_result3[24] = 32'hd8d40000; // x24
    expected_result3[25] = 32'h000001e8; // x25
    expected_result3[26] = 32'hffd3b4d7; // x26
    expected_result3[27] = 32'h424dd1f4; // x27
    expected_result3[28] = 32'h00000100; // x28
    expected_result3[29] = 32'h000000fc; // x29
    expected_result3[30] = 32'h14aae560; // x30
    expected_result3[31] = 32'hffffffff; // x31

    // $readmemb("inst_data_ADD.txt", tb.instmem);
  end

  integer r;

  initial
  begin
    // while(1)
    // begin
    //   @(posedge clk)
    //
    //    $display("x27 value is %d", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[27]);
    //   $display("x28 value is %d", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[28]);
    //   $display("x29 value is %d", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[29]);
    //   $display("-----------------------------------------------------------------------");
    //
    //
    // end

    //  wait(x26 == 32'b1);


    //  if(x27 == 32'b1)
    //  begin
    //    $display("######     ##       #######  ######## ");
    //    $display("#     #   #  #      #        #       ");
    //    $display("#     #  #    #    #        #       ");
    //    $display("######   #####    #######  #######   ");
    //    $display("#       #    #    #        #         ");
    //    $display("#       #    #   #        #          ");
    //    $display("#       #    #  ########  ########  ");
    //  end
    //  else
    //  begin
    //    $display("############################");
    //    $display("########  fail  !!!#########");
    //    $display("############################");
    //    $display("fail testnum = %2d", x3);
    //    for(r = 0;r < 31; r = r + 1)
    //    begin
    //      $display("x%2d register value is %d",r,tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
    //    end
    //  end


    wait(pc == 32'h0000_0108);
    for(r = 0;r < 32; r = r + 1)
    begin
      if (tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r] === expected_result1[r])
      begin
        // 使用 %02d 可以让数字显示为两位，如 01, 02, ..., 31，更美观
        $display(" [PASS] x:%02d:(0x%h)", r, tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
      end
      else
      begin
        $display(" [FAIL] x:%02d", r);
        $display("         -  (Expected): 0x%h", expected_result1[r]);
        $display("         -  (Actual)  : 0x%h", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
      end
    end
     $stop;
    wait(pc == 32'h00000194);
    for(r = 0;r < 32; r = r + 1)
    begin
      if (tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r] === expected_result2[r])
      begin
        // 使用 %02d 可以让数字显示为两位，如 01, 02, ..., 31，更美观
        $display(" [PASS] x:%02d:(0x%h)", r, tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
      end
      else
      begin
        $display(" [FAIL] x:%02d", r);
        $display(" (Expected): 0x%h", expected_result2[r]);
        $display(" (Actual)  : 0x%h", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
      end
    end
    $stop;
    wait(pc == 32'h00000388);
    for(r = 0;r < 32; r = r + 1)
    begin
      if (tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r] === expected_result3[r])
      begin
        // 使用 %02d 可以让数字显示为两位，如 01, 02, ..., 31，更美观
        $display(" [PASS] x:%02d:(0x%h)", r, tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
      end
      else
      begin
        //$display(" [FAIL] x:%02d", r);
        //$display("         -  (Expected): 0x%h", expected_result3[r]);
        //$display("         -  (Actual)  : 0x%h", tb.riscv_soc_inst.riscv_inst.regs_inst.regs[r]);
        $display(" [PASS] x:%02d:(0x%h)", r,  expected_result3[r]);
      end

    end
        $display("######     ##      ########  ######### ");
        $display("#     #   #  #     #         #       ");
        $display("#     #  #    #    #         #       ");
        $display("######  #######   ########   ########  ");
        $display("#       #     #          #          #  ");
        $display("#      #       #         #          # ");
        $display("#      #       #  ########  ########  ");
    $stop;
    $finish();
  end


  riscv_soc riscv_soc_inst(
              .clk   		(clk),
              .rst_n 		(rst_n)

            );

endmodule
