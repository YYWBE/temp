module top (CLOCK_50, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
	input CLOCK_50;
	input [9:0] SW;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	
	
	/*** Control Block ***/
	
	logic next_layer;
	
	assign next_layer = l1_done | l2_done | l3_done | l4_done | l5_done | l6_done;
	
	/*** Input ***/
	
	logic [27*27:0] in_reg [15:0]
	
	$readmemb(input_img, in_reg);
	
	/*** Generate Layers ***/ 
	
	logic [L1_OUT**2-1:0] layer1_out [8*DATA_WIDTH-1:0];
	convolve_layer #(parameter DATA_WIDTH=16, NUM_NODES=8, KERNAL_SIZE=3, DEPTH=1, WEIGHT_INIT="conv_weight_1.mif", BIAS_INIT="conv_bias_1.mif")
				layer1 ();
	
	logic [8*DATA_WIDTH-1:0] layer2_out;
	pool_layer #() layer2 ();
	
	logic [16*DATA_WIDTH-1:0] layer3_out;
	convolve_layer #(parameter DATA_WIDTH=16, NUM_NODES=16, KERNAL_SIZE=3, DEPTH=8, WEIGHT_INIT="conv_weight_1.mif", BIAS_INIT="conv_bias_1.mif")
				layer3 ();
	
	logic [16*DATA_WIDTH-1:0] layer4_out;
	pool_layer #() layer4 ();
	
	logic [16*DATA_WIDTH-1:0] layer3_out;
	convolve_layer #(parameter DATA_WIDTH=16, NUM_NODES=16, KERNAL_SIZE=1, DEPTH=400, WEIGHT_INIT="conv_weight_1.mif", BIAS_INIT="conv_bias_1.mif")
				layer5 ();
	
	logic [16*DATA_WIDTH-1:0] layer3_out;
	convolve_layer #(parameter DATA_WIDTH=16, NUM_NODES=16, KERNAL_SIZE=3, DEPTH=8, WEIGHT_INIT="conv_weight_1.mif", BIAS_INIT="conv_bias_1.mif")
				layer6 ();
	
	/*** State Machines ***/
	
	enum {IDLE, ACTIVE} ps, ns;
	
	l1_count
	
	input_width;
	kernal_width;
	stride;
	
	addr;
	k_count -> 0, 1, 2;
	shift_kern -> 0-8;
	kern_offset -> 0, 28, 56, etc;
	hw_count -> 
	
	always_ff @(posedge clk) begin
		if(layer_active[0]) begin
			
			addr <= addr + 1;
			if(k_count == 2) begin
				k_count <= 0;
				
				addr = addr + (28 - Kern_size);
				if(shift_kern == 9) begin
					kern_offset <= kern_offset + 1;
					addr = kern_offset;
					
				end
			end
			
		
		end else if(layer_active[1]) begin
			
		
		end else if(layer_active[2]) begin
			
		
		end else if(layer_active[3]) begin
			
		
		end else if(layer_active[4]) begin
			
		
		end else if(layer_active[5]) begin
			
		
		end else 
	
	
	end 
	
	
	/*** Output ***/
	


endmodule 