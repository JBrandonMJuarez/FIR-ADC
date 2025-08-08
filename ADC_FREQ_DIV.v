module ADC_FREQ_DIV(
	input           	clk_in,     // reloj entrante de 50MHz
	input					rst_in,
   output 	 [7:0]	div_out      // nuevo reloj de 5MHz
);

	reg [6:0] count = 7'b0000000;

	always@(posedge clk_in, negedge rst_in)
	begin
		if(!rst_in)
			count <= 7'b0000000;
		else
			count <= count + 1'b1;
	end
	assign div_out = {count,clk_in};
endmodule