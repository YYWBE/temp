module mult_add #(parameter DATA_WIDTH=16)(clk, reset, mult1, mult2, add, out);
	input [2*DATA_WIDTH-1:0] mult1, mult2, add;
	output [DATA_WIDTH-1:0] out;
	
	wire [2*DATA_WIDTH-1:0] temp;
	
	always_comb begin
		temp = (mult1 * mult2) + add;
	end
	
	always_ff @(posedge clk) begin
		if(temp > DATA_WIDTH{1'b1})
			out <= DATA_WIDTH{1'b1};
		else
			out <= temp[DATA_WIDTH-1:0];
		
	end

endmodule 