`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.02.2025 00:54:06
// Design Name: 
// Module Name: fir_filter_tb
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

module tb_fir_filter();
    reg clk;
    reg reset;
    reg signed [15:0] x_in;
    wire signed [15:0] y_out;

    fir_filter dut (.*);

    // 100MHz clock (10ns period)
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_fir_filter);
        clk = 0;
        reset = 1;
        x_in = 0;
        
        #100 reset = 0;
        @(negedge clk);
        x_in = 16'sd32767;
        @(negedge clk);
        x_in = 16'sd0;
        
        repeat(12) @(posedge clk);
        $finish;
    end

    always @(posedge clk) begin
        $display("t=%0t: x_in=%6d y_out=%6d", $time, x_in, y_out);
    end
endmodule