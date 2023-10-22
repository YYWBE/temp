//Module for immediate instructions
module I_type(
    input [2:0] funct3,
    input bit_th,
    input signed [31:0] in1,
    input signed [31:0] imm,
    output reg [31:0] out
);
    wire [31:0] tmp1;
    wire [11:0] tmp2;
    assign tmp1 = in1;
    assign tmp2 = imm;
    always @(*) 
    begin
    	case(funct3)
        3'b000: out = in1+imm;          //addi
        3'b010: out = in1<imm;          //slti
        3'b011: out= tmp1<tmp2;         //sltiu
        3'b100: out = in1 ^ imm;        //xori
        3'b110: out = in1 | imm;        //ori
        3'b111: out = in1 & imm;        //andi
        3'b001: out = in1<<imm[4:0];    //slli
        3'b101:
        begin
            if(bit_th)           //srli
               out = in1>>imm[4:0]; 
            else                    //srai
               out = in1>>>imm[4:0];
        end
        endcase
    end
endmodule