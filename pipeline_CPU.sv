// All other modules are instantiated in pipeline_CPU. Updates and gives PC value to IMEM.
module pipeline_CPU(
    input clk,
    input reset,
    output reg [31:0] iaddr,  
    output [31:0] x31,
	 output [31:0] L_regdata_out,
	 output [31:0] EM_daddr_out,
	 output [31:0] MW_drdata_out
);


	//Declaration of wires used in instantiation.
	 wire [31:0] FD_idata_out;
    wire [31:0] FD_iaddr_out;
	 reg flag;
	 reg act;
	 wire [31:0] pc_new;
	 wire pc_replace;
	 wire pc_JALR;
	 reg [31:0] iaddr_upd;
    wire [4:0] DE_rs1_out;
    wire [4:0] DE_rs2_out;
    wire [4:0] DE_rd_out;
    wire DE_wer_out;
	 wire [4:0] rs1;
	 wire [4:0] rs2;
	 wire [4:0] rd;
	 wire [31:0] CU_imm_out;
	 wire [31:0] rv1;
	 wire [31:0] rv2;
    wire [31:0] DE_rv1_out;
    wire [31:0] DE_rv2_out;
    wire [31:0] DE_x31_out;
    wire [3:0] DE_we_out;
    wire signed [31:0] DE_imm_out;
    wire [31:0] DE_iaddr_out;
	 reg [31:0] AU_rv1_in;
	 reg [31:0] AU_rv2_in;
    wire [3:0] EM_we_out;
    wire EM_wer_out;
	 wire [6:0] EM_op_out;
    wire [4:0] EM_rd_out;
    wire [31:0] EM_regdata_out;
    wire [31:0] EM_dwdata_out;
    wire MW_wer_out;
    wire [4:0] MW_rd_out;
    wire [31:0] MW_regdata_out;
	 wire [31:0] MW_daddr_out;
	 wire [31:0] DMEM_drdata_out;
	 wire [4:0] WB_rd_out;
	 wire [31:0] WB_regdata_out;
	 wire WB_wer_out;
	 
	 //PC update - here, PC is called iaddr
    always@(posedge clk)
        begin
            if(reset)       
                iaddr = 0;
				else if(flag==0 || pc_replace==0)
					iaddr = iaddr+4-iaddr_upd;
            else if(pc_JALR==0)
                iaddr = iaddr+4-iaddr_upd+pc_new; //DEFINE PC.
				else
					 iaddr = pc_new;
        end
	 
	 wire [31:0] idata;
    wire CU_wer_out;
    wire [3:0] CU_we_out,AU_we_out;
    wire [2:0] DE_funct3_out,EM_funct3_out,MW_funct3_out;
    wire [6:0] DE_op_out,MW_op_out;
    wire [31:0] AU_regdata_out,AU_pc_out,AU_daddr_out,AU_dwdata_out;
	 
	 //Assigning values to rs1,rs2,rd
	 assign rs1 = FD_idata_out[19:15];
	 assign rs2 = FD_idata_out[24:20];
	 assign rd = FD_idata_out[11:7];
	 wire [4:0] rd_final;
	 assign rd_final = (iaddr<16)?0:MW_rd_out;

	 always@(*)
	 begin
		iaddr_upd=32'b0;
		flag=1;
		act=1;
		if(EM_rd_out == DE_rs1_out && EM_wer_out == 1 && iaddr>=12)
		begin
			if(EM_op_out == 7'b0000011)
			begin
				iaddr_upd = 4;
				flag=0;
				act=0;
			end
			else
				begin
				AU_rv1_in = EM_regdata_out;
				end
		end
		else if(MW_rd_out == DE_rs1_out && MW_wer_out == 1 && iaddr>=16)
			begin
			AU_rv1_in = L_regdata_out;
			end
		else if(WB_rd_out == DE_rs1_out && WB_wer_out == 1 && iaddr>=20)
			begin
			AU_rv1_in = WB_regdata_out;
			end
		else
			begin
			AU_rv1_in = DE_rv1_out;
			end
		if(EM_rd_out == DE_rs2_out && EM_wer_out == 1 && iaddr>=12 && (DE_op_out[6:4]==3'b110 || DE_op_out[6:4]==3'b011 || DE_op_out[6:4]==3'b010))
		begin
			if(EM_op_out == 7'b0000011)
			begin
				iaddr_upd = 4;
				flag=0;
				act=0;
			end
			else
			begin
			AU_rv2_in = EM_regdata_out;
			end
		end
		else if(MW_rd_out == DE_rs2_out && MW_wer_out == 1 && iaddr>=16 && (DE_op_out[6:4]==3'b110 || DE_op_out[6:4]==3'b011 || DE_op_out[6:4]==3'b010))
			begin
			AU_rv2_in = L_regdata_out;
			end
		else if(WB_rd_out == DE_rs2_out && WB_wer_out == 1 && iaddr>=20 && (DE_op_out[6:4]==3'b110 || DE_op_out[6:4]==3'b011 || DE_op_out[6:4]==3'b010))
			begin
			AU_rv2_in = WB_regdata_out;
			end
		else
			begin
			AU_rv2_in = DE_rv2_out;
			end
	 end

	//Instantiation of all modules used in the architecture. This allows output of 1 module to be used by another.
    imem im1(.iaddr(iaddr), .idata(idata));
    IF_ID_reg fd1(.clk(clk),.flag(flag),.pc_replace(pc_replace),.idata_in(idata), .iaddr_in(iaddr), .FD_idata_out(FD_idata_out), .FD_iaddr_out(FD_iaddr_out));
    Control_unit c1(FD_idata_out,CU_we_out,CU_imm_out,CU_wer_out);
    regfile rf1(clk,rs1,rs2,rd_final,L_regdata_out,MW_wer_out,rv1,rv2,x31);
    ID_EX_reg de1(clk,flag,pc_replace,FD_idata_out[30],rs1,rs2,rd,FD_idata_out[14:12],FD_idata_out[6:0],CU_wer_out,rv1,rv2,x31,CU_we_out,CU_imm_out,FD_iaddr_out,DE_bit_th_out,DE_rs1_out,DE_rs2_out,DE_rd_out,DE_funct3_out,DE_op_out,DE_wer_out,DE_rv1_out,DE_rv2_out,DE_x31_out,DE_we_out,DE_imm_out,DE_iaddr_out,DE_flag_out);

    ALU a1(DE_funct3_out,DE_op_out, DE_bit_th_out,AU_rv1_in,AU_rv2_in,DE_we_out,DE_imm_out,DE_iaddr_out,EM_pc_replace_out,EM_flag_out,AU_regdata_out,AU_pc_out,AU_daddr_out,AU_we_out,AU_dwdata_out,pc_new,pc_replace,pc_JALR);
    EX_MEM_reg em1(clk,act,DE_op_out,DE_funct3_out,AU_daddr_out,AU_we_out,DE_wer_out,DE_rd_out,AU_regdata_out,AU_dwdata_out,pc_replace,flag,EM_op_out,EM_funct3_out,EM_daddr_out,EM_we_out,EM_wer_out,EM_rd_out,EM_regdata_out,EM_dwdata_out,EM_pc_replace_out,EM_flag_out); 
    dmem dm1(clk,EM_daddr_out,EM_dwdata_out,EM_we_out,DMEM_drdata_out);
    MEM_WB_reg mw1(clk,EM_op_out,EM_funct3_out,EM_daddr_out,EM_wer_out,EM_rd_out,EM_regdata_out,DMEM_drdata_out,MW_op_out,MW_funct3_out,MW_daddr_out,MW_wer_out,MW_rd_out,MW_regdata_out,MW_drdata_out);
    write_to_reg l1(MW_op_out,MW_funct3_out,MW_daddr_out,MW_drdata_out,MW_regdata_out,L_regdata_out);
	 WB_reg wb1(clk,MW_rd_out,L_regdata_out,MW_wer_out,WB_rd_out,WB_regdata_out,WB_wer_out);
endmodule


module tb_pipeline_CPU;

    reg clk;
    reg reset;
    wire [31:0] iaddr;
    wire [31:0] x31;
    wire [31:0] L_regdata_out;
    wire [31:0] EM_daddr_out;
    wire [31:0] MW_drdata_out;

    // Instantiate the pipeline_CPU module
    pipeline_CPU uut(
        .clk(clk),
        .reset(reset),
        .iaddr(iaddr),
        .x31(x31),
        .L_regdata_out(L_regdata_out),
        .EM_daddr_out(EM_daddr_out),
        .MW_drdata_out(MW_drdata_out)
    );

    // Clock generation
    always begin
        #1 clk = ~clk; // Assuming a 10-time unit clock period
    end

    initial begin
		 clk = 0;
		 reset = 1;         // Initially set the reset signal to active (1)
		 #10;	 // Wait for 10 time units
		 clk = 0;
		 reset = 0;         // Deactivate the reset signal
		 #200;             // Let the simulation run for 1000 time units with the clock toggling
		 $finish;           // End the simulation
    end

endmodule
