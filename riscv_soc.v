module riscv_soc(
    input clk         ,
    input rst_n


  );

  wire [31:0]  riscv_inst_addr_o;
  //wire [31:0]  riscv_mem_rd_req_o;
  wire [31:0] Instmem_inst_o;

  //wire [31:0]   riscv_inst_addr_o	;

  wire 	   	  riscv_mem_rd_req_o	;
  wire [31:0]   riscv_mem_rd_addr_o	;


  wire	 	  riscv_mem_wr_req_o	;
  wire  [3:0]   riscv_mem_wr_sel_o	;
  wire  [31:0]  riscv_mem_wr_addr_o	;
  wire  [31:0]  riscv_mem_wr_data_o ;


  wire [31:0]  mem_r_data_o; //从内存读出的数据
  //例化inst_mem
  Instmem  Instmem_inst(

             .instaddr(riscv_inst_addr_o),
             .inst_out(Instmem_inst_o)

           );

  //例化系统
  riscv riscv_inst(

          .clk   		   (clk)  ,
          .rst_n		   (rst_n) ,
          .inst_i		   (Instmem_inst_o),
          .inst_addr_o   (riscv_inst_addr_o),
          .mem_rd_req_o  (riscv_mem_rd_req_o),
          .mem_rd_addr_o (riscv_mem_rd_addr_o),
          .mem_rd_data_i (mem_r_data_o ),
          .mem_wr_req_o  (riscv_mem_wr_req_o),
          .mem_wr_sel_o  (riscv_mem_wr_sel_o),
          .mem_wr_addr_o (riscv_mem_wr_addr_o),
          .mem_wr_data_o (riscv_mem_wr_data_o)

        );

  //例化mem
  mem mem_inst(
        .clk      (clk),
        .rst_n    (rst_n),
        .w_addr_i (riscv_mem_wr_addr_o),
        .w_data_i (riscv_mem_wr_data_o),
        .w_en_i   (riscv_mem_wr_sel_o),
        .r_addr_i (riscv_mem_rd_addr_o),
        .r_en_i   (riscv_mem_rd_req_o),
        .r_data_o (mem_r_data_o)

      );

endmodule
