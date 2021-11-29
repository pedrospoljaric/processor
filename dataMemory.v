module dataMemory (
	input wire  [31:0] dataAddress,
	input wire  [31:0] inputData,
	output wire [31:0] outputData,
	input wire 			 selWriteEnableData, clk,
	input wire  [31:0] instruction,
	input wire         reset,
	input wire 			 selSP,
	output wire [31:0] SP,
	output wire [31:0] addressShift,
	input wire [31:0] PC,
	input wire [31:0] OSFirstLine,
	output wire [31:0] M154,
	// config
	output wire [31:0] configLockPCGetter,
	output wire [31:0] configLockMemGetter,
	output wire [31:0] configProcessInitialPCGetter,
	output wire [31:0] configProcessFinalPCGetter,
	output wire [31:0] configProcessPCGetter,
	output wire [31:0] configProcessSPGetter,
	output wire [31:0] currentProcessInitialMemoryGetter,
	output wire [31:0] configEnablePreemption,
	input wire [31:0] configProcessPCSetter,
	input wire [31:0] configProcessSPSetter,
	input wire [31:0] configLockPCSetter
);

reg [31:0] memory[599:0];
assign addressShift = (memory[0] == 32'b1 || (PC >= OSFirstLine - 13 && PC < OSFirstLine) || (PC >= 72 && PC <= 81)) ? 0 : memory[3];

assign M154 = memory[154];

assign configLockMemGetter = memory[0];
assign configProcessInitialPCGetter = memory[1];
assign configProcessFinalPCGetter = memory[2];
assign currentProcessInitialMemoryGetter = memory[3];
assign configProcessPCGetter = memory[4];
assign configProcessSPGetter = memory[5];
assign configLockPCGetter = memory[6];
assign configEnablePreemption = memory[7];

// STACK
reg [31:0] shiftSP;
reg [31:0] OSShiftSP;
initial OSShiftSP = 0;
assign SP = 199 - 64 - ((memory[0] == 32'b1 || (PC >= OSFirstLine - 13 && PC < OSFirstLine)) ? OSShiftSP : shiftSP);

always @ (posedge clk) begin
	if (instruction[31:28] == 4'b0111) begin
		if (!instruction[0]) begin // push
			if (memory[0] == 32'b1) OSShiftSP = OSShiftSP + 1;
			else shiftSP = shiftSP + 1;
		end if (instruction[0]) begin // pop
			if (memory[0] == 32'b1) OSShiftSP = OSShiftSP - 1;
			else shiftSP = shiftSP - 1;
		end
	end
end

assign outputData = selSP ? memory[addressShift + SP] :  memory[addressShift + dataAddress];

initial memory[6] = 1;

reg [31:0] prevConfigProcessPCSetter, prevConfigProcessSPSetter;
initial prevConfigProcessPCSetter = configProcessPCSetter;
initial prevConfigProcessSPSetter = configProcessSPSetter;

always @ (negedge clk) begin
	if (prevConfigProcessPCSetter != configProcessPCSetter) begin
		memory[4] = configProcessPCSetter;
		prevConfigProcessPCSetter = configProcessPCSetter;
	end

	if (prevConfigProcessSPSetter != configProcessSPSetter) begin
		memory[5] = configProcessSPSetter;
		prevConfigProcessSPSetter = configProcessSPSetter;
	end
	
	if (memory[6] == 0 && configLockPCSetter == 1) memory[6] = 1;

	if (selWriteEnableData) begin
		if (selSP) begin
			memory[addressShift + SP + 1] <= inputData;
		end else begin
			memory[addressShift + dataAddress] <= inputData;
		end
	end
end

endmodule
