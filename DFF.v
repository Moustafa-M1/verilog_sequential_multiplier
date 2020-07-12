module dff 
	#(parameter M = 8)
	(
	input clk, nrst, en,
	input [M-1:0] d,
	output reg [M-1:0] q
	);

	always @(posedge clk, negedge nrst)
		if(!nrst)
			q <= 0;
		else if (en)
			q <= d;

endmodule
