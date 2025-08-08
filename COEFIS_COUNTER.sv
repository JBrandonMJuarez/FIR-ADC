module COEFIS_COUNTER
#(parameter ADDR_WIDTH=8, N= 50)
(
	input							clk_in,
	input							rst_in,
	input							start_in,
	output						finish_out,
	output [ADDR_WIDTH-1:0]	count_out
);

	reg	[ADDR_WIDTH-1:0] count_reg;
	reg	[ADDR_WIDTH-1:0] cnt_reg;
	wire	stop_w;
	
	always @(posedge clk_in, negedge rst_in)
	begin
		if (!rst_in)
		begin
			count_reg <= {ADDR_WIDTH{1'b0}};
		end
		else
		begin
			if(count_reg < (N))
			begin
				count_reg <= count_reg + 1'b1;
			end
			else
			begin
				if(start_in)
				begin
					count_reg <= {ADDR_WIDTH{1'b0}};
				end
			end
		end
	end
	
	
	//assign stop_w = ({ADDR_WIDTH{1'b1}}) ? 1'b0 : 1'b1;
	assign count_out = count_reg;
	assign finish_out = (count_reg == N) ? 1'b1 : 1'b0;


endmodule