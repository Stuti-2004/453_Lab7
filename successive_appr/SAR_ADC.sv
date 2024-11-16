module sar_adc (
    input  logic clk,                // Clock signal
    input  logic rst,                // Reset signal
    input  logic start_conversion,   // Signal to start a new conversion
    input  logic comparator_in,      // Input from the comparator (1 if analog > DAC)
    output logic [7:0] dac_value,    // 8-bit output to DAC
    output logic valid,              // Goes high when conversion is done
    output logic busy                // Shows when conversion is in progress
);

  // Internal FSM States
typedef enum {
    IDLE,      // Waiting for start
    SAMPLE,    // Setting up DAC value
    COMPARE,   // Waiting for comparator
    UPDATE,    // Processing result
    DONE       // Conversion complete
} state_t;

    state_t state, next_state;
    
    logic [7:0] result;        // Final conversion result
    logic [3:0] bit_counter;   // Tracks which bit we're testing
    logic [7:0] test_value;    // Current value being tested
    
    // State register
    // Basically just checks ifRESET is 0 or not
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        
        case (state)
            IDLE: begin
              // checks if conversion should start
                if (start_conversion)
                    next_state = SAMPLE;
            end
            
            SAMPLE: begin
                next_state = COMPARE;
            end
            
            COMPARE: begin
                next_state = UPDATE;
            end
            
            UPDATE: begin
                if (bit_counter == 0)
                    next_state = DONE;
                else
                    next_state = COMPARE;
            end
            
            DONE: begin
                next_state = IDLE;
            end
            
            default: next_state = IDLE;
        endcase
    end
    
    // Datapath logic
    always_ff @(posedge clk) begin
        if (rst) begin
            result <= '0;
            bit_counter <= 7;    // Start with MSB (bit 7)
            test_value <= 8'h80; // Start with 1000_0000
            valid <= 0;
            busy <= 0;
            dac_value <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (start_conversion) begin
                        result <= '0;
                        bit_counter <= 7;    // Start with MSB
                        test_value <= 8'h80; // Start with 1000_0000
                        valid <= 0;
                        busy <= 1;
                    end
                end
                
                SAMPLE: begin
                    dac_value <= test_value;
                end
                
                COMPARE: begin
                    // No action needed here - waiting for comparator
                end
                
                UPDATE: begin
                    if (comparator_in) begin
                        // Input voltage is higher than test voltage
                        // Keep the bit set in result
                        result <= result | test_value;
                    end
                    // Prepare next bit test
                    test_value <= test_value >> 1; // shifts test bit over to next lower bit
                    bit_counter <= bit_counter - 1; // lowers bit counter by 1
                  dac_value <= (test_value >> 1); // saves final value bit
                end
                
                DONE: begin
                    valid <= 1;
                    busy <= 0;
                    dac_value <= result;
                end
                
                default: begin
                    result <= '0;
                    valid <= 0;
                end
            endcase
        end
    end

endmodule
