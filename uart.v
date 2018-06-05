

/*
PC机上开串口调试助手.
发送一个字符(波特率9600，数据位8位，停止位1位)
到开发板（中间通过串口线相连）
FPGA收到字符后，回发给PC机上，在串口助手上显示
*/

/*不同的一点是
这是我根据例程中的写法自己改进的一个串口
这个串口主要将数据的输入端和输出端做了端口，而不是连在一起
这样做以后，就可以让外界使用，用于发送和接受数据了
*/


`timescale 1ns / 1ps

module uart(
				clk,rst_n,
				rs232_rx,rs232_tx,
				putdata,recivedata,
				rx_start,tx_start
				);

input clk;			// 50MHz主时钟
input rst_n;		//低电平复位信号

input rs232_rx;		// RS232接收数据信号
output rs232_tx;	//	RS232发送数据信号

input[7:0] putdata; //外界想要通过串口发送的数据入口
output[7:0] recivedata; //外界想要读取串口接收到的数据的入口

input tx_start; //外界告诉串口可以进行发送的信号，下降沿触发
output rx_start; //外界得知串口数据接收完毕，可以进行读取的信号，下降沿触发

wire bps_start1,bps_start2;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;		// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点 
wire[7:0] rx_data;	//接收数据寄存器，保存直至下一个数据来到
wire[7:0] tx_data;   //发送数据寄存器，直到下一个数据到来
wire rx_int;		//接收数据中断信号,接收到数据期间始终为高电平
wire tx_int;
//这个位在串口接收数据的过程中一直是高电平，所以其下降沿可以认为是数据接收完毕，可以读取
//而在发送模块中，相应的位置是开始发送的信号，下降沿触发
//----------------------------------------------------
//下面的四个模块中，speed_rx和speed_tx是两个完全独立的硬件模块，可称之为逻辑复制
//（不是资源共享，和软件中的同一个子程序调用不能混为一谈）
////////////////////////////////////////////
assign recivedata =  rx_data;
assign tx_data = putdata;
assign rx_start = rx_int;
assign tx_int = tx_start;

speed_select		speed_rx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

my_uart_rx			my_uart_rx(		
							.clk(clk),	//接收数据模块
							.rst_n(rst_n),
							.rs232_rx(rs232_rx),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1)
						);

///////////////////////////////////////////						
speed_select		speed_tx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);

my_uart_tx			my_uart_tx(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(tx_data),
							.rx_int(tx_int),
							.rs232_tx(rs232_tx),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2)
						);

endmodule
