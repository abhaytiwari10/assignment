`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.12.2023 23:39:09
// Design Name: 
// Module Name: tb_add_sub
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


module tb_add_sub;

  logic clk;
  logic reset_n;
  logic [7:0] a_in;
  logic [7:0] b_in;
  logic opcode;
  logic flag_out;
  logic [7:0] result_out;
  
 
  
  ADD_SUB_DESIGN DUT (.*);
  
   always #10 clk = ~clk;
  
  initial begin
  clk = 1'b0;
  reset_n = 1'b0;
  #10
  reset_n = 1'b1;
  #20
  a_in   = 8'h44;
  b_in   = 8'h55;
  opcode = 1'b0;
  
  #40
   a_in   = 8'h55;
  b_in   = 8'h11;
  opcode = 1'b1;
   #40
   a_in   = 8'h44;
  b_in   = 8'h22;
  opcode = 1'b0;
    #40
   a_in   = 8'h33;
  b_in   = 8'h55;
  opcode = 1'b1;
  end
endmodule
