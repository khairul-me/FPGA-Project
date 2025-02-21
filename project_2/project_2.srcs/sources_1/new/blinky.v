`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2025 08:25:36 PM
// Design Name: 
// Module Name: blinky
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module blinky(
   input CLK12MHZ,
   output led0,
   output led1,
   output led2,
   output led3
);
   reg [24:0] count = 0;
   
   // Assign all LEDs to blink with the same pattern
   assign led0 = count[24];
   assign led1 = count[24] ^ count[23];
   assign led2 = count[24] ^ count[22];
   assign led3 = count[24] ^ count[21];
   
   always @ (posedge(CLK12MHZ)) count <= count + 1;
endmodule