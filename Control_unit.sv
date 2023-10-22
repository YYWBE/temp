//Control Unit assigns the write enable signals and imm value
module Control_unit (
	 input [31:0] idata,  //Stores current Program counter value
    output reg [3:0] we,
    output reg signed [31:0] imm,
    output reg wer
);

    always@(*)     
    begin
            case(idata[6:0])
                7'b0110011:      //R type instructions
                begin
                    wer = 1;
                    we = 4'b0;
                end
                7'b0010011:     //I type instructions
                begin
                    imm = {{20{idata[31]}},idata[31:20]};
                    wer=1;
                    we=4'b0;
                end
                7'b0000011:     //L type instructions
                begin
                
                    imm = {{20{idata[31]}},idata[31:20]};
                    wer=1;
                    we=4'b0;
                end
                7'b0100011:     //S type instructions
                begin
                    imm = {{20{idata[31]}},idata[31:25],idata[11:7]};
                    wer=0;
                    case(idata[14:12])
                        3'b000: we = 4'b0001;
                        3'b001: we = 4'b0011;
                        3'b010: we = 4'b1111;   //Note that this is not the final we value. Only an intermediate
                    endcase
                end
				7'b1100011:		//B type instructions
				begin
				    imm = {{20{idata[31]}},idata[31],idata[7],idata[30:25],idata[11:8],1'b0};
					wer=0;
					we=4'b0;
				end
				7'b1100111:		//JALR instruction
				begin
				    imm = {{20{idata[31]}},idata[31:20]};
					wer = 1;
					we = 4'b0;				
				end
				7'b1101111:		//JAL instruction
				begin
					imm = {{11{idata[31]}},idata[31],idata[19:12],idata[20],idata[30:21],1'b0};
					wer = 1;
					we = 4'b0;
				end
				7'b0010111:		//AUIPC
				begin
					imm = {idata[31:12],12'b0};
					wer = 1;
					we = 4'b0;
				end
				7'b0110111:		//LUI
				begin
					imm = {idata[31:12],12'b0};
					wer=1;
					we=4'b0;
				end
			endcase
    end
endmodule