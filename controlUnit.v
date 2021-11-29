module controlUnit (
	input wire  [31:0] instruction,
	output wire selTimer, selWriteEnableReg, selWriteEnableData, selOp2,
	output wire [3:0] selALU,
	output wire [1:0] selSpecial, selWrite,
	output wire selSP,
	input wire clk
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

reg regTimer, regWriteEnableReg, regWriteEnableData, regOp2, regSP;
reg [1:0] regWriteType, regWrite, regSpecial;
reg [3:0] regALU;

assign selTimer = regTimer;
assign selWriteEnableReg = regWriteEnableReg;
assign selWriteEnableData = regWriteEnableData;
assign selOp2 = regOp2;
assign selALU = regALU;
assign selWrite = regWrite;
assign selSpecial = regSpecial;
assign selSP = regSP;

wire [3:0] opcode;

assign opcode = instruction[31:28];

always @ (posedge clk) begin

	case (opcode)
        SUM: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = instruction[0];
            regALU = 4'b0000;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        SUBTRACT: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = instruction[0];
            regALU = 4'b0001;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        MULTIPLY: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = instruction[0];
            regALU = 4'b0010;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        DIVIDE: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = instruction[0];
            regALU = 4'b0011;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        LOGIC: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = instruction[2:0] == 3'b000 ? 4'b0110 :
							instruction[2:0] == 3'b001 ? 4'b0111 :
							instruction[2:0] == 3'b010 ? 4'b1000 :
							instruction[2:0] == 3'b011 ? 4'b1001 :
							instruction[2:0] == 3'b100 ? 4'b1010 :
							instruction[2:0] == 3'b101 ? 4'b1011 :
							instruction[2:0] == 3'b110 ? 4'b1100 :
							4'b1101;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        JUMP: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b0;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        STACK: begin
            regTimer = 1'b0;
            regWriteEnableReg = instruction[0] ? 1'b1 : 1'b0;
            regWriteEnableData = instruction[0] ? 1'b0 : 1'b1;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b00;
            regSpecial = 2'b00;
				regSP = 1'b1;
        end
        WRITE: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b11;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
        COPY: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b01;
            regSpecial = instruction[1:0];
				regSP = 1'b0;
        end
        LOAD: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b00;
            regSpecial = 2'b00;
				regSP = 1'b0;				
        end
        STORE: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b0;
            regWriteEnableData = 1'b1;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b10;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
		  INPUT: begin
            regTimer = 1'b0;
            regWriteEnableReg = 1'b1;
            regWriteEnableData = 1'b0;
            regOp2 = 1'b0;
            regALU = 4'b0000;
            regWrite = 2'b11;
            regSpecial = 2'b00;
				regSP = 1'b0;
        end
	endcase
end
endmodule
