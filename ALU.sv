//ALU performs needed computations for different instruction types and returns value to the CPU which is used
//to update the PC or write to RF or write to DMEM.
module ALU (
    input [2:0] funct3,
    input [6:0] op,
    input bit_th,
    input [31:0] rv1,
    input [31:0] rv2,
    input [3:0] we, 
    input signed [31:0] imm,
    input [31:0] iaddr,
	 input pc_replace_old,
	 input flag_old,
    output reg [31:0] regdata,
    output reg [31:0] pc,
    output reg[31:0] daddr,
    output reg [3:0] we_final,
    output reg [31:0] dwdata,
	 output reg[31:0] pc_new,
	 output reg pc_replace,
	 output reg pc_JALR
);
	 wire [31:0] regdata_R, regdata_I;
	 wire [31:0] regdata_L, iaddr_val;
	 wire jump_flag;
	 initial begin
		pc_new=0;
		pc_replace=0;
		pc_JALR=0;
	 end
	 
    always@(*) 
    begin
		  pc_new=0;
		  pc_replace=0;
		  pc_JALR=0;
        case(op)
            7'b0110011:      //R type instructions
            begin
                regdata = regdata_R;
                we_final = we;
            end
            7'b0010011:     //I type instructions
            begin
                regdata = regdata_I;
                we_final = we;
            end
            7'b0000011:     //L type instructions
            begin
                daddr = rv1+imm;    
                we_final = we;
            end
            7'b0100011:     //S type instructions
            begin
                daddr = rv1+imm;
					case(funct3)
				 	3'b000: dwdata = {rv2[7:0],rv2[7:0],rv2[7:0],rv2[7:0]};
				 	3'b001: dwdata = {rv2[15:0],rv2[15:0]};
				 	3'b010: dwdata = rv2;
				 	endcase
                we_final = we<<daddr[1:0];
            end
				7'b1100011:		//B type instructions
				begin
			        pc_new = iaddr_val;
                 we_final = we;
					  pc_replace=(pc_replace_old|!flag_old)?0:jump_flag;
				end
				7'b1100111:		//JALR instruction
				begin
					regdata = iaddr+4;
					pc_new = (rv1+imm)&32'hfffffffe;
               we_final = we;
					pc_replace=(pc_replace_old|!flag_old)?0:1;
					pc_JALR=1;
				end
				7'b1101111:		//JAL instruction
				begin
					regdata = iaddr+4;
               pc_new = imm-12;
               we_final = we;
					pc_replace=(pc_replace_old|!flag_old)?0:1;
				end
				7'b0010111:		//AUIPC
				begin
					regdata = iaddr+imm;
               we_final = we;
				end
				7'b0110111:		//LUI
				begin
					regdata = imm;
               we_final = we;
				end
			endcase
    end

    //Instantiating modules from the computational block
    R_type r1(funct3,bit_th,rv1,rv2,regdata_R);   
    I_type i1(funct3,bit_th,rv1,imm,regdata_I);
	 B_type b1(funct3, iaddr, imm, rv1, rv2, iaddr_val,jump_flag);
	
endmodule