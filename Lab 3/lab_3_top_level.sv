module lab_3_top_level(
    input logic clk,
    input logic reset,
    input logic select1,
    input logic select2,
    input logic en,
    input  logic [15:0] switches_inputs, // slide switches (0 towards Basys3 board edge, 1 towards board center)
   
    output logic [15:0] led, // mapped to the LEDs above the slide switches, LEDs: write a 1 to light LED, 0 to turn it off
    output logic CA, CB, CC, CD, CE, CF, CG, DP,
    output logic AN1, AN2, AN3, AN4
);


    // Internal signal declarations
    logic        in_DP, out_DP;
    logic [3:0]  an_i;
    logic [3:0]  digit_to_display;
    logic [15:0] bcd_value, mux_out, switches_outputs, switches_reg;
    logic [15:0] bcd_out;
    logic [15:0] to_display;
    logic [15:0] mem_out_dec;
    logic [15:0] mem_out_hex;
    logic [15:0] switches_inputs_synch;
    logic        debounced_en;
    logic        debounced_select1;
    logic        debounced_select2;
    
    // Instantiate components
    seven_segment_display_subsystem SEVEN_SEGMENT_DISPLAY (
    .clk(           clk),
    .reset(         reset),
    .sec_dig1(      to_display [3:0]),
    .sec_dig2(      to_display [7:4]),
    .min_dig1(      to_display [11:8]),
    .min_dig2(      to_display [15:12]),
    .CA(            CA),
    .CB(            CB),
    .CC(            CC),
    .CD(            CD),
    .CE(            CE),
    .CF(            CF),
    .CG(            CG),
    .DP(            DP),
    .AN1(           AN1),
    .AN2(           AN2),
    .AN3(           AN3),
    .AN4(           AN4)
   );
   
   bin_to_bcd BDC_CONV(
    .bin_in(switches_inputs_synch),
    .bcd_out(bcd_out),
    .clk(clk),
    .reset(reset)
  );
  
  dec_hex_mux DEC_HEX_MUX(
  .decimal(bcd_out),
  .hexadecimal(switches_inputs_synch),
  .decimal_old(mem_out_dec),
  .hexadecimal_old(mem_out_hex),
  .selector1(debounced_select1),
  .selector2(debounced_select2),
  .to_display(to_display)
  );
  
  register_mem DEC_OLDIES(
  .clk(clk),
  .switches_in(bcd_out),
  .reset(reset),
  .en(debounced_en),
  .mem_out(mem_out_dec)
  );
  
  register_mem HEX_OLDIES(
  .clk(clk),
  .switches_in(switches_inputs_synch),
  .reset(reset),
  .en(debounced_en),
  .mem_out(mem_out_hex)
  );
  
  synch SYNCH(
  .clk(clk),
  .d(switches_inputs),
  .q(switches_inputs_synch)
  );
  
  debounce BOUNCE_EN(
  .clk(clk),
  .reset(reset),
  .button(en),
  .result(debounced_en)
  );
  
  debounce BOUNCE_SEL1(
  .clk(clk),
  .reset(reset),
  .button(select1),
  .result(debounced_select1)
  );
  
  debounce BOUNCE_SEL2(
  .clk(clk),
  .reset(reset),
  .button(select2),
  .result(debounced_select2)
  );


    switch_logic SWITCHES (
         .switches_inputs(switches_inputs),
         .switches_outputs(switches_outputs)
    );
      
    assign led = switches_outputs;

endmodule
