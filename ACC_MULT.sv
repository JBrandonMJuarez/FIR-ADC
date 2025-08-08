module ACC_MULT(
	input						clk_in,
	input						rst_in,
	input						clr_in,
	input						finish_in,
	input			[11:0]	x_in,
	input			[15:0]	h_in,
	output reg	[11:0]	y_out
);
	reg	signed [41:0]	acum_reg = 42'b0;
	wire	signed [24:0]	x_w;
	
	assign x_w = {{20{1'b0}},{x_in}};
	
	always @(posedge clk_in, negedge rst_in)
	begin
		if(!rst_in)
		begin
			acum_reg <= 42'b0;
		end
		else
		begin
			if(!clr_in)
			begin
				if (finish_in)
				begin
					acum_reg <= 42'b0;
				end
				else
				begin
					acum_reg <= acum_reg + (x_w * $signed(h_in));
				end
			end
			
		end
	end
	
	always @(posedge finish_in)
	begin
		y_out = (acum_reg / 16'b1000000000000000) + 12'b011111111111;
	end


endmodule
