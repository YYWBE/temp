module conv_node #(parameter KERNAL_SIZE=3, DATA_WIDTH=16, DEPTH=8)(clk, reset, count, neuron_in, weights, bias, neuron_out);
	input clk, reset;
	input [(KERNAL_SIZE**2)-1:0] count;
	input [DEPTH*DATA_WIDTH-1:0] neuron_in;
	input [KERNAL_SIZE*KERNAL_SIZE*DATA_WIDTH-1:0] weights;
	input [DATA_WIDTH-1:0] bias;
	output [DATA_WIDTH-1:0] neuron_out;

	
	/*** Multiply Add ***/
	
	logic [DEPTH*DATA_WIDTH-1:0] lastSum;
	
	logic [DEPTH*DATA_WIDTH-1:0] multAddOut;
	
	genvar i;
	generate
		for(i = 0; i < DEPTH; i++) begin : eachMult
			mult_add eachMult (.in1(mult1[i*DATA_WIDTH+:DATA_WIDTH]), .mult2(weights[(i*count)*DATA_WIDTH+:DATA_WIDTH]), .add(lastSum[i*DATA_WIDTH+=DATA_WIDTH]),
									 .out(multAddOut[i*DATA_WIDTH+=DATA_WIDTH]));
		
		end
	
	endgenerate

	/*** Sum of Kernal ***/
	
	logic [DATA_WIDTH-1:0] sumOut;
	
	sum #(parameter NUM_SUM=DEPTH) kernal_total (.in(multAddOut), .out(sumOut));
	
	
	/*** Activation Function ***/
	
	assign ReLU_in = sumOut + bias;
	
	logic [DATA_WIDTH-1:0] ReLU_out;
	
	ReLU activate (.clk(clk), .din(ReLU_in), .dout(ReLU_out);
	
	
	/*** Clocked Behavior ***/
	
	always_ff @(posedge clk) begin
		if(count == (KERNAL_SIZE**2)) begin // happens on kernal shift
			last_sum <= DEPTH*DATA_WIDTH'd0;
			
			neuron_out <= ReLU_out;
		end else begin // every other cycle
			last_sum <= last_sum + total;
			
			
		end
	end


endmodule 