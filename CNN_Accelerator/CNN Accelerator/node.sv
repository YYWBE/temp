module conv_node #(parameter F = 3, DATA_WIDTH=16)();
	input [31:0] weight, bias;
	input neuron_in;

	/*** Load Weights & Bias ***/
	
	initial begin
            $readmemb(biasFile,biasReg);
   end
	
	weight_mem weights (.clk(clk), .reset(reset), .rd_en(), .rd_addr(addr), .weight(weight));
        
	always @(posedge clk) begin
		if(reset) begin
			r_addr <= 0;
		
		end else begin
			bias <= {biasReg[addr][dataWidth-1:0],{dataWidth{1'b0}}};
				
			r_addr <= r_addr+1;
		
		end
            
   end
	
	/*** Multiply ***/
	
	
	always_comb begin
	
		mult = neuron_in * weight;
	end
	
	
	/*** Sum ***/
	
	
	
	
	
	/*** Add Bias ***/
	
	
	
	ReLU_in = sum + bias
	
	/*** Activation Function ***/
	
	ReLU activate (.clk(clk), .din(ReLU_in), .dout(neuron_out);


endmodule 