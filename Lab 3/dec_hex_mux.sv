`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 12:06:19 PM
// Design Name: 
// Module Name: dec_hex_mux
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


module dec_hex_mux(
    input  logic [15:0] hexadecimal,
    input  logic [15:0] decimal,
    input  logic [15:0] hexadecimal_old,
    input  logic [15:0] decimal_old,
    input  logic        selector1,
    input  logic        selector2,
    output logic [15:0] to_display
);

    always_comb begin
        case ({selector1,selector2})
            2'b00: to_display = decimal;   // display decimal verison
            2'b10: to_display = hexadecimal;   // display hexadecimal version
            2'b01: to_display = decimal_old;   // display old decimal verison
            2'b11: to_display = hexadecimal_old;   // display old hexadecimal version
            default: to_display = 16'b0000000000000000;    // default case
        endcase
    end
    
endmodule

