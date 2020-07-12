module controller
	#(parameter M = 8,
		    CBIT = 4 // log2(M)+1
	)
	(
		input clk, nrst,
		input cmp_bit, start,
		output reg add, start_op, mulc_en,
		output reg shift,
		output reg done
	);


	// state declaration
	localparam [1:0] 
		   idle    = 2'b00,
		   op1     = 2'b01,
		   op2     = 2'b10,
		   finish  = 2'b11;

	reg [1:0] state_reg, state_next;
	reg [CBIT:0] c_reg, c_next;

	always @(posedge clk, negedge nrst)
		if(!nrst)
		  begin
			state_reg <= idle;
			c_reg <= 0;
		  end
		else
		  begin
			state_reg <= state_next;
			c_reg <= c_next;
		  end

	always @(*)
	  begin
		state_next = state_reg;
		c_next = c_reg;
		case(state_reg)
			idle:
			  begin
				done = 0;
				add = 0;
				shift = 0;
				if (start)
				  begin
					start_op = 1;
					mulc_en = 1;
					state_next = op1;
					c_next = M;
				  end
			  end
			op1:
			  begin
				start_op = 0;
				mulc_en = 1;
				c_next = c_reg - 1;
				shift = 0;
				if(cmp_bit)
					add = 1;
				else
					add = 0;
				state_next = op2;
			  end
			op2:
			  begin
				shift = 1; 	// shift right
				start_op = 0;
				mulc_en = 0;
				add = 0;
				if (c_reg > 0)
					state_next = op1;
				else
					state_next = finish;
			  end
			finish:
			  begin
				done = 1;
				start_op = 0;
				state_next = idle;
				shift = 0;
				mulc_en = 0;
				add = 0;
			  end
			default: 
			  begin
				state_next = idle;
			  end
		endcase
	  end
endmodule

