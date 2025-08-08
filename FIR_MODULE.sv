module FIR_MODULE
#(parameter ADDR_WIDTH=8, parameter coef_bank = "coefis0.txt", parameter N = 251)
(
	input						clk_in,
	input						rst_in,
	input						start_in,
	input						wr_in,
	input 		[11:0]	x_in,
	output 		[11:0]	y_out
);

	reg	[11:0] coefis_h;
	wire	[ADDR_WIDTH-1:0] coef_addr;
	reg	[11:0]	x_reg;
	reg	[23:0]	y_reg;
	wire	[11:0]	x_w;
	wire	signed [15:0]	h_w;
	wire				finish_w;
	
	
	
	COEFIS_COUNTER #(
		.ADDR_WIDTH		(ADDR_WIDTH), 
		.N					(N))
	U0(
		.clk_in			(clk_in),
		.rst_in			(rst_in),
		.start_in		(start_in),
		.finish_out		(finish_w),
		.count_out		(coef_addr)
	);
	
	COEFIS_MEM #(
		.ADDR_WIDTH		(ADDR_WIDTH),
		.coef_txt		("coefis0.txt")
	)
	U1(
		.clk_in			(clk_in),
		.addr_in			(coef_addr),
		.coefis_out		(h_w)
	);
	
	DATA_BUFFER #(
		.ADDR 			(ADDR_WIDTH), 
		.N 				(N))
	U2(
		.clk_in			(clk_in),
		.rst_in			(rst_in),
		.wr_in			(wr_in),
		//.rd_in			(rd_in),
		.addr_in			(coef_addr),
		.x_in				(x_in),
		.x_out			(x_w)
	);
	
	ACC_MULT U3(
		.clk_in			(clk_in),
		.rst_in			(rst_in),
		.clr_in			(finish_w),
		.finish_in		(wr_in),
		.x_in				(x_w),
		.h_in				(h_w),
		.y_out			(y_out)
	);

endmodule