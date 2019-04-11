module one_bit_reg (clk, rst, ld_en, in, out);
  input clk, rst, ld_en, in;
  output reg out;

  always @(posedge clk, posedge rst) begin
    if (rst)  out <= 1'b0;
    else if (ld_en) out <= in;
  end
endmodule

module shift_reg_in #(parameter N = 4) (clk, rst, in, ld_en, shiftr, out);
  input clk, rst, ld_en, shiftr;
  input [N-1:0] in;
  output reg out;

  reg [N-1:0] data;
  always @(posedge clk, posedge rst) begin
    if (rst) begin
      data <= 0;//N'b0
      out <= 1'b0;
    end
    else if(ld_en)  data <= in;
    else if(shiftr) begin
      out <= data[0];
      data <= {1'b0, data[N-1:1]};
    end
  end
endmodule

module shift_reg_out #(parameter N = 4) (clk, rst, ld_en, in, data);
  input clk, rst, ld_en, in;
  output reg [N-1:0] data;

  always @(posedge clk, posedge rst) begin
    if(rst) data = 0;//N'b0
    else if(ld_en)  data = {in, data[N-1:1]};
  end
endmodule

module one_bit_FA (a, b, c, s, cout);
  input a, b, c;
  output s, cout;

  assign s = ((a + b + c) % 2 == 1) ? 1 : 0;
  assign cout = (a + b + c > 1) ? 1 : 0;
endmodule


module serial_adder #(parameter N = 4)
  (a, b, reset, load, clk, sum, cout);
  input [N-1:0] a, b;
  input reset, load, clk;
  output [N-1:0] sum;
  output cout;

  wire FA_cout, reg_in_a, reg_in_b, reg_c_out, FA_s, reg_out_data;
  reg ld_en_a, ld_en_b, ld_en_c, shift_en_out, shiftr_a, shiftr_b;

  one_bit_FA FA(reg_in_a, reg_in_b, reg_c_out, FA_s, FA_cout);
  one_bit_reg c(clk, reset, ld_en_c, FA_cout, reg_c_out);
  shift_reg_in ina(clk, reset, a, ld_en_a, shiftr_a, reg_in_a);
  shift_reg_in inb(clk, reset, b, ld_en_b, shiftr_b, reg_in_b);
  shift_reg_out out(clk, reset, shift_en_out, FA_s, reg_out_data);

  assign cout = reg_c_out;
  assign sum = reg_out_data;

  reg [2:0] state, next_state;
  reg [N:0] counter = 0;

  always @(posedge clk, posedge reset) begin
    if (reset) begin
      state <= 3'b000;
      counter = 0;
    end
    else state <= next_state;
  end

  always @(state, load) begin
    next_state = 3'b000;
    ld_en_a = 1'b0; ld_en_b = 1'b0; ld_en_c = 1'b0; shift_en_out = 1'b0; shiftr_a = 1'b0; shiftr_b = 1'b0;
    case(state)
      3'b000: next_state = (load) ? 3'b001 : 3'b000;
      3'b001: next_state = (~load) ? 3'b010 : 3'b001;
      3'b010: begin next_state = 3'b011; ld_en_a = 1'b1; ld_en_b = 1'b1; end
      3'b011: next_state = 3'b100;
      3'b100: begin next_state = 3'b101; ld_en_c = 1'b1; shift_en_out = 1'b1; counter = counter + 1; end
      3'b101: begin next_state = (counter > N) ? 3'b110 : 3'b100; shiftr_a = 1'b1; shiftr_b = 1'b1; end
      3'b110: next_state = 3'b000;
      //3'b111:
    endcase
  end
endmodule
