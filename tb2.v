`timescale 1 ns/ 1 ns
module test_bench();
  parameter N = 8;
  parameter logN = 8;
//to change N from 4 to 8:
//change the final delays in test bench from 300 to 500. change the a,b numbers in test bench 'pay attention to number of digits 8'b...'
//change all the Ns in test bench file and modules.
  reg [N-1:0] in;
  reg [logN-1:0] sh_sel;
  wire [N-1:0] out;

  barrel_shifter shifter(in, sh_sel, out);


  initial begin
    in = 8'b10011101;
    sh_sel = 3'b111;
    #20
    in = 8'b11100101;
    sh_sel = 3'b001;
    #20
    in = 8'b01011011;
    sh_sel = 3'b011;
    #20

    $stop;
  end
endmodule
