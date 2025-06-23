`include "defines.v"

module wb(
    input              clk,
    input              rst_n,
    input              rd_we_i,           // ME阶段传来的写使能
    input      [4:0]   rd_waddr_i,        // ME阶段传来的写寄存器地址
    input      [31:0]  rd_data_i,         // ME阶段传来的写回数据

    output reg         rd_we_o,           // 输出到寄存器堆
    output reg [4:0]   rd_waddr_o,
    output reg [31:0]  rd_data_o    
  );

  always @(*)
  begin
    if (!rst_n)
    begin
      rd_we_o    <= 1'b0;
      rd_waddr_o <= 5'b0;
      rd_data_o  <= 32'b0;
    end
    else
    begin
      rd_we_o    <= rd_we_i;
      rd_waddr_o <= rd_waddr_i;
      rd_data_o  <= rd_data_i;
    end
  end

endmodule

