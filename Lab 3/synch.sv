`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2024 03:52:59 PM
// Design Name: 
// Module Name: synch
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


module synch(
    input logic clk,
    input logic [15:0] d,
    output logic [15:0] q
    );
    
    logic [15:0] n1;
    always_ff@(posedge clk)
        begin
        n1<=d;
        q<=n1;
    end
endmodule
