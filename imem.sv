//IMEM module
module imem(
    input [31:0] iaddr,
    output [31:0] idata
);
    reg [31:0] i_arr[0:31];
    initial begin
		//$readmemh("imem2_ini.mem",i_arr);
		i_arr[0] = 32'h00000513;  
		i_arr[1] = 32'h00100593;  
		i_arr[2] = 32'h00200613;  
		i_arr[3] = 32'h00300693;  
		i_arr[4] = 32'h00400713;  
		i_arr[5] = 32'hFFB00793;  
		i_arr[6] = 32'hFFA00813;  
		i_arr[7] = 32'h00700893;  
		i_arr[8] = 32'h02F6F463;  
		i_arr[9] = 32'hB5800093;  
		i_arr[10] = 32'h02D7F063;  
		i_arr[11] = 32'h24000513;  
		i_arr[12] = 32'h24000593;  
		i_arr[13] = 32'h24000613;  
		i_arr[14] = 32'h24000693;  
		i_arr[15] = 32'h24000713;  
		i_arr[16] = 32'h24000793;  
		i_arr[17] = 32'h24000813;  
		i_arr[18] = 32'h24000893;  
		i_arr[19] = 32'hFFF00893;  
	end
    assign idata = i_arr[iaddr[31:2]];
endmodule