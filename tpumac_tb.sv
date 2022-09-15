
// Spec v1.1
module tpumac_tb();

  //Declaring paramters
  localparam BITS_AB = 8;
  localparam BITS_C = 16;

  // Declare stimulus 
  logic clk,rst_n, WrEn, en;
  logic signed [BITS_AB-1:0] Ain;
  logic signed [BITS_AB-1:0] Bin;
  logic signed [BITS_C-1:0] Cin;
  
  // Declare signals to monitor DUT output 
  logic signed [BITS_AB-1:0] Aout, Aout_old;
  logic signed [BITS_AB-1:0] Bout, Bout_old;
  logic signed [BITS_C-1:0] Cout, Cout_exp, Cout_old;
  
  //////////////////////
  // Instantiate DUT //
  ////////////////////
  tpumac #(.BITS_AB(BITS_AB), .BITS_C(BITS_C)) iDUT(.clk(clk), .rst_n(rst_n), .en(en), .WrEn(WrEn), 
           .Ain(Ain), .Bin(Bin), .Cin(Cin), .Aout(Aout), .Bout(Bout), .Cout(Cout));
  
  integer error = 0;
  
  initial begin
     // Initial setup
     clk = 0;
     rst_n = 0;
     @(negedge clk);
     rst_n = 1;
    @(posedge clk);
    if (Aout !== 0 || Bout !== 0 || Cout !== 0) begin
      $display("ERROR: values not reset\n");
      error+=1;
    end
    for (integer i=0; i<256; i = i+1) begin
      @(negedge clk);
      Ain = $random;
      Bin = $random << 8;
      Cin = $random << 16;
      en = $random << 17;
      WrEn = $random << 18; #so all bits feel included :)
      
      @(posedge clk);
      
      if (en === 0) begin
        if (Aout !== Aout_old) begin
          $display("ERROR cycle %d: en is false, Aout shouldn't change\n", i);
          error+=1;
        end
        if (Bout !== Bout_old) begin
          $display("ERROR cycle %d: en is false, Bout shouldn't change\n", i);
          error+=1;
        end
        if (Cout !== Cout_old) begin
          $display("ERROR cycle $d: en is false, Cout shouldn't change\n", i);
          error+=1;
        end
      end
      else begin
        if (Aout !== Ain) begin
          $display("ERROR cycle %d: Aout should match Ain, Aout = %h, Ain = %h\n", i, Aout, Ain);
          error+=1;
        end
        if (Bout !== Bin) begin
          $display("ERROR cycle %d: Bout should match Bin, Bout = %h, Bin = %h\n", i, Bout, Bin);
          error+=1;
        end
        if (WrEn === 1) begin
          if (Cout !== Cin) begin
            $display("ERROR cycle %d: WrEn true, Cout should be Cin, Cout = %h, Cin = %h\n", i, Cout, Cin);
            error+=1;
          end
        end
        else begin
          Cout_exp = Ain * Bin + Cout_old;
          if (Cout !== (Ain * Bin + Cout_old)) begin
            $display("ERROR cycle %d: Cout calculation wrong, Cout = %h, should be %h\n", i, Cout, Cout_exp);
            error+=1;
          end
        end
      end
      Aout_old = Aout;
      Bout_old = Bout;
      Cout_old = Cout;
      
    end
  end

endmodule
