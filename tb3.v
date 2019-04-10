module test_bench();

  parameter N = 4

  reg [N-1:0] a, b;
  reg reset, load, clk;
  reg [N-1:0] sum;
  reg cout;

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
    #100
    a = 4'b1010;
    b = 4'b0111;
    #1000
    $stop;
  end
endmodule
