//R type instructions
module R_type(
    input [2:0] funct3,
    input bit_th,
    input signed [31:0] in1,
    input signed [31:0] in2,
    output reg[31:0] out
);
    wire [31:0] tmp1;
    wire [31:0] tmp2;
    assign tmp1 = in1;
    assign tmp2 = in2;

    always @(*) 
    begin
    	case({bit_th,funct3})
        4'b0000:    out = in1+in2;          //add
        4'b1000:    out = in1-in2;          //sub
        4'b0001:    out = in1<<in2[4:0];	  //sll
        4'b0010:    out = in1<in2;          //slt
        4'b0011:    out = tmp1<tmp2;        //sltu
        4'b0100:    out = in1^in2;          //xor
        4'b0101:    out = in1>>in2[4:0];    //srl
        4'b1101:    out = in1>>>in2[4:0];   //sra
        4'b0110:    out = in1|in2;          //or
        4'b0111:    out = in1&in2;          //and
        endcase
    end
endmodule