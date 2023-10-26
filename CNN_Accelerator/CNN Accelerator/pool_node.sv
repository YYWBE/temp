module pool_node #(parameter KERNAL_SIZE=2, DEPTH=8, DATA_WIDTH=16)(clk, reset, count, neuron_in, neuron_out);
	input clk, reset;
	input [(KERNAL_SIZE**2)-1:0] count;
	input [DEPTH*DATA_WIDTH-1:0] neuron_in;
	output [DEPTH*DATA_WIDTH-1:0] neuron_out;
	

	/*** Calculate Max ***/
	
	logic [DEPTH*DATA_WIDTH-1:0] prevMax, maxOut;
	
	genvar i;
	generate
		for(i = 0; i < DEPTH; i++) begin : eachMax
			max eachMax (.in1(neuron_in[i*DATA_WIDTH+:DATA_WIDTH]), .in2(prevMax[i*DATA_WIDTH+:DATA_WIDTH]), .out(maxOut[i*DATA_WIDTH+:DATA_WIDTH]));
		
		end
	
	endgenerate
	
	
	
	/*** Clocked Behavior ***/
	
	always_ff @(posedge clk) begin
		if(count == (KERNAL_SIZE**2)) begin // happens on kernal shift
			prevMax <= DEPTH*DATA_WIDTH'd0;
			
			neuron_out <= maxOut;
		end else begin // every other cycle
			
			
		end
	end


endmodule 