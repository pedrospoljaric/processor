module alu (
	input  [31:0] op1,
	input  [31:0] op2,
	output [31:0] result,
	input  [3:0]  selALU
);

parameter SUM                = 4'b0000;
parameter SUBTRACT           = 4'b0001;
parameter MULTIPLY           = 4'b0010;
parameter DIVIDE             = 4'b0011;
parameter BITWISE_NOT        = 4'b0110;
parameter LOGIC_EQUAL        = 4'b1010;
parameter LOGIC_DIFFERENT    = 4'b1011;
parameter LOGIC_GREATER_THAN = 4'b1100;
parameter LOGIC_LESS_THAN    = 4'b1101;

reg [31:0] aux, aux2;
assign result = aux;

always @(op1 or op2 or selALU) begin
	aux = 32'b0;
	case (selALU)
		SUM:                aux = op1 + op2;
		SUBTRACT:           aux = op1 - op2;
		MULTIPLY:           {aux2, aux} = op1 * op2;
		DIVIDE: begin
		                    aux = op1 / op2;
		                    aux2 = op1 % op2;
		end
		BITWISE_NOT:        aux = ~op1;
		LOGIC_EQUAL:        aux = {32{op1 == op2}};
		LOGIC_DIFFERENT:    aux = {32{op1 != op2}};
		LOGIC_LESS_THAN:    aux = {32{op1 < op2}};
		LOGIC_GREATER_THAN: aux = {32{op1 > op2}};
		default: 			  aux = 0;
	endcase
end
endmodule