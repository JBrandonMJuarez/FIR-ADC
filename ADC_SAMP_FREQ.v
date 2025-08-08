module ADC_SAMP_FREQ(
	input						clk_in,
	input						rst_in,
	input						clk_div_in,
	input				[5:0]	time_mult_in,
	input						en_in,
	output					samp_trig_out
);
	reg	[5:0] time_count = 6'b000000;
	wire			samp_trig_w;
	always @(posedge clk_div_in, negedge rst_in)
	begin
		if(!rst_in)
		begin
			time_count <= 6'b000000;
		end
		else
		if (en_in & clk_in)
		begin
			begin
				if(time_count == 6'b0)
				begin
					time_count <= 6'b111111 - time_mult_in ;
				end
				else
				begin
					time_count <= time_count + 1'b1;
				end
			end
		end
	end

	
	assign samp_trig_w = (time_count == 6'b0) ? 1'b1 : 1'b0;
	assign samp_trig_out = en_in & samp_trig_w;


endmodule