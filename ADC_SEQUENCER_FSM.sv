module ADC_SEQUENCER_FSM(
	input							clk_in,
	input							rst_in,
	input				[5:0]		ctrl_in,
	output	reg	[5:0]		ctrl_out,
	output			[2:0]		state_out
);
	parameter idle = 0, start = 1, cap_sampl = 2, wait_cap = 3, wait_eoc = 4, gen_int = 5, finish = 6;
	reg	[2:0] state = idle;
	reg	[2:0] nxt_state = idle;
	assign state_out = state;
	//reg	[5:0]	ctrl_reg_in = 6'b000000;
	//reg	[5:0]	ctrl_reg_out = 6'b000000;
	

	always_ff @(posedge clk_in, negedge rst_in)
	begin
		if(!rst_in)
		begin
			state <= idle;
		end
		else
		begin
			state <= nxt_state;
		end
	end
	
	always_comb
	begin
		nxt_state <= idle;
		case(state)
				idle:
				begin
					case(ctrl_in)
					//	6'b000000,				// FULL_W, EOC_W, SAMP_TRIG, FREE = 0, START = 1, EN = 1 
						6'b000011,				// FULL_W, EOC_W, SAMP_TRIG, FREE = 0, START = 1, EN = 1 
						6'b000111:				// FULL_W, EOC_W, SAMP_TRIG, FREE = 1, START = 1, EN = 1 
							nxt_state <= start;
						default:
							nxt_state <= idle;
					endcase
				end
				start:
				begin
					case(ctrl_in)
						6'b000011,
						6'b000111:
							nxt_state <= cap_sampl;
						default:
							nxt_state <= start;
					endcase
				end
				cap_sampl:
				begin
					case(ctrl_in)
						6'b000011,
						6'b000111:
							nxt_state <= wait_cap;
						default:
							nxt_state <= cap_sampl;
					endcase
				end
				wait_cap:
				begin
					case(ctrl_in)
						6'b000011,
						6'b000111:
							nxt_state <= wait_eoc;
						default:
							nxt_state <= wait_cap;
					endcase
				end
				wait_eoc:
				begin
					case(ctrl_in)
						6'b010011,
						6'b010111:
							nxt_state <= gen_int;
						default:
							nxt_state <= wait_eoc;
					endcase
				end
				gen_int: // TODO: Cambiar nombre de estado
				begin
					case(ctrl_in)
						//6'b000011,
						6'b001111:
							nxt_state <= finish;
						default:
							nxt_state <= gen_int;
					endcase
				end
				finish:
				begin
					case(ctrl_in)
						6'b001111:
							nxt_state <= cap_sampl;
						default:
							nxt_state <= finish;
					endcase
				end
				default:
					nxt_state <= idle;
			endcase
	end
	
	
	always_comb
	begin
		case(state)	// int_out, -, soc, conv_en, -, -
			idle:
				ctrl_out = 6'b000000;
			start:
				ctrl_out = 6'b010011;
			cap_sampl:
				ctrl_out = 6'b000101;
			wait_cap:
				ctrl_out = 6'b001101;
			wait_eoc:
				ctrl_out = 6'b010111;
			gen_int:
				ctrl_out = 6'b000101;
			finish:
				ctrl_out = 6'b110111;
			default:
				ctrl_out = 6'b000000;
		endcase
	end


endmodule