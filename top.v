module top
	#(parameter M = 8,
		    CBIT = 4 // log2(M)+1
	)
	(
		input clk, nrst,
		input [M-1:0] a, b,
		input start,
		output done,
		output [2*M-1:0] z
	);
	
	wire shift;
	wire add, cmp_bit, start_op, mulc_en;

	data_path #(.M(M)) dp 
		(.clk(clk), .nrst(nrst), .a(a), .b(b), .start(start_op), .mulc_en(mulc_en), .shift(shift),
		 .add(add), .cmp_bit(cmp_bit), .result(z)
		);
	controller #(.M(M), .CBIT(CBIT)) cu 
		(.clk(clk), .nrst(nrst), .start(start), .cmp_bit(cmp_bit), .shift(shift),
		 .add(add), .start_op(start_op), .mulc_en(mulc_en), .done(done)
		);

endmodule
