`timescale 1ns / 1ps

module lab_3_top_level_tb();

parameter CLK_PERIOD = 10;
parameter DELAY = 6000000;
parameter RESET_DURATION = 5 * CLK_PERIOD;
parameter CONVERSION_TIME = 20 * CLK_PERIOD;
parameter QUARTER_CYCLE = CLK_PERIOD / 4;

logic clk;
logic reset;
logic [15:0] switches_inputs;
logic CA, CB, CC, CD, CE, CF, CG, DP;
logic AN1, AN2, AN3, AN4;
logic [15:0] led;
logic select;

lab_3_top_level uut(
    .clk(clk),
    .reset(reset),
    .switches_inputs(switches_inputs),
    .CA(CA),
    .CB(CB),
    .CC(CC),
    .CD(CD),
    .CE(CE),
    .CF(CF),
    .CG(CG),
    .DP(DP),
    .AN1(AN1),
    .AN2(AN2),
    .AN3(AN3),
    .AN4(AN4),
    .led(led),
    .select(select)
);

// clock generation
always begin
    clk = 0;
    #(CLK_PERIOD/2);
    clk = 1;
    #(CLK_PERIOD/2);
end


    
    // Test stimulus
initial begin
        // Initialize inputs
    reset = 1'b1; #CLK_PERIOD;
    reset = 1'b0; #CLK_PERIOD;
    select = 0;
    
        // Test case 1:
    switches_inputs = 16'b0000_0000_0000_0000; #DELAY;
    reset = 1'b0;
        // Test case 2:
    switches_inputs = 16'b1111_1111_1111_1111; #DELAY;
    reset = 1'b0;
    select = 1;
        // Test case 2:
    switches_inputs = 16'b0101_0101_0101_0101; #DELAY;
    reset = 1'b0;
        // Test case 3:
    switches_inputs = 16'b1010_1010_1010_1010; #DELAY;
    reset = 1'b0;
    select = 0;    
        // Test case 4:
    switches_inputs = 16'b1100_1100_1100_1100; #DELAY;
    reset = 1'b0;     
        // Test case 5:
    switches_inputs = 16'b0011_0011_0011_0011; #DELAY;
    reset = 1'b1;      
        // End simulation
    #(5 * CLK_PERIOD);
    $stop;
end
    
    // Optional: Monitor changes
    initial begin
        $monitor("Time = %0t: switches_inputs = %b, led = %b", 
                 $time, switches_inputs, led);
    end
    
endmodule