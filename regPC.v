module regPC (
	input wire  [15:0] nextPC,
	output wire [15:0] PC,
	input wire  clk, reset
);

reg [15:0] aux;
assign PC = aux;

always @ (negedge clk) begin
	if (reset) aux = 16'b0;
	else begin
		aux = nextPC;
	end
end

endmodule
