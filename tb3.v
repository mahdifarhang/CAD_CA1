`timescale 1 ns/ 1 ns
module test_bench();

  parameter N = 4;

  reg [N-1:0] a, b;
  reg reset, load, clk;
  wire [N-1:0] sum;
  wire cout;

  serial_adder Adder (a, b, reset, load, clk, sum, cout);






  initial begin
    clk = 0;
    forever begin
      #10 clk = ~clk;
    end
  end

  initial begin
    reset = 1'b1;
    #20
    reset = 1'b0;
    a = 4'b1111;
    b = 4'b0111;
    #20
    load = 1'b1;
    #40
    load = 1'b0;
    #300


    reset = 1'b1;
    #20
    reset = 1'b0;
    a = 4'b1110;
    b = 4'b0111;
    #20
    load = 1'b1;
    #40
    load = 1'b0;
    #300

    reset = 1'b1;
    #20
    reset = 1'b0;
    a = 4'b010;
    b = 4'b1001;
    #20
    load = 1'b1;
    #40
    load = 1'b0;
    #300
    $stop;
  end
endmodule
