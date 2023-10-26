module weight_mem #(parameter WEIGHT_COUNT=3, ADDR_WIDTH=10, DATA_WIDTH=16, INIT_FILE="weight_init.mif")(clk, reset, rd_en, rd_addr, weight);
	input clk, reset, rd_en;
	input [ADDR_WIDTH-1:0] rd_addr;
	output reg [DATA_WIDTH:0] weight;
	
	reg [DATA_WIDTH-1:0] weight_reg [WEIGHT_COUNT-1:0];
	
	$readmemb(INIT_FILE, weight_reg);
	
	always_ff @(posedge clk) begin
		if(rd_en)
			weight <= weight_reg[rd_addr];
	end
	

endmodule 