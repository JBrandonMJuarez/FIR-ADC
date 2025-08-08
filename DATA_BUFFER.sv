module DATA_BUFFER
#(parameter ADDR = 8, parameter N = 256)
(
	input						clk_in,
	input						rst_in,
	input						wr_in,
	input						rd_in,
	input		[ADDR-1:0]	addr_in,
	input		[11:0]		x_in,
	output	reg [11:0]		x_out
);

	reg	[11:0] x_n	[0 : N-1];
	reg	[11:0] x_w;
	
	integer i;
	
	
	always @(posedge wr_in, negedge rst_in)
	begin
		if (!rst_in)
			for (i = 0; i<N; i = i+1)
			begin
				x_n[i] <= 0;
			end
		else
		begin
			x_n[0] <= x_in;
			for (i = 1; i<N; i = i+1)
			begin
				x_n[i] <= x_n[i-1];
			end
		end
	end
	
	always @(*)
	begin
		x_w <= x_n[addr_in];
	end
	
	always @(posedge clk_in)
	begin
		x_out <= x_w;
	end

	//assign x_out = x_w;
	
endmodule