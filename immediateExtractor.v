module immediateExtractor (
	input wire  [31:0] instruction,
	output wire [31:0] immediate,
	input wire clk
);

parameter SUM			= 4'b0000;
parameter SUBTRACT	= 4'b0001;
parameter MULTIPLY	= 4'b0010;
parameter DIVIDE		= 4'b0011;
parameter SHIFT		= 4'b0100;
parameter LOGIC		= 4'b0101;
parameter JUMP			= 4'b0110;
parameter STACK		= 4'b0111;
parameter WRITE		= 4'b1000;
parameter COPY			= 4'b1001;
parameter LOAD			= 4'b1010;
parameter STORE		= 4'b1011;
parameter SLEEP		= 4'b1100;

reg [3:0] opcode;
reg  [31:0] auxImmediate;
assign immediate = auxImmediate;

always @ (posedge clk) begin
	opcode = instruction[31:28];
	case (opcode)
		SUM, SUBTRACT, MULTIPLY, DIVIDE:	auxImmediate = !instruction[0] ? 32'b0 : {15'b0, instruction[15:1]};
		JUMP:					auxImmediate = instruction[1:0] == 2'b00 || instruction[1:0] == 2'b01 ? {6'b0, instruction[27:2]} : 32'b0;
		WRITE:				auxImmediate = {9'b0, instruction[21:0]};
		default:				auxImmediate = 32'b0;
	endcase
end
endmodule
