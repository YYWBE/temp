module sum #(parameter NUM_SUM=8, DATA_WIDTH=16)(in, out);
	input [NUM_SUM*DATA_WIDTH-1:0] in;
	output [DATA_WIDTH-1:0] out;
	
	logic [DATA_WIDTH-1:0] total;
	
	integer i;
	
	always_comb begin
		total = DATA_WIDTH'd0;
		
		for(i=0; i < NUM_SUM; i++) begin
			if((total + in[i*DATA_WIDTH+:DATA_WIDTH]) == DATA_WIDTH{1'b1})
				total = DATA_WIDTH{1'b1};
			else
				total = total + in[i*DATA_WIDTH+:DATA_WIDTH];
			
		end
	end
	
	assign out = total;
	
endmodule 