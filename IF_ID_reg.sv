// IF/ID pipeline register
module IF_ID_reg(
    input clk,
	 input flag,
	 input pc_replace,
    input [31:0] idata_in, 
    input [31:0] iaddr_in, 
    output reg [31:0] FD_idata_out, 
    output reg [31:0] FD_iaddr_out
);
    always@(posedge clk)
    begin
		if(flag==1)
			begin
		  //If pc_replace=1 due to branch, then replace idata_out with ADDI R0,R0,0
        FD_idata_out = pc_replace?(32'b00000000000000000000000000010011):(idata_in);
        FD_iaddr_out = iaddr_in;
		  end
    end
endmodule    