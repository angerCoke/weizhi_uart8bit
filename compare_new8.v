module compare_new8(open,close,coder,conmunicate);
	input [7:0] coder,open,close;
	reg model;
	output reg conmunicate;
	always@(open or close)
	begin
		if(open>close) model<=1;
		else model<=0; 
	end
	always@(coder[0])
	begin
		if(model)
			begin
			if(coder>close & coder<open) conmunicate<=0;
			else conmunicate<=1;
			end
		else
			begin
				if(coder>open & coder<close) conmunicate<=1;
				else conmunicate<=0;
			end
		
	end
endmodule