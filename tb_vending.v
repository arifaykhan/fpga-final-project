`timescale 1ns / 1ps

module tb_vending();
    reg clk;
    reg reset, nickel, dime, quarter;

    wire led_dispense, led_collect;
    wire [6:0] disp;
    wire [5:0] dig;

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

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1; nickel = 1; dime = 1; quarter = 1;

        #10 reset = 0; #10 reset = 1; 
        #20;

        #10 quarter = 0; #10 quarter = 1; 
        #10 dime = 0;    #10 dime = 1;    
        #40; 
        
        #10 reset = 0; #10 reset = 1;
        #20;

        #10 quarter = 0; #10 quarter = 1;
        #10 quarter = 0; #10 quarter = 1; 
        #10 dime = 0;    #10 dime = 1;    
        
        #100;

        #10 reset = 0; #10 reset = 1;

        #50 $finish;
    end

endmodule
