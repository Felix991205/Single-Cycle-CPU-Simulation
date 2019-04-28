`include "ctrl_encode_def.v"
module Alu(AluResult,Zero,DataIn1,DataIn2,AluCtrl,shamt);	

	input  [31:0] 	DataIn1;		//运算数据1
	input  [31:0]		DataIn2;		//运算数据2
	input  [4:0]		AluCtrl;		//运算器控制信号
	input  [4:0]		shamt;
	
	output reg[31:0]		AluResult;		//运算器输出结果
	output reg					Zero;			//结果是否为零
	
	initial								//初始化数据
	begin
		Zero = 0;
		AluResult = 0;
	end	
	
	
	always@(DataIn1 or DataIn2 or AluCtrl or shamt)
	begin
		case ( AluCtrl )
         `ALUOp_ADDU: AluResult = DataIn1 + DataIn2;
         `ALUOp_SUBU: AluResult = DataIn1 - DataIn2;
         `ALUOp_ADD: AluResult = DataIn1 + DataIn2;
         `ALUOp_SUB: AluResult = DataIn1 - DataIn2;
         `ALUOp_AND:  AluResult = DataIn1 & DataIn2;
				 `ALUOp_OR:   AluResult = DataIn1 | DataIn2;
		     `ALUOp_NOR:  AluResult = ~ ( DataIn1 | DataIn2 );
		     `ALUOp_SLL:  AluResult = DataIn2 << shamt;
		     `ALUOp_SRL:  AluResult = DataIn2 >> shamt;
		 
		 `ALUOp_SLT:  
		 begin
		 if(DataIn1[31]==1&&DataIn2[31]==1)
			AluResult=DataIn1<DataIn2?1:0;
		 if(DataIn1[31]==0&&DataIn2[31]==0)
			AluResult = DataIn1 < DataIn2? 1 : 0;
		 if(DataIn1[31]==1&&DataIn2[31]==0)
			AluResult=1;
		 if(DataIn1[31]==0&&DataIn2[31]==1)
			AluResult=0;
		 
		 end
		 
		 `ALUOp_BNE:
			begin
				if(DataIn1-DataIn2==0)
					AluResult=1;
			    if(DataIn1-DataIn2!=0)
					AluResult=0;
			end
		 
         default: ;
        endcase
      
        if(AluResult==0)
            Zero=1;
        else
            Zero=0;
	end

endmodule