// Top Level Module
module lab_6_top_level_students (
    input  logic        clk,
    input  logic        reset,
    input  logic [1:0]  bin_bcd_select,
    input  logic        vauxp15,
    input  logic        vauxn15,
    output logic        CA, CB, CC, CD, CE, CF, CG, DP,
    output logic        AN1, AN2, AN3, AN4,
    output logic [15:0] led
);
    
    // Internal signals
    logic [15:0] scaled_adc_data;
    logic [15:0] raw_data;
    logic [15:0] averaged_data;
    logic [15:0] bcd_value;
    logic [15:0] mux_out;
    logic [3:0]  decimal_pt;

    // ADC Subsystem instance
    adc_subsystem ADC_SUB (
        .clk(clk),
        .reset(reset),
        .vauxp15(vauxp15),
        .vauxn15(vauxn15),
        .scaled_adc_data(scaled_adc_data),
        .raw_data(raw_data),
        .averaged_data(averaged_data)
    );

    // Binary to BCD converter
    bin_to_bcd BIN2BCD (
        .clk(clk),
        .reset(reset),
        .bin_in(scaled_adc_data),
        .bcd_out(bcd_value)
    );

    // 4:1 Multiplexer
    mux4_16_bits MUX4 (
        .in0(scaled_adc_data),
        .in1(bcd_value),
        .in2(raw_data[15:4]),
        .in3(averaged_data),
        .select(bin_bcd_select),
        .mux_out(mux_out)
    );

    // Decimal point logic
    always_comb begin
        case(bin_bcd_select)
            2'b00: decimal_pt = 4'b0000;
            2'b01: decimal_pt = 4'b0010;
            2'b10: decimal_pt = 4'b0000;
            2'b11: decimal_pt = 4'b0000;
            default: decimal_pt = 4'b0000;
        endcase
    end

    // Seven segment display subsystem
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
        .clk(clk),
        .reset(reset),
        .sec_dig1(mux_out[3:0]),
        .sec_dig2(mux_out[7:4]),
        .min_dig1(mux_out[11:8]),
        .min_dig2(mux_out[15:12]),
        .decimal_point(decimal_pt),
        .CA(CA), .CB(CB), .CC(CC), .CD(CD),
        .CE(CE), .CF(CF), .CG(CG), .DP(DP),
        .AN1(AN1), .AN2(AN2), .AN3(AN3), .AN4(AN4)
    );

    // LED output
    assign led = scaled_adc_data;

endmodule