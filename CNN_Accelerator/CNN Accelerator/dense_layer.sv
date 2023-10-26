module dense_layer #(parameter DATA_WIDTH=16, NUM_NODES=16, WIDTH=16, WEIGHT_INIT="conv_weight_1.mif", BIAS_INIT="conv_bias_1.mif")
							  (clk, reset, data_in, restart, data_out, layer_active);
	input clk, reset, layer_active;
	input [DATA_WIDTH-1:0] data_in;
	output [NUM_NODES*DATA_WIDTH-1:0] data_out;
	
	/*** Load Weights ***/
	
	logic [NUM_NODES-1:0] weight_reg [WIDTH*DATA_WIDTH-1:0];
	
	$readmemb(WEIGHT_INIT, weight_reg);
		
	/*** Load Biases ***/
		
	reg [NUM_NODES-1:0] bias_reg [DATA_WIDTH-1:0];
	
	$readmemb(BIAS_INIT, bias_reg);
	
	
	/*** Generate Nodes ***/
	
	genvar i;
	
	generate
		for(i = 0; i < NUM_NODES; i++) begin : eachnode
			conv_node eachnode (.clk(clk), .reset(reset), .count(count), .neuron_in(data_in[DATA_WIDTH+:DATA_WIDTH]),
										.weights(weight_reg[i][DEPTH*DATA_WIDTH-1:0]), .bias(bias_reg[i][DATA_WIDTH-1:0]), 
										.neuron_out(neuron_data[i*DATA_WIDTH+:DATA_WIDTH]));
		
		end
	
	endgenerate
	
	/*** Shift Values ***/
	
	logic [2*KERNAL_SIZE-1:0] counter;
	
	logic shift_kernal;
	
	always_ff @(posedge clk) begin
		if(reset) begin
		
		
		end else if(counter == (KERNAL_SIZE**2)) begin
			counter <= (2*KERNAL_SIZE){1'b0};
			shift_kernal <= 1'b1;
			
		else else begin
			counter <= counter + 1;
			shift_kernal <= 1'b0;
		
		end
	
	end
	
	
	
endmodule 