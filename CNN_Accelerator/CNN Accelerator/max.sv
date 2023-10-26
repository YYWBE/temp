module max #(parameter DATA_WIDTH=16)(in1, in2, out);
	input [DATA_WIDTH-1:0] in1, in2;
	output [DATA_WIDTH-1:0] out;
	
	assign out = (in1 > in2) ? in1 : in2;

endmodule 