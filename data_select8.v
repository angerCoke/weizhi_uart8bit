`timescale 1ns / 1ps

module data_select8(
				data,
				start,
				dataA1O,
				dataA2O,
				dataB1O,
				dataB2O,
				dataC1O,
				dataC2O,
				startO
);

input[7:0] data;
input start;
output reg[7:0]  dataA1O,dataA2O,dataB1O,dataB2O,dataC1O,dataC2O;
output reg startO;
reg [10:0] dataA1,dataA2,dataB1,dataB2,dataC1,dataC2;

reg[2:0] flag_angle;
reg change;


always@ (negedge start)
begin
	case(data[7:6])
		2'b00:
			begin
				flag_angle = data[2:0];
				change = 0;
			end
		2'b01:
			begin
				case(flag_angle)
					3'b001:dataA1[5:0] = data[5:0];
					3'b010:dataA2[5:0] = data[5:0];
					3'b011:dataB1[5:0] = data[5:0];
					3'b100:dataB2[5:0] = data[5:0];
					3'b101:dataC1[5:0] = data[5:0];
					3'b110:dataC2[5:0] = data[5:0];
				endcase
			end
		2'b10:
			begin
				case(flag_angle)
					3'b001:dataA1[10:6] = data[4:0];
					3'b010:dataA2[10:6] = data[4:0];
					3'b011:dataB1[10:6] = data[4:0];
					3'b100:dataB2[10:6] = data[4:0];
					3'b101:dataC1[10:6] = data[4:0];
					3'b110:dataC2[10:6] = data[4:0];
				endcase
			end
		2'b11: 
			begin
				case(data[5:0])
					6'b000000:change = 1;
					6'b000001:startO=1;
					6'b000010:startO=0;
				endcase
			end
		endcase
end

always@(posedge change)
begin
	dataA1O<=dataA1[7:0];
	dataA2O<=dataA2[7:0];
	dataB1O<=dataB1[7:0];
	dataB2O<=dataB2[7:0];
	dataC1O<=dataC1[7:0];
	dataC2O<=dataC2[7:0];
end

endmodule
