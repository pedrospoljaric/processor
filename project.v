module project (
	input wire clk0,
	output wire clk,
	input wire switch, reset,
	output wire [15:0] PC,
	output wire [31:0] instruction,
	output wire [31:0] out,
	output wire selSP,
	output wire [31:0] configLockPCGetter,
	output wire [31:0] configLockMemGetter,
	output wire [31:0] configProcessInitialPCGetter,
	output wire [31:0] configProcessFinalPCGetter,
	output wire [31:0] currentProcessInitialMemoryGetter,
	output wire [31:0] configProcessPCGetter,
	output wire [31:0] configProcessSPGetter,
	output wire [31:0] configEnablePreemption,
	output wire [31:0] addressShift,
	output wire [31:0] PCShift,
	output wire [31:0] OSFirstLine,
	output wire [31:0] M154, R15
);

parameter SUM			= 4'b0000;
parameter SUBTRACT	= 4'b0001;
parameter MULTIPLY	= 4'b0010;
parameter DIVIDE		= 4'b0011;
parameter LOGIC		= 4'b0101;
parameter JUMP			= 4'b0110;
parameter STACK		= 4'b0111;
parameter WRITE		= 4'b1000;
parameter COPY			= 4'b1001;
parameter LOAD			= 4'b1010;
parameter STORE		= 4'b1011;
parameter INPUT		= 4'b1101;

reg [31:0] regOSFirstLine;
initial regOSFirstLine = 167;
assign OSFirstLine = regOSFirstLine;

wire [31:0] result;
wire [3:0] selALU;
wire [1:0] selWriteType;
wire [1:0] selWrite;
wire [1:0] selSpecial;
wire selTimer;
wire selWriteEnableReg;
wire selWriteEnableData;
wire selOp2;
wire [31:0] op1, op2;
wire [6:0] d0, d1, d2, d3, d4, d5, d6, d7;
wire [15:0] in;
wire [31:0] SP;
wire [31:0] writeData;
wire [5:0] R1, R2, R3;
wire [31:0] regData1;
wire [31:0] regData2;
wire [31:0] readData;
wire [31:0] dataAddress;

///////////////////////// config
//wire [31:0] configLockPCGetter;
//wire [31:0] configProcessInitialPCGetter;
//wire [31:0] configProcessFinalPCGetter;
//wire [31:0] configProcessPCGetter;
//wire [31:0] configProcessSPGetter;
wire [31:0] configProcessPCSetter;
wire [31:0] configProcessSPSetter;
wire [31:0] configLockPCSetter;
/////////////////////////

parameter TAM_PC = 16;
parameter NOOP = {31'b0, 1'b1};

wire [31:0] regCond;
wire [(TAM_PC-1):0] nextJump;
wire [(TAM_PC-1):0] nextPC;
wire [31:0] instructionPC;
wire [3:0]  opcode;
wire [31:0] immediate;
wire [31:0] copyData;
wire lock;
wire [31:0] regJmp;

