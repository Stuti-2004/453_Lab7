//*******************************************************************************
// Module: seven_segment_display_subsystem
//
// Description:
// This module integrates the digit_multiplexor, seven_segment_digit_selector, 
// and seven_segment_decoder into a single subsystem to drive a 4-digit 
// 7-segment display. It is designed to interface with a top-level module like 
// lab_1b_top_level and enables hierarchical design.
//
// Inputs:
// - clk: Clock input
// - reset: Active-high synchronous reset
// - sec_dig1, sec_dig2, min_dig1, min_dig2: 4-bit BCD digit inputs
//
// Outputs:
// - CA, CB, CC, CD, CE, CF, CG, DP: Individual segment controls (active-low)
// - AN1, AN2, AN3, AN4: Anode controls for the 4 digits (active-low)
//
// Internal Signals:
// - digit_select: One-hot encoded output for digit selection
// - digit_to_display: 4-bit BCD value to display on the current digit
// - in_DP: Control signal for the decimal point
//
//*******************************************************************************

module seven_segment_display_subsystem (
    input  logic        clk,
    input  logic        reset,
    input  logic [3:0]  sec_dig1, // seconds digit (units)
    input  logic [3:0]  sec_dig2, // tens of seconds
    input  logic [3:0]  min_dig1, // minutes digit (units)
    input  logic [3:0]  min_dig2, // tens of minutes
    output logic        CA, CB, CC, CD, CE, CF, CG, DP, // segment outputs (active-low)
    output logic        AN1, AN2, AN3, AN4 // anode outputs for digit selection (active-low)
);

    // Internal signals
    logic [3:0] digit_to_display;
    logic [3:0] digit_select;
    logic [3:0] an_outputs;
    logic       in_DP, out_DP;

    // Instantiate digit multiplexor
    digit_multiplexor DIGIT_MUX (
        .sec_dig1(  sec_dig1),  // input for seconds digit (units)
        .sec_dig2(  sec_dig2),  // input for tens of seconds digit
        .min_dig1(  min_dig1),  // input for minutes digit (units)
        .min_dig2(  min_dig2),  // input for tens of minutes digit
        .selector(  digit_select), // one-hot selector for the digit
        .time_digit(digit_to_display)  // 4-bit digit output to display
    );

    // Instantiate digit selector
    seven_segment_digit_selector DIGIT_SELECTOR (
        .clk(         clk),         // Clock input
        .reset(       reset),       // Reset input (active-high)
        .digit_select(digit_select), // Output: one-hot encoded digit select
        .an_outputs(  an_outputs)   // Output: active-low anode controls
    );

    // Instantiate seven segment decoder
    seven_segment_decoder SEG_DECODER (
        .data( digit_to_display), // Input: 4-bit BCD digit to display
        .dp_in( in_DP),           // Input: Decimal point control
        .CA( CA), .CB( CB), .CC( CC), .CD( CD), .CE( CE), .CF( CF), .CG( CG), // Segment outputs (active-low)
        .DP( out_DP)              // Decimal point output (active-low)
    );

    // Connect anodes
    assign AN1 = an_outputs[0];
    assign AN2 = an_outputs[1];
    assign AN3 = an_outputs[2];
    assign AN4 = an_outputs[3];

    // Control the decimal point: You can modify `in_DP` assignment as per the design
    assign in_DP = 0;  // No decimal point by default, modify as needed
    assign DP = out_DP;  // Pass the decimal point signal from the decoder

endmodule
