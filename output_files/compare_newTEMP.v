module compare_newTEMP(coder,conmunicate);
	input [7:0] coder;
	output reg conmunicate;


	always@(coder[0])
			begin
				if(coder>8'b00000000 & coder<8'b10000000) conmunicate<=1;
				else conmunicate<=0;
			end
endmodule