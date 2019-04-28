`include "ctrl_encode_def.v"
`include "instruction_def.v"

module Mips(Clk,rstn,disp_seg_o,disp_an_o,led_o,sw_i);
//////////////////// input, output and wires ////////////////////
//Input and Output
	input Clk;			//clock of the chip
	input rstn;			//reset signal of the chip
	input [15:0] sw_i;  //button of the chip

	output [7:0] disp_an_o,disp_seg_o;	//signal of seg7*16
	output [15:0] led_o;				//signal of LED


//clkdiv	
	reg[31:0] clkdiv;	

//seg7*16
	wire [31:0] disp_data;
  
//Reset
	wire Reset;

//Frequency Demultiplicated Clock
	wire clk_cpu;

//PC	
	wire [31:0] pcOut;

//IM	
	wire [5:0]  imAdr;
	wire [31:0] opCode;
	
//GPR
	wire [4:0] gprWeSel,gprReSel1,gprReSel2;
	wire [31:0] gprDataIn;
	wire [31:0] gprDataOut1,gprDataOut2;
	
//Extender
	wire [15:0] extDataIn;
	wire [31:0] extDataOut;

//DMem
	wire [4:0]  dmDataAdr;
	wire [31:0] dmDataOut;
	wire[31:0] indexout;
	
//Ctrl
	wire [4:0]		shamt;
	wire [5:0]		op;
	wire [5:0]		funct;
	wire 		jump;						
	wire 		RegDst;						
	wire 		Branch;						
	wire 		MemR;						
	wire 		Mem2R;						
	wire 		MemW;						
	wire 		RegW;						
	wire		Alusrc;						
	wire [1:0]	ExtOp;						
	wire [4:0]  Aluctrl;					
	


//Alu
	wire [31:0] aluDataIn2;
	wire [31:0]	aluDataOut;
	wire 		zero;

//PCInAddress
	wire [31:0] PCInAddress;
	wire [31:0] wiredisplay;
	wire [31:0] meminput;
	
//////////////////// instantiation ////////////////////	
//PcUnit
	assign Reset=~rstn;
	assign PCInAddress = jump?{pcOut[31:28],opCode[25:0],2'd0}:extDataOut;
	assign pcSel =(Branch&&zero)==1?1:0;

    PcUnit U_pcUnit(.PC(pcOut),.PcReSet(Reset),.PcSel(pcSel),.Clk(clk_cpu),.Adress(PCInAddress),.jump(jump));
	
	assign imAdr = pcOut[7:2];

//ָIM
	IM U_IM(.spo(opCode),.a(imAdr));
	
	assign op = opCode[31:26];
	assign funct = opCode[5:0];
	assign shamt=opCode[10:6];

	assign gprReSel1 = opCode[25:21];
	assign gprReSel2 = opCode[20:16];
	assign gprWeSel = (RegDst==1)?opCode[20:16]:opCode[15:11];/////////////
	assign extDataIn = opCode[15:0];
	
//seg7*16		 
    assign disp_data = sw_i[7]?indexout:meminput;
    seg7x16 U_seg7x16(.clk(Clk), 
                    .reset(Reset),
                    .i_data(disp_data),
                    .o_seg(disp_seg_o), 
                    .o_sel(disp_an_o));

//LED
	assign led_o[0] = jump;
	assign led_o[1] = RegDst;
	assign led_o[2] = Branch;
	assign led_o[3] = MemR;
	assign led_o[4] = Mem2R;
	assign led_o[5] = MemW;
	assign led_o[6] = RegW;
	assign led_o[7] = Alusrc;
	assign led_o[9] = ExtOp[0];
	assign led_o[10] = ExtOp[1];
	assign led_o[11] = Aluctrl[0];
	assign led_o[12] = Aluctrl[1];
	assign led_o[13] = Aluctrl[2];
	assign led_o[14] = Aluctrl[3];
	assign led_o[15] = Aluctrl[4];   
                
//GPR
	GPR U_gpr(.DataOut1(gprDataOut1),.DataOut2(gprDataOut2),.clk(clk_cpu),.WData(gprDataIn)
			  ,.WE(RegW),.WeSel(gprWeSel),.ReSel1(gprReSel1),.ReSel2(gprReSel2));
//Ctrl
	Ctrl U_Ctrl(.jump(jump),.RegDst(RegDst),.Branch(Branch),.MemR(MemR),.Mem2R(Mem2R)
				,.MemW(MemW),.RegW(RegW),.Alusrc(Alusrc),.ExtOp(ExtOp),.Aluctrl(Aluctrl)
				,.OpCode(op),.funct(funct));
				
//Extender	
	Extender U_extend(.ExtOut(extDataOut),.DataIn(extDataIn),.ExtOp(ExtOp));
	
	assign aluDataIn2 = (Alusrc==1)?extDataOut:gprDataOut2;

//ALU
	Alu U_Alu(.AluResult(aluDataOut),.Zero(zero),.DataIn1(gprDataOut1),.DataIn2(aluDataIn2),.AluCtrl(Aluctrl),.shamt(shamt));
	assign gprDataIn = (Mem2R==1)?dmDataOut:aluDataOut;

//clk_div
	clk_div U_clkdiv(.clk(Clk),.rst(Reset),.SW15(sw_i[8]),.Clk_CPU(clk_cpu));	
	
	
//DMem
    assign meminput = (MemW==1) ? gprDataOut2:meminput;
	assign dmDataAdr = aluDataOut[4:0];
	DMem U_Dmem(.DataOut(dmDataOut),.DataAdr(dmDataAdr),.DataIn(gprDataOut2),.DMemW(MemW),.DMemR(MemR),.clk(clk_cpu),.index0(sw_i[0]),.index1(sw_i[1]),.index2(sw_i[2]),.indexout(indexout));

endmodule











