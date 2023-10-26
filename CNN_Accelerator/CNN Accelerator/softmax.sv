`define e 2.71828

module softmax #(parameter DATA_WIDTH=16, NUM_OUTPUTS=10)(clk, in, total, out);
	input clk;
	input [DATA_WIDTH-1:0] in;
	input [NUM_OUTPUTS-1:0] total [DATA_WIDTH-1:0];
	output [DATA_WIDTH-1:0] out;
	
	logic [DATA_WIDTH-1:0] probScore, sum;
	
	integer i;
	
	always_comb begin
		sum = 0;
		
		for(i = 0; i < NUM_OUTPUTS; i++) begin
			sum = sum + (e ** total[i][DATA_WIDTH-1:0]);
		end
		
		probScore = (e ** in) / sum;
		
	end
	
	always_ff @(posedge clk) begin
		out = probScore;
	
	end


endmodule 