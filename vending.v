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
  
    assign reset_i   = ~reset;   
    assign enable_i  = reset;    
    assign nickel_i  = ~nickel;  
    assign dime_i    = ~dime;    
    assign quarter_i = ~quarter; 
    
    always @(posedge clk) clk_div <= clk_div + 1;

    fsm fsm_inst (
        .clk(clk_div[17]), 
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
        .reset(clk_div[16]),
        .bcdshow(dynval),
        .disp(disp),
        .dig(dig)
    );

endmodule
