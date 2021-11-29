module programMemory
#(parameter TAM_PC = 16)
(
	input wire  [(TAM_PC-1):0] PC,
	output wire [31:0] instructionPC
);

reg [31:0] instructions[599:0];
reg [31:0] regInstr;
assign instructionPC = regInstr;

initial begin
	$readmemb("program.txt", instructions);
end

always @ (PC) regInstr <= instructions[PC];
endmodule
