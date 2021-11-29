module nextJumpController
#(parameter TAM_PC = 16)
(
	input wire  reset,
	input wire  [31:0] instruction,
	input wire  [(TAM_PC-1):0] PC,
	input wire  [31:0] regJmp, regCond,
	output wire [(TAM_PC-1):0] nextJump,
	output wire [31:0] PCShift,
	input wire [31:0] SP,
	input wire  clk,
	input wire [31:0] OSFirstLine,
	// config
	input wire [31:0] configLockPCGetter,
	input wire [31:0] configProcessInitialPCGetter,
	input wire [31:0] configProcessFinalPCGetter,
	input wire [31:0] configProcessPCGetter,
	input wire [31:0] configProcessSPGetter,
	input wire [31:0] configEnablePreemption,
	output wire [31:0] configProcessPCSetter,
	output wire [31:0] configProcessSPSetter,
	output wire [31:0] configLockPCSetter
);

reg [(TAM_PC-1):0] auxJump;
assign nextJump = auxJump;

reg [3:0] opcode;
reg [1:0] T;

reg [9:0] countQuantum;
parameter QUANTUM = 2;
reg [31:0] regConfigProcessPCSetter;
reg [31:0] regConfigProcessSPSetter;
reg [31:0] regConfigLockPCSetter;
assign configProcessPCSetter = regConfigProcessPCSetter;
assign configProcessSPSetter = regConfigProcessSPSetter;
assign configLockPCSetter = regConfigLockPCSetter;
initial regConfigLockPCSetter = 1;

assign PCShift = (PC < OSFirstLine) ? 0 : (configLockPCGetter == 2 ? OSFirstLine : configProcessInitialPCGetter);

reg [31:0] auxNextPC;

always @ (regJmp or regCond or PC) begin
	if (reset) auxNextPC = 16'b0000000000000000;
	else begin
		opcode = instruction[31:28];
		T = instruction[1:0];
		
		if (opcode == 4'b0110) begin
			case (T)
				2'b00: auxNextPC = PC + instruction[(TAM_PC-1+2):2];
				2'b01: auxNextPC = instruction[(TAM_PC-1+2):2] + ((configLockPCGetter == 2 && instruction[(TAM_PC-1+2):2] == 0) ? 0 : PCShift);
				2'b10: auxNextPC = regJmp[(TAM_PC-1):0] + ((configLockPCGetter == 2 && regJmp == 0) ? 0 : PCShift);
				2'b11: auxNextPC = regCond == {32{1'b1}} ? regJmp[(TAM_PC-1):0] + ((configLockPCGetter == 2 && regJmp == 0) ? 0 : PCShift) : {16'b0, PC + 1};
				default: auxNextPC = {16'b0, PC + 1};
			endcase
		end else auxNextPC = {16'b0, PC + 1};
	end

	if (configLockPCGetter == 0 && ((countQuantum == QUANTUM) || PC == configProcessFinalPCGetter)) begin // OR PC = finalPC
		regConfigProcessPCSetter = auxNextPC; // guardar PC atual no endereco de configuracao de ProcessPC
		regConfigProcessSPSetter = SP; // guardar SP atual no endereco de configuracao de ProcessSP
		regConfigLockPCSetter = 1; // travar o PC
		auxJump = 32'b0; // redirecionar PC para STORE_LOAD
	end
	else if (configLockPCGetter == 0 && PC < configProcessInitialPCGetter) begin
		regConfigLockPCSetter = 0;
		auxJump = configProcessPCGetter; // quando voltar da preempcao, continuar de onde parou
	end else begin
		regConfigLockPCSetter = 0;
		auxJump = auxNextPC;
	end	
end

always @ (posedge clk) begin
	if (configEnablePreemption == 1 && configLockPCGetter == 0 && countQuantum < QUANTUM) countQuantum = countQuantum + 1;
	else countQuantum = 0;
end

endmodule
