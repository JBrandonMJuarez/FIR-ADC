module ADC_FREQ_MUX(
	input		[2:0]		sel_in,
	input		[7:0]		clk_div_in,
   output 	reg		clk_div_out      // nuevo reloj de 5MHz
);



	always@(*)
	begin
		case(sel_in)
			3'b000:
				clk_div_out = clk_div_in[0];
			3'b001:
				clk_div_out = clk_div_in[1];
			3'b010:
				clk_div_out = clk_div_in[2];
			3'b011:
				clk_div_out = clk_div_in[3];
			3'b100:
				clk_div_out = clk_div_in[4];
			3'b101:
				clk_div_out = clk_div_in[5];
			3'b110:
				clk_div_out = clk_div_in[6];
			3'b111:
				clk_div_out = clk_div_in[7];
		endcase
	end
endmodule