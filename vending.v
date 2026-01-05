module vending (
    input clk,
    input reset, nickel, dime, quarter,
    output led_dispense, led_collect,
    output [6:0] disp,
    output [5:0] dig
);
    wire reset_i, nickel_i, dime_i, quarter_i, enable_i;
    wire [6:0] dynval;
    reg [21:0] clk_div;  
  
    // Logic for active-low buttons
    assign reset_i   = ~reset;   // Becomes 1 when KEY1 is pressed
    assign enable_i  = reset;    // Becomes 1 when KEY1 is NOT pressed
    assign nickel_i  = ~nickel;  // Becomes 1 when KEY2 is pressed
    assign dime_i    = ~dime;    // Becomes 1 when KEY3 is pressed
    assign quarter_i = ~quarter; // Becomes 1 when KEY4 is pressed

    always @(posedge clk) clk_div <= clk_div + 1;

    fsm fsm_inst (
        .clk(clk_div[17]), // Slow enough to debounce, fast enough to catch a click
        .reset(reset_i), 
        .enable(enable_i),
        .nickel(nickel_i), 
        .dime(dime_i), 
        .quarter(quarter_i),
        .dispout(dynval),
        .dispense(led_dispense), 
        .collect(led_collect)
    );

    sevenseg display_inst (
        .reset(clk_div[16]), // Renamed reset to clk_refresh for clarity
        .bcdshow(dynval),
        .disp(disp),
        .dig(dig)
    );
endmodule