module decoder (
	input wire [31:0] out,
	output wire [6:0] d0, d1, d2, d3, d4, d5, d6, d7,
	input wire reset
);

reg [31:0] b0, b1, b2, b3, b4, b5, b6, b7;
reg [6:0] r0, r1, r2, r3, r4, r5, r6, r7;

assign d0 = r0;
assign d1 = r1;
assign d2 = r2;
assign d3 = r3;
assign d4 = r4;
assign d5 = r5;
assign d6 = r6;
assign d7 = r7;

always @ (out or reset) begin
	b0 = reset ? {32{1'b1}} : (out) % 10;
	b1 = reset ? {32{1'b1}} : (out/10) % 10;
	b2 = reset ? {32{1'b1}} : (out/100) % 10;
	b3 = reset ? {32{1'b1}} : (out/1000) % 10;
	b4 = reset ? {32{1'b1}} : (out/10000) % 10;
	b5 = reset ? {32{1'b1}} : (out/100000) % 10;
	b6 = reset ? {32{1'b1}} : (out/1000000) % 10;
	b7 = reset ? {32{1'b1}} : (out/10000000) % 10;	
   case (b0[3:0])
		4'b0000: r0 = 7'b0000001;
		4'b0001: r0 = 7'b1001111;
		4'b0010: r0 = 7'b0010010;
		4'b0011: r0 = 7'b0000110;
		4'b0100: r0 = 7'b1001100;
		4'b0101: r0 = 7'b0100100;
		4'b0110: r0 = 7'b0100000;
		4'b0111: r0 = 7'b0001111;
		4'b1000: r0 = 7'b0000000;
		4'b1001: r0 = 7'b0000100;
		default: r0 = 7'b1111111;
	endcase
   case (b1[3:0])
		4'b0000: r1 = 7'b0000001;
		4'b0001: r1 = 7'b1001111;
		4'b0010: r1 = 7'b0010010;
		4'b0011: r1 = 7'b0000110;
		4'b0100: r1 = 7'b1001100;
		4'b0101: r1 = 7'b0100100;
		4'b0110: r1 = 7'b0100000;
		4'b0111: r1 = 7'b0001111;
		4'b1000: r1 = 7'b0000000;
		4'b1001: r1 = 7'b0000100;
		default: r1 = 7'b1111111;
	endcase
   case (b2[3:0])
		4'b0000: r2 = 7'b0000001;
		4'b0001: r2 = 7'b1001111;
		4'b0010: r2 = 7'b0010010;
		4'b0011: r2 = 7'b0000110;
		4'b0100: r2 = 7'b1001100;
		4'b0101: r2 = 7'b0100100;
		4'b0110: r2 = 7'b0100000;
		4'b0111: r2 = 7'b0001111;
		4'b1000: r2 = 7'b0000000;
		4'b1001: r2 = 7'b0000100;
		default: r2 = 7'b1111111;
	endcase
   case (b3[3:0])
		4'b0000: r3 = 7'b0000001;
		4'b0001: r3 = 7'b1001111;
		4'b0010: r3 = 7'b0010010;
		4'b0011: r3 = 7'b0000110;
		4'b0100: r3 = 7'b1001100;
		4'b0101: r3 = 7'b0100100;
		4'b0110: r3 = 7'b0100000;
		4'b0111: r3 = 7'b0001111;
		4'b1000: r3 = 7'b0000000;
		4'b1001: r3 = 7'b0000100;
		default: r3 = 7'b1111111;
	endcase
   case (b4[3:0])
		4'b0000: r4 = 7'b0000001;
		4'b0001: r4 = 7'b1001111;
		4'b0010: r4 = 7'b0010010;
		4'b0011: r4 = 7'b0000110;
		4'b0100: r4 = 7'b1001100;
		4'b0101: r4 = 7'b0100100;
		4'b0110: r4 = 7'b0100000;
		4'b0111: r4 = 7'b0001111;
		4'b1000: r4 = 7'b0000000;
		4'b1001: r4 = 7'b0000100;
		default: r4 = 7'b1111111;
	endcase
   case (b5[3:0])
		4'b0000: r5 = 7'b0000001;
		4'b0001: r5 = 7'b1001111;
		4'b0010: r5 = 7'b0010010;
		4'b0011: r5 = 7'b0000110;
		4'b0100: r5 = 7'b1001100;
		4'b0101: r5 = 7'b0100100;
		4'b0110: r5 = 7'b0100000;
		4'b0111: r5 = 7'b0001111;
		4'b1000: r5 = 7'b0000000;
		4'b1001: r5 = 7'b0000100;
		default: r5 = 7'b1111111;
	endcase
   case (b6[3:0])
		4'b0000: r6 = 7'b0000001;
		4'b0001: r6 = 7'b1001111;
		4'b0010: r6 = 7'b0010010;
		4'b0011: r6 = 7'b0000110;
		4'b0100: r6 = 7'b1001100;
		4'b0101: r6 = 7'b0100100;
		4'b0110: r6 = 7'b0100000;
		4'b0111: r6 = 7'b0001111;
		4'b1000: r6 = 7'b0000000;
		4'b1001: r6 = 7'b0000100;
		default: r6 = 7'b1111111;
	endcase
   case (b7[3:0])
		4'b0000: r7 = 7'b0000001;
		4'b0001: r7 = 7'b1001111;
		4'b0010: r7 = 7'b0010010;
		4'b0011: r7 = 7'b0000110;
		4'b0100: r7 = 7'b1001100;
		4'b0101: r7 = 7'b0100100;
		4'b0110: r7 = 7'b0100000;
		4'b0111: r7 = 7'b0001111;
		4'b1000: r7 = 7'b0000000;
		4'b1001: r7 = 7'b0000100;
		default: r7 = 7'b1111111;
	endcase
end
endmodule
