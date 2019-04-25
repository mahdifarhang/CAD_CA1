module Register_File #(parameter bank_num=4, parameter log_bank_num=2,
  parameter reg_num=64, parameter log_reg_num=6,
  parameter reg_width=64)
  (write_data , addr_write , addr_read , reset , write_en, clk, read_data)
  input [reg_width-1:0] write_data;
  input [log_reg_num-1:0] addr_write , addr_read;
  input reset , write_en, clk;
  output reg [reg_width-1:0] read_data;


  






endmodule
