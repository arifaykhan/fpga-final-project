module sevenseg (
    input reset, 
    input [6:0] bcdshow,
    output reg [6:0] disp,
    output reg [5:0] dig
);
    wire [3:0] tens = bcdshow / 10;
    wire [3:0] ones = bcdshow % 10; 
    reg digit_sel;

    always @(posedge reset) digit_sel <= ~digit_sel;

    always @(*) begin
        case(digit_sel)
            1'b0: begin dig = 6'b101111; decode(tens); end 
            1'b1: begin dig = 6'b011111; decode(ones); end 
            default: begin dig = 6'b111111; disp = 7'b1111111; end
        endcase
    end
	 
    task decode(input [3:0] bcd); 
        case(bcd)
            0: disp = 7'b1000000; 1: disp = 7'b1111001; 2: disp = 7'b0100100;
            3: disp = 7'b0110000; 4: disp = 7'b0011001; 5: disp = 7'b0010010;
            6: disp = 7'b0000010; 7: disp = 7'b1111000; 8: disp = 7'b0000000;
            9: disp = 7'b0010000; 
            default: disp = 7'b1111111; 
        endcase
    endtask
endmodule