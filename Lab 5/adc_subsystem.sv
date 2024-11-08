// ADC Subsystem Module
module adc_subsystem (
    input  logic        clk,
    input  logic        reset,
    input  logic        vauxp15,
    input  logic        vauxn15,
    output logic [15:0] scaled_adc_data,
    output logic [15:0] raw_data,
    output logic [15:0] averaged_data
);
    // Internal signals
    logic        ready;
    logic [15:0] data;
    logic        enable;
    logic        eos_out;
    logic        busy_out;
    logic        ready_r, ready_pulse;

    // Constants
    localparam CHANNEL_ADDR = 7'h1f;     // XA4/AD15 (for XADC4)
    
    // XADC Instance
    xadc_wiz_0 XADC_INST (
        .di_in(16'h0000),
        .daddr_in(CHANNEL_ADDR),
        .den_in(enable),
        .dwe_in(1'b0),
        .drdy_out(ready),
        .do_out(data),
        .dclk_in(clk),
        .reset_in(reset),
        .vp_in(1'b0),
        .vn_in(1'b0),
        .vauxp15(vauxp15),
        .vauxn15(vauxn15),
        .channel_out(),
        .eoc_out(enable),
        .alarm_out(),
        .eos_out(eos_out),
        .busy_out(busy_out)
    );

    // Averager Instance
    averager #(
        .power(12),
        .N(16)
    ) AVERAGER (
        .reset(reset),
        .clk(clk),
        .EN(ready_pulse),
        .Din(data),
        .Q(averaged_data)
    );

    // Ready pulse generation
    always_ff @(posedge clk) begin
        if (reset)
            ready_r <= 0;
        else
            ready_r <= ready;
    end
    
    assign ready_pulse = ~ready_r & ready;

    // Scaling logic
    always_ff @(posedge clk) begin
        if (reset) begin
            scaled_adc_data <= 0;
        end
        else if (ready_pulse) begin
            scaled_adc_data <= (averaged_data * 1250) >> 13;
        end
    end

    // Output raw data
    assign raw_data = data;

endmodule
