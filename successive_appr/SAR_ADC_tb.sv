`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// TEST VALUES FOR THE SUCCESSIVE_APPR
//////////////////////////////////////////////////////////////////////////////////

module SAR_ADC_tb;
    // Testbench signals
    logic clk;
    logic rst;
    logic start_conversion;
    logic comparator_in;
    logic [7:0] dac_value;
    logic valid;
    logic busy;
    
    // Clock generation
    localparam CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end
    
    // Instantiate the SAR ADC
    SAR_ADC dut (
        .clk(clk),
        .rst(rst),
        .start_conversion(start_conversion),
        .comparator_in(comparator_in),
        .dac_value(dac_value),
        .valid(valid),
        .busy(busy)
    );
    
    // Simulated analog input value (0-255 for 8-bit ADC)
    logic [7:0] analog_input;
    
    // Compare function to simulate comparator behavior
    // Returns 1 if analog_input > dac_value, 0 otherwise
    function automatic logic compare_voltages(logic [7:0] analog_in, logic [7:0] dac_val);
        return (analog_in > dac_val);
    endfunction
    
    // Task to run a single conversion and check the result
    task automatic run_conversion(input logic [7:0] expected_value);
        $display("Starting conversion for analog input value: %d", expected_value);
        analog_input = expected_value;
        
        // Start conversion
        start_conversion = 1;
        @(posedge clk);
        start_conversion = 0;
        
        // Wait for busy signal
        wait(busy);
        
        // Monitor conversion process
        while (busy) begin
            // Update comparator output based on current DAC value
            comparator_in = compare_voltages(analog_input, dac_value);
            @(posedge clk);
        end
        
        // Check result
        if (valid) begin
            if (dac_value == expected_value)
                $display("PASS: Conversion result matches expected value: %d", expected_value);
            else
                $display("FAIL: Expected %d, got %d", expected_value, dac_value);
        end else begin
            $display("FAIL: Conversion didn't complete properly");
        end
        
        // Wait a few cycles between conversions
        repeat(5) @(posedge clk);
    endtask
    
    // Main test sequence
    initial begin
        // Initialize signals
        rst = 1;
        start_conversion = 0;
        comparator_in = 0;
        analog_input = 0;
        
        // Wait 5 clock cycles and release reset
        repeat(5) @(posedge clk);
        rst = 0;
        
        // Test various input values

      // TESTING STARTS HERE HEEHEE
      
        // Test 0
        run_conversion(8'd0);
        
        // Test maximum value
        run_conversion(8'd255);
        
        // Test middle value
        run_conversion(8'd128);
        
        // Test quarter value
        run_conversion(8'd64);
        
        // Test three-quarter value
        run_conversion(8'd192);
        
        // Test some random values
        run_conversion(8'd37);
        run_conversion(8'd173);
        run_conversion(8'd99);
        
        // Test consecutive values to check for sticky bits
        run_conversion(8'd100);
        run_conversion(8'd101);
        run_conversion(8'd102);
        
        // Add monitoring for timing
        $display("Average conversion time: %0d clock cycles", busy_cycles/num_conversions);
        
        // End simulation
        #(CLK_PERIOD*10);
        $display("Testbench completed");
        $finish;
    end
    
    // Monitor conversion time
    int busy_cycles = 0;
    int num_conversions = 0;
    
    always @(posedge clk) begin
        if (busy) busy_cycles++;
        if (valid) num_conversions++;
    end
    
    // Generate VCD file for waveform viewing
    initial begin
        $dumpfile("SAR_ADC_tb.vcd");
        $dumpvars(0, SAR_ADC_tb);
    end
    
    // Timeout watchdog
    initial begin
        #(CLK_PERIOD*10000);
        $display("Timeout: Simulation took too long");
        $finish;
    end
    
    // Additional debug monitoring
    always @(posedge clk) begin
        if (valid && busy) 
            $display("Warning: valid and busy both active at time %0t", $time);
    end

endmodule
