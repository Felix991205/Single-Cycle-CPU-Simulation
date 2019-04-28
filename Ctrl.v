`include "ctrl_encode_def.v"
`include "instruction_def.v"

module Ctrl(jump,RegDst,Branch,Mem2R,MemW,MemR,RegW,Alusrc,ExtOp,Aluctrl,OpCode,funct);
	
	input [5:0]		OpCode;				
	input [5:0]		funct;				
	

	output reg jump;						
	output reg RegDst;				//determine which data to be feed into reg with RegW signal	
	output reg Branch;
	output reg MemR;					//Memory Read
	output reg Mem2R;					//Memory to Reg
	output reg MemW;					//Memory Write
	output reg RegW;					//Register Write
	output reg Alusrc;				//ALU Source
	output reg[1:0] ExtOp;		//=0 zeroextend =1 signedextend =2 high16-bit 
	output reg[4:0] Aluctrl;	//ALU control signal
	
	always @(OpCode or funct)
	begin
		case(OpCode)
			//R type
			`INSTR_RTYPE_OP:
			begin
				jump = 0;
				RegDst = 0;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
			case(funct)
				`INSTR_SUB_FUNCT:	
				begin
					Aluctrl = `ALUOp_SUB;
				end
				`INSTR_ADD_FUNCT:	
				begin
					Aluctrl = `ALUOp_ADD;
				end
	           `INSTR_ADDU_FUNCT:
				begin
					Aluctrl = `ALUOp_ADDU;
	            end
	            `INSTR_SUBU_FUNCT:
	            begin
					Aluctrl = `ALUOp_SUBU;
	            end
				`INSTR_SLL_FUNCT:
				begin
					Aluctrl = `ALUOp_SLL;
				end
				`INSTR_SRL_FUNCT:
				begin
					Aluctrl = `ALUOp_SRL;
				end
				`INSTR_SLT_FUNCT:
				begin
					Aluctrl = `ALUOp_SLT;
				end
				`INSTR_AND_FUNCT:
				begin
					Aluctrl = `ALUOp_AND;
				end
				
			endcase
			end
			
			//lw
			`INSTR_LW_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 1;
				Mem2R = 1;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_ADD;
			end

			//sw
			`INSTR_SW_OP:
			begin
				jump = 0;
				RegDst = 0; //x
				Branch = 0;
				MemR = 0;
				Mem2R = 0; //x
				MemW = 1;
				RegW = 0;
				Alusrc = 1;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_ADD;
			end

			//beq
			`INSTR_BEQ_OP:
			begin
				jump = 0;
				RegDst = 0;//x
				Branch = 1;
				MemR = 0;
				Mem2R = 0; //x
				MemW = 0;
				RegW = 0;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_SUB;
			end

			//ori
			`INSTR_ORI_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_OR;
			end

			//lui
			`INSTR_LUI_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_HIGHPOS;
				Aluctrl = `ALUOp_ADD;
			end

			//bne
			`INSTR_BNE_OP:
			begin
				jump = 0;
				RegDst = 0;//x
				Branch = 1;
				MemR = 0;
				Mem2R = 0; //x
				MemW = 0;
				RegW = 0;
				Alusrc = 0;
				ExtOp = `EXT_ZERO;
				Aluctrl = `ALUOp_BNE;
			end
			
			//jump
			`INSTR_J_OP:
			begin
				jump=1;
				RegDst = 1;//x
				Branch = 0;
				MemR = 0;
				Mem2R = 0;//x
				MemW = 0;
				RegW = 0;
				Alusrc = 1;//x
				ExtOp = `EXT_ZERO;//x
				Aluctrl = `ALUOp_ADD;//x
			end
			
			
			//slti
			`INSTR_SLTI_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_SLT;
			end

			//addi
			`INSTR_ADDI_OP:
			begin
				jump = 0;
				RegDst = 1;
				Branch = 0;
				MemR = 0;
				Mem2R = 0;
				MemW = 0;
				RegW = 1;
				Alusrc = 1;
				ExtOp = `EXT_SIGNED;
				Aluctrl = `ALUOp_ADD;
			end
				
	    endcase
	end
endmodule
	
