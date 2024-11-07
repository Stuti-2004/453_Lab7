`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 01:05:28 PM
// Design Name: 
// Module Name: register_mem
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


module register_mem(
    input logic clk,
    input logic [15:0] switches_in,
    input logic reset,
    input logic en,
    output logic [15:0] mem_out
    );
    
    always_ff @(posedge clk)
        if (reset) mem_out<= 16'b0000000000000000;
        else if (en) mem_out<=switches_in; 
endmodule
