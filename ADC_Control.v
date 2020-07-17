//////////////////////////////////////////////////////
// Date: 				7/16/2020
// Contributors: 		Lucy Rukstales, Michaela Mitchell
//
// Description: 		This file uses ADC_Read_12bit.v to collect a "user-defined" amount of data from an analog to digital converter (ADC)
//
// Sub Modules:		ADC_Read_12bit.v
//
// Components Used:	MIKROE-340
//////////////////////////////////////////////////////

module ADC_Control(clk,rst,CS,P3,P4,P5,storage);

	input P4;  // MISO
	input clk; // 50MHz FPGA clock
	input rst;
	
	output CS; // Chip Select
	output P3; // 50kHz ADC clock
	output P5; // MOSI
	
	output reg [119:0]storage;
	
	reg [3:0]storage_size;
	wire [3:0]storage_limit;
	wire [11:0]sample;
	wire [6:0]cnt20;
	
	assign storage_limit = 4'd10;
	
	ADC_Read_12bit my_ADC(clk,rst,CS,P3,P4,P5,sample,cnt20);
	
	//----------------------------------------------------
	// Run the ADC to collect enough data to fill storage
	always @(posedge clk or negedge rst) begin
	
		if (rst == 1'b0) begin 
			storage[11:0] <= 12'd0;
			storage_size <= 6'd0;
		end
		
		else if (cnt20 == 7'd21 && storage_size <= storage_limit) begin
			storage[119:11] <= storage[107:0];
			storage[11:0] <= sample[11:0];
			storage_size <= storage_size + 1'd1;
		end
		
		else storage <= storage;
		
	end
	
endmodule
