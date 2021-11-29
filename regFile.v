module regFile (
	input wire  [5:0]  inReg1Addr, inReg2Addr, outRegAddr,
	input wire  [31:0] writeData,
	input wire 			 selWriteEnableReg, clk, reset,
	output wire [31:0] inReg1Data, inReg2Data, outputData,
	output wire [31:0] R15
);

parameter REGULAR = 2'b00;
parameter MULT = 2'b01;
parameter DIV = 2'b10;

parameter LS = 61;
parameter QUO = 62;
parameter OUT = 63;

reg [31:0] registers[63:0];

reg [31:0] auxInReg1Data, auxInReg2Data;
assign inReg1Data = auxInReg1Data;
assign inReg2Data = auxInReg2Data;

assign outputData = registers[OUT];

assign R15 = registers[15];

always @ (posedge clk) begin
	auxInReg1Data = registers[inReg1Addr];
	auxInReg2Data <= registers[inReg2Addr];
end

always @ (negedge clk) begin	
	if (reset) registers[OUT] = 31'b0;
	if (selWriteEnableReg) registers[outRegAddr] = writeData;
end

endmodule
