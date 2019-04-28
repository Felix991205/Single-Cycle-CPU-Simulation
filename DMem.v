
module DMem(DataOut,DataAdr,DataIn,DMemW,DMemR,clk,index2,index1,index0,indexout);
	input [4:0] DataAdr;
	input [31:0] DataIn;
	input 		 DMemR;
	input 		 DMemW;
	input 		 clk;

	output[31:0] DataOut;

	reg [31:0]  DMem[1023:0];

	//input index, then output coreresponding value (provide a shortcut to test sorting)
	input index0;
	input index1;
	input index2;	
	output[31:0] indexout;
	
	//initialize data stored in memory(to test sorting)
	initial								
	begin
		DMem[0]=32'h10001008;
		DMem[1]=32'h10001002;
		DMem[2]=32'h80001001;
		DMem[3]=32'h10001005;
		DMem[4]=32'h80001000;
		DMem[5]=32'hFFFF8000;
	end	
	
	
	always@(posedge clk)
	begin
		if(DMemW)
			 DMem[DataAdr] <= DataIn;
			 $display("addr=%8X",DataAdr);//addr to DM
       $display("din=%8X",DataIn);//data to DM
       $display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",DMem[0],DMem[1],DMem[2],DMem[3],DMem[4],DMem[5],DMem[6],DMem[7]);
	end

	assign DataOut = DMem[DataAdr];

	assign indexout=DMem[index0+2*index1+4*index2];

endmodule