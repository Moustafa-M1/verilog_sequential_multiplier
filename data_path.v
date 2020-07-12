module data_path
	#(parameter M = 8)
	(
		input clk, nrst,
		input [M-1:0] a, b,
		input start, add, mulc_en,		// CU to DP
		input shift,
		output cmp_bit,				// DP to CU
		output [2*M-1:0] result
	);
	
	// internal signals
	wire [M-1:0] b_out;

	dff #(.M(M)) multiplicand( // b
		.clk(clk), .nrst(nrst), .en(mulc_en), .d(b), .q(b_out)
	);
	
	reg [2*M:0] p_reg, p_next; // p register for multiplier and intermediate results
		
	always @(posedge clk, negedge nrst)
		if(!nrst)
			p_reg <= 0;
		else
			p_reg <= p_next;
	
	always @(*)
	  begin
		p_next = p_reg;
		if (start)
			p_next = a;
		if (add)
			p_next[2*M:M] = p_reg[2*M:M] + b_out;
		if (shift)
			p_next = p_reg >> 1;
	  end

	assign cmp_bit = p_reg[0] ? 1:0;
	assign result = p_reg[2*M-1:0];
endmodule
