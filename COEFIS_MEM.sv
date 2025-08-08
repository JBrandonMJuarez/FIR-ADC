module COEFIS_MEM
#(parameter ADDR_WIDTH=8, parameter coef_txt = "coefis0.txt")
(
	input									clk_in,
	input			[ADDR_WIDTH-1:0]	addr_in,
	output reg	[15:0]				coefis_out

);
	reg	signed [15:0] coefis_mem [0:2**ADDR_WIDTH-1] /* synthesis ramstyle = M9K */; 
	
	initial
	begin
		$readmemh("coefis0.txt", coefis_mem);
	end
	

	always @ (posedge clk_in)
	begin
		coefis_out <= coefis_mem[addr_in];
	end

endmodule