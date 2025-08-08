module DIV10_1(
	input			rst_in,
	input			clk_in,
	output reg	clk_out
);

	reg [3:0] div_reg = 4'b0000;
	always @(posedge clk_in, negedge rst_in)
	begin
		if (!rst_in)
		begin
			div_reg <= 4'b000;
			clk_out <= 1'b0;
		end
		else
		begin
			if(div_reg == 4'b100)   
			begin
				div_reg <= 4'b0;
            clk_out <= ~clk_out;
         end
			else
			begin
				div_reg <= div_reg + 1'b1;
         end  
		end
	end

endmodule