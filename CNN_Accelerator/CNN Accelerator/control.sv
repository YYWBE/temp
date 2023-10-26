module control #(parameter NUM_LAYERS=6)(clk, reset, start, next_layer, layer_active, input_width, kernal_width, stride, );
	input clk, reset, start;
	input next_layer;
	output ready, done;
	output [NUM_LAYERS-1:0] layer_active;
	output [4:0] input_width;
	output [1:0] kernal_width;
	output [1:0] stride;

	
	enum {Ready, L1, L2, L3, L4, L5, L6, Done} ps, ns;

	always_ff @(posedge clk) begin
		if(reset) begin
			
		end else if(ready && start) begin
			
			
		end else begin
		
			/*** Controls layer_active ***/
			if(next_layer) begin
				if(layer_active == NUM_LAYERS'd0) // first layer
					layer_active <= NUM_LAYERS'd1;

				else if(layer_active == 2**NUM_LAYERS) // last layer
					done <= 1'b1;
					
				else
					layer_active <= layer_active << 1'b1;
			end
			
			/*** Sets input_width, kernal_width, stride ***/
			case (ps)
				L1 : begin
						input_width <= 5'b11100;
						kernal_width <= 2'b11;
						stride <= 2'b01;
						ns <= L2;
					end
				L2 : begin
						input_width <= 5'b11010;
						kernal_width <= 2'b10;
						stride <= 2'b10;
						ns <= L3;
					end
				L3 : begin
						input_width <= 5'b01101;
						kernal_width <= 2'b11;
						stride <= 2'b01;
						ns <= L4;
					end
				L4 : begin
						input_width <= 5'b01011;
						kernal_width <= 2'b10;
						stride <= 2'b10;
						ns <= L5;
					end
				
				L5 : begin
						input_width <= 5'b00101;
						kernal_width <= 2'b01;
						stride <= 2'b01;
						ns <= L6;
					end
				L6 : begin
						input_width <= ;
						kernal_width <= 2'b01;
						stride <= 2'b101;
						ns <= Done;
					end
			endcase
			
			
		
		end
	
	end
endmodule 