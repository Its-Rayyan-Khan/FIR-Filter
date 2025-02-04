`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2025 00:16:34
// Design Name: 
// Module Name: fir_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fir_filter (
    input clk,
    input reset,
    input signed [15:0] x_in,
    output signed [15:0] y_out
);

parameter N = 8; // Number of taps

// Verilog-compatible coefficient declaration (no unpacked array initialization)
wire signed [15:0] h [0:N-1]; // Unpacked array

// Assign coefficients manually (Verilog workaround)
assign h[0] = 16'sd1; // Signed decimal values
assign h[1] = 16'sd2;
assign h[2] = 16'sd3;
assign h[3] = 16'sd4;
assign h[4] = 16'sd5;
assign h[5] = 16'sd6;
assign h[6] = 16'sd7;
assign h[7] = 16'sd8;

// 40-bit registers for accumulators
reg signed [39:0] r [0:N-1];

genvar i;
generate
  for (i = 0; i < N; i = i + 1) begin: tap
    always @(posedge clk or posedge reset) begin
      if (reset) begin
        r[i] <= 0;
      end else begin
        if (i == N-1) begin
          // Multiply h[i] (signed) with x_in (signed)
          r[i] <= booth_multiply(h[i], x_in);
        end else begin
          // Accumulate with previous tap
          r[i] <= low_power_add(booth_multiply(h[i], x_in), r[i+1]);
        end
      end
    end
  end
endgenerate

// Output truncation (16-bit signed)
assign y_out = r[0][39:24];

// Booth Multiplier Function (Verilog-compatible)
function [31:0] booth_multiply;
  input [15:0] a;
  input [15:0] b;
  begin
    // Use $signed() for signed multiplication
    booth_multiply = $signed(a) * $signed(b);
  end
endfunction

// Low-Power Adder Function (Verilog-compatible)
function [39:0] low_power_add;
  input [31:0] a;
  input [39:0] b;
  reg [39:0] a_extended;
  begin
    // Sign-extend 'a' to 40 bits
    a_extended = {{8{a[31]}}, a};
    low_power_add = $signed(a_extended) + $signed(b);
  end
endfunction

endmodule