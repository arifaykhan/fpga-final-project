`timescale 1ns / 1ps

module tb_vending();
    // Inputs (Matching your vending module ports)
    reg clk;
    reg reset, nickel, dime, quarter;

    // Outputs
    wire led_dispense, led_collect;
    wire [6:0] disp;
    wire [5:0] dig;

    // Instantiate your vending module
    vending uut (
        .clk(clk),
        .reset(reset), 
        .nickel(nickel),
        .dime(dime),
        .quarter(quarter),
        .led_dispense(led_dispense),
        .led_collect(led_collect),
        .disp(disp),
        .dig(dig)
    );

    // 10ns Clock (Simulation speed)
    always #5 clk = ~clk;

    initial begin
        // Initialize: Buttons are Active-Low (1 = Released)
        clk = 0;
        reset = 1; nickel = 1; dime = 1; quarter = 1;

        // 1. Reset the system
        #10 reset = 0; #10 reset = 1; 
        #20;

        // 2. Enable: Logic is already handled (Enable is active when reset is 1)

        // 3. Insert arbitrary value < 50-cents (e.g., 35c)
        #10 quarter = 0; #10 quarter = 1; // Pulse Quarter
        #10 dime = 0;    #10 dime = 1;    // Pulse Dime
        #40; // Total should be 35

        // 4. Reset the system
        #10 reset = 0; #10 reset = 1;
        #20;

        // 5. Insert arbitrary value >= 50-cents (Group 11: 55c Price)
        // We will insert 60c to verify the "Collect" LED and change logic
        #10 quarter = 0; #10 quarter = 1; // 25
        #10 quarter = 0; #10 quarter = 1; // 50
        #10 dime = 0;    #10 dime = 1;    // 60

        // At this point:
        // led_dispense should be 1
        // led_collect should be 1
        // dynval (internal) should be 5 (60-55)
        #100;

        // 6. Final Reset
        #10 reset = 0; #10 reset = 1;

        #50 $finish;
    end
endmodule