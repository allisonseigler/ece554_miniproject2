module tpumac_tb();

  localparam BITS_AB = 8;
  localparam BITS_C = 16;
  
  logic clk, rst_n, WrEn, en;
  logic signed [BITS_AB-1:0] Ain;
  logic signed [BITS_AB-1:0] Bin;
  logic signed [BITS_C-1:0] Cin;
  
  logic signed [BITS_AB-1:0] Aout;
  logic signed [BITS_AB-1:0] Bout;
  logic signed [BITS_C-1:0] Cout;
