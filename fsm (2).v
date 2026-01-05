module fsm (
    input clk,
    input reset,
    input enable,
    input nickel, dime, quarter,
    output [6:0] dispout, 
    output dispense,
    output collect
);
    parameter PRICE = 55; 
    reg [6:0] state;
    
    // Registers to store the previous state of the buttons
    reg n_prev, d_prev, q_prev;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 0;
            n_prev <= 0; d_prev <= 0; q_prev <= 0;
        end else if (enable) begin
            // Update previous state registers
            n_prev <= nickel;
            d_prev <= dime;
            q_prev <= quarter;

            // Only add money on the "Rising Edge" (when button goes 0 -> 1)
            if (nickel && !n_prev)         state <= state + 5;
            else if (dime && !d_prev)      state <= state + 10;
            else if (quarter && !q_prev)   state <= state + 25;
        end
    end

    assign dispout = (state >= PRICE) ? (state - PRICE) : state;
    assign dispense = (state >= PRICE); 
    assign collect = (state > PRICE);   
endmodule