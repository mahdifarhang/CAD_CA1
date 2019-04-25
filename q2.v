module mux #(parameter N = 1) (a, b, sel, out);
  input [N-1:0] a, b;
  input sel;
  output [N-1:0] out;

  wire w1, w2, w3;
  not n1(w1, sel);
  nand a1(w2, a, w1);
  nand a2(w3, b, sel);
  nand o1(out, w2, w3);

endmodule

module barrel_shifter #(parameter N = 8, parameter logN = 3) (in, shift_selection, out);
  input [N-1:0] in;
  input [logN-1:0] shift_selection;
  output [N-1:0] out;

  wire [(N*(logN+1))-1:0] w;
  assign w[N-1:0] = in;
  assign out = w[(N*(logN+1))-1:N*logN];

  // integer k;
  genvar i, j;
  generate
  for(j = 0; j < logN; j = j + 1) begin: outter_loop
    // assign k = (j == 0) ? 1 : 2 * k;
    for(i = 0; i < N; i = i + 1) begin: inner_loop
    // mux m(w[(j*N)+i], ((i-k < 0) ? 1'b0 : w[(j*N)+i-k]), shift_selection[j], w[((j+1)*N)+i]);
    if (j == 0)  mux m(w[(j*N)+i], ((i-1 < 0) ? 1'b0 : w[(j*N)+i-1]), shift_selection[j], w[((j+1)*N)+i]);
    else if (j == 1)  mux m(w[(j*N)+i], ((i-2 < 0) ? 1'b0 : w[(j*N)+i-2]), shift_selection[j], w[((j+1)*N)+i]);
    else if (j == 2)  mux m(w[(j*N)+i], ((i-4 < 0) ? 1'b0 : w[(j*N)+i-4]), shift_selection[j], w[((j+1)*N)+i]);
    end
  end
  endgenerate

endmodule
