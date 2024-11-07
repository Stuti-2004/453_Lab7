module mux4_16_bits(
    input  logic [15:0] in0,  
    input  logic [15:0] in1,  
    input  logic [15:0] in2, 
    input  logic [15:0] in3,  
    input  logic  [1:0] select,  
    output logic [15:0] mux_out  
    );

    always_comb begin
        case(select)
            2'b00: mux_out = in0;  
            2'b01: mux_out = in1;  
            2'b10: mux_out = in2;
            2'b11: mux_out = in3;
            default: mux_out = 16'h0000;  // Default case: output all zeros
        endcase
    end    
    

endmodule
