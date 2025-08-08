module ADC_SEQUENCER(
	input           		clk_in,
	input						rst_in,
	input						eoc_in,
	input						full_in,
	input			[2:0]		ADC_ctrl0_in,
	input			[8:0]		ADC_sampl_time_in,
   output 					soc_out,
	output					int_out,
	output					samp_trig_out,
	output		[3:0]		seq_out,
	output		[2:0]		state_out
);
	wire	[7:0]	div_w;
	wire			clk_div_w;
	wire			samp_trig_w;
	
	wire			clk10_1;
	
	wire	[5:0]	FSM_ctrl;
	wire			ADC_en;
	wire			ADC_start;
	wire			free_run;
	wire			eoc_w;
	wire			full_w;
	
	wire	[5:0]	SEQ_ctrl;
	
	assign {{free_run},{ADC_start},{ADC_en}} = {ADC_ctrl0_in[2:0]};
	assign eoc_w = eoc_in;
	assign full_w = full_in;
	assign FSM_ctrl = {{full_w},{eoc_w},{samp_trig_w},{free_run},{ADC_start},{ADC_en}};
	assign samp_trig_out = samp_trig_w;
	
	DIV10_1 u0(
		.rst_in		(rst_in),
		.clk_in		(clk_in),
		.clk_out		(clk10_1)
	);
	
	
	ADC_FREQ_DIV U1(
		.clk_in		(clk10_1),
		.rst_in		(rst_in),
		.div_out		(div_w)
	);
	
	ADC_FREQ_MUX U2(
		.sel_in			(ADC_sampl_time_in[2:0]),
		.clk_div_in		(div_w),
		.clk_div_out	(clk_div_w)
	);
	
	ADC_SAMP_FREQ U3(
		.clk_in			(clk10_1),
		.rst_in			(rst_in),
		.clk_div_in		(clk_div_w),
		.time_mult_in	(ADC_sampl_time_in[8:3]),
		.en_in			(seq_out[2]),
		.samp_trig_out	(samp_trig_w)
	);
	
	ADC_SEQUENCER_FSM U4(
		.clk_in			(clk_in),
	   .rst_in			(rst_in),
	   .ctrl_in			(FSM_ctrl),
	   .ctrl_out		(SEQ_ctrl),
		.state_out		(state_out)
	);
	assign soc_out = {SEQ_ctrl[3]};
	assign int_out = {SEQ_ctrl[5]};
	assign seq_out = {{SEQ_ctrl[4]},{SEQ_ctrl[2:0]}}; 

endmodule