assign regJmp = regData1;
assign regCond = regData2;
assign nextPC = selTimer || lock ? PC : nextJump;
assign instruction = selTimer ? NOOP : instructionPC;
assign opcode = instruction[31:28];
assign R3 = (opcode == 4'b0111 && instruction[0] == 0) || opcode == 4'b0110 || opcode == 4'b1011 ? instruction[15:10] : opcode == 4'b1010 ? instruction[27:22] : instruction[27:22];
assign R1 = (opcode == 4'b0111 && instruction[0] == 0) || opcode == 4'b0110 || opcode == 4'b1011 ? instruction[27:22] : opcode == 4'b1010 ? instruction[15:10] : instruction[21:16];
assign R2 = (opcode == 4'b0111 && instruction[0] == 0) || opcode == 4'b0110 || opcode == 4'b1011 ? instruction[21:16] : opcode == 4'b1010 ? instruction[21:16] : instruction[15:10];
assign op1 = regData1;
assign op2 = selOp2 ? immediate : regData2;
assign copyData = regData1;
assign writeData =
	selWrite == 2'b00 ? readData :
	selWrite == 2'b01 ? copyData :
	selWrite == 2'b10 ? result :
	selWrite == 2'b11 ? ((opcode == INPUT) ? {16'b0, in} : immediate) : 32'b0;

parameter UNLOCKED = 2'b00;
parameter LOCKED1 = 2'b01;
parameter LOCKED2 = 2'b10;
reg [1:0] state;
reg regLock;
assign lock = regLock;

nextJumpController(
	.reset(reset),
	.instruction(instruction),
	.PC(PC),
	.regJmp(regJmp),
	.regCond(regCond),
	.nextJump(nextJump),
	.PCShift(PCShift),
	.SP(SP),
	.clk(clk),
	.OSFirstLine(OSFirstLine),
	// config
	.configLockPCGetter(configLockPCGetter),
	.configProcessInitialPCGetter(configProcessInitialPCGetter),
	.configProcessFinalPCGetter(configProcessFinalPCGetter),
	.configProcessPCGetter(configProcessPCGetter),
	.configProcessSPGetter(configProcessSPGetter),
	.configEnablePreemption(configEnablePreemption),
	.configProcessPCSetter(configProcessPCSetter),
	.configProcessSPSetter(configProcessSPSetter),
	.configLockPCSetter(configLockPCSetter)
);

regPC(
	.nextPC(nextPC),
	.PC(PC),
	.clk(clk),
	.reset(reset)
); //Atualizar PC

regFile(
	.inReg1Addr(R1),
	.inReg2Addr(R2),
	.outRegAddr(R3),
	.writeData(writeData),
	.selWriteEnableReg(selWriteEnableReg),
	.reset(reset),
	.clk(clk),
	.inReg1Data(regData1),
	.inReg2Data(regData2),
	.outputData(out),
	.R15(R15)
);

//reg [31:0] regDataAddress;
//assign dataAddress = selSP ? regSP : regData2;
// como fazer os dois funcionarem ao mesmo tempo?

//reg [31:0] regSP;
//reg teste;
//initial regSP = 100;
//assign dataAddress = selSP ? (!instruction[0] ? regSP + 1 : regSP) : regData2;
//always @ (posedge selSP) begin
//	if (!instruction[0]) regSP = regSP - 1; // push
//	if (instruction[0]) regSP = regSP + 1; // pop
////	regDataAddress = selSP ? (instruction[0] ? regSP + 1 : regSP) : regData2;
//end

assign dataAddress = regData2;
// DATA MEMORY
dataMemory(
	.dataAddress(dataAddress),
	.inputData(regData1),
	.outputData(readData),
	.selWriteEnableData(selWriteEnableData),
	.clk(clk),
	.instruction(instruction),
	.reset(reset),
	.selSP(selSP),
	.SP(SP),
	.addressShift(addressShift),
	.PC(PC),
	.OSFirstLine(OSFirstLine),
	.M154(M154),
	// config
	.configLockPCGetter(configLockPCGetter),
	.configLockMemGetter(configLockMemGetter),
	.configProcessInitialPCGetter(configProcessInitialPCGetter),
	.configProcessFinalPCGetter(configProcessFinalPCGetter),
	.currentProcessInitialMemoryGetter(currentProcessInitialMemoryGetter),
	.configProcessPCGetter(configProcessPCGetter),
	.configProcessSPGetter(configProcessSPGetter),
	.configEnablePreemption(configEnablePreemption),
	.configProcessPCSetter(configProcessPCSetter),
	.configProcessSPSetter(configProcessSPSetter),
	.configLockPCSetter(configLockPCSetter)
);

// INPUT
 always @ (posedge clk) begin
	if (reset) begin
		state = (opcode == 4'b1101) ? LOCKED1 : UNLOCKED;
	end
	else begin
		if (state == UNLOCKED && opcode == 4'b1101) state = LOCKED1;
		if (switch && state == LOCKED1) state = LOCKED2;
		if (~switch && state == LOCKED2) state = UNLOCKED;
	end
	regLock = ~(state == UNLOCKED);
end

// CLOCK SAMPLER
//reg rclk;
assign clk = clk0;
//reg [25:0] count;
//always @ (posedge clk0) begin
//	count = count + 26'b1;
//	if (count == 26'd1) begin
//		rclk = ~rclk;
//		count = 0;
//	end
//end

programMemory(PC, instructionPC); // Mando PC, recebo instructionPC
immediateExtractor(.instruction(instruction), .immediate(immediate), .clk(clk));
decoder(out, d0, d1, d2, d3, d4, d5, d6, d7, reset);
alu(op1, op2, result, selALU);
controlUnit(
	.instruction(instructionPC),
	.selTimer(selTimer),
	.selWriteEnableReg(selWriteEnableReg),
	.selWriteEnableData(selWriteEnableData),
	.selOp2(selOp2),
	.selALU(selALU),
	.selSpecial(selSpecial),
	.selWrite(selWrite),
	.selSP(selSP),
	.clk(clk)
);

endmodule
