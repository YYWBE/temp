module ReLU #(parameter LENGTH = 16)(clk, din, dout);
	input clk;
	input [LENGTH-1:0] din;
	output [LENGTH-1:0] dout;
	
	always_ff @(posedge clk) begin
		dout = din[LENGTH-1] ? din : 0;
	
	end

endmodule 