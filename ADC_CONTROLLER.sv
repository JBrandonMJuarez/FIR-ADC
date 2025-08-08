module ADC_CONTROLLER (
	input						clk_in,
	input						sel_in,
	input						rst_ADC_in,
	input						rst_FIR_in,
	output					INT_out,
	output	[11:0]		y_out
	
);
	//assign	test_signals = {clk_PLL_ADC,soc_wire,eoc_wire,ADC_int,{seq_w}};
	assign INT_out = sampl_w;
	wire [2:0] state_wire;
	wire			sampl_w;
//	assign	test_signals = {clk_PLL_ADC,soc_wire,eoc_wire,ADC_int,{state_wire},{1'b0}};
//	
//	assign	int_out = ADC_int;
//	assign	soc_out = soc_wire;
//	assign	seq_out = seq_w;
	

	wire	[11:0]	ADC_data;
	wire	[11:0]	ADC_w;
	wire				soc_wire;
	wire				eoc_wire;
	wire				ADC_en;
	wire				clk_ADC;
	wire				full_w;
	wire				reg_sel;
	wire				adj_sel;
	wire				clk_PLL_ADC;
	wire				clk_PLL_SEQ;
	wire	[3:0]		seq_w;
	wire				sampl_count_w;
	wire				ADC_int;
	wire	[11:0]	y_w;
	
	 
	 ADC_BLOCK ADC_INSTANCE(
		.clk_in					(clk_in),
		.rst_in					(rst_ADC_in),
		.chsel					(4'b0100),               // 5-bits channel selection.
		.soc						(soc_wire),                 // signal Start-of-Conversion to ADC
		.eoc						(eoc_wire),                 // signal end of conversion. Data can be latched on the positive edge of clk_dft after this signal becomes high.  EOC becomes low at every positive edge of the clk_dft signal.
		.dout						(ADC_data),                // 12-bits DOUT valid after EOC rise, still valid at falling edge, but not before the next EOC rising edge
		.usr_pwd					(1'b0),             // User Power Down during run time.  0 = Power Up;  1 = Power Down.
		.tsen						(1'b0),                // 0 = Normal Mode; 1 = Temperature Sensing Mode.
		.pll_clk_out0			(clk_PLL_ADC),
		.pll_clk_out1			(clk_PLL_SEQ),
		.clkout_adccore		(clk_ADC)      // Output clock from the clock divider
	 );
	
	ADC_SEQUENCER ADC_SEQ(
		.clk_in					(clk_PLL_ADC),
		.rst_in					(rst_ADC_in),
		.eoc_in					(eoc_wire),
		.full_in					(1'b0),
		.ADC_ctrl0_in			(3'b111),
		.ADC_sampl_time_in	(9'b0000000110),
		.soc_out					(soc_wire),
		.int_out					(ADC_int),
		.samp_trig_out			(sampl_w),
		.seq_out					(seq_w),
		.state_out				(state_wire)
	);
	
	
//	FIR_V	FIR_BLOCK(
//		.clk_in					(clk_in),
//		.rst_in					(rst_FIR_in),
//		.wr_in					(ADC_int),
//		.rd_in					(ADC_int),
//		.x_in						(ADC_w),
//		.y_out					(y_w)
//	);
	

	FIR_MODULE #(
		.ADDR_WIDTH			(8), 
		.coef_bank			("coefis0.txt"),
		.N						(223)
	)
	FIR_BLOCK(
		.clk_in				(clk_in),
		.rst_in				(rst_FIR_in),
		.start_in			(ADC_int),
		.wr_in				(ADC_int),
		.x_in					(ADC_w),
		.y_out				(y_w)
	);
	
	always @(posedge ADC_int)
	begin
		if(ADC_int)
			ADC_w <= ADC_data;
	end
	
	assign y_out = (sel_in) ? (y_w) : ADC_w;
	
endmodule
