`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.12.2023 22:53:10
// Design Name: 
// Module Name: ADD_SUB_DESIGN
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


module ADD_SUB_DESIGN(
  input logic clk,
  input logic reset_n,
  input logic [7:0] a_in,
  input logic [7:0] b_in,
  input logic opcode,
  output logic flag_out,
  output logic [7:0] result_out
  //output logic done
    );
   //fetchregister
    logic [16:0] fetch_reg;
    logic [8:0]  output_reg;
    
 //registered input   
    logic [7:0] a;
    logic [7:0] b;
    logic  op;
    
 //registered output
 
    logic [8:0] result;
    
  // Control signals
  logic fetch;
  logic decode;
  logic execute;
  logic store;
  
  //memory constraints
  logic w_en;
  logic [1:0] count;
  logic [1:0] w_addr;
  logic [1:0] r_addr;
  logic [8:0] memory [0:3];
  
  // events
  logic fetch_done;
  logic decode_done;
  logic execute_done;
  logic store_done;
  logic done;
  
 
 always_ff @ (posedge clk, negedge reset_n)
 begin:ASYNC_FETCH
 if(!reset_n)
 begin
 fetch_reg <= 'b0;
 fetch_done <= 1'b0;
 end
 else 
 begin:FETCH
 if(fetch)
 fetch_reg <= {opcode,b_in,a_in};
 fetch_done <= 1'b1;
 end:FETCH
 end:ASYNC_FETCH
 
 always_ff @ (posedge clk, negedge reset_n)
 begin:ASYNC_DECODE
 if(!reset_n)
 begin
 {op,b,a} <= 'b0;
 decode_done <= 'b0;
 end
 else 
 begin:DECODE
 if(decode)
 {op,b,a} <= fetch_reg;
 decode_done <= 'b1;
 end:DECODE
 end:ASYNC_DECODE
 
  
 always_ff @ (posedge clk, negedge reset_n)
 begin:ASYNC_EXECUTE
 if(!reset_n) begin
 output_reg <= 'b0;
 execute_done <= 1'b1;
 end
 else 
 begin:EXECUTE
 if(execute)
 output_reg <= result;
 execute_done <= 1'b1;
 end:EXECUTE
 end:ASYNC_EXECUTE
 
   
 always_ff @ (posedge clk, negedge reset_n)
 begin:ASYNC_STORE
 if(!reset_n)
 begin
 store_done <= 1'b0;
 end
 else 
 begin:STORE
 if(store)
 store_done <= 1'b1;
 end:STORE
 end:ASYNC_STORE
 
 always_ff @ (posedge clk, negedge reset_n)
 begin:ASYNC_CONTROL
 if(!reset_n)
begin
fetch   = 'b0;
decode  = 'b0;
execute = 'b0;
store   = 'b0;
done  = 'b0;
end 
else begin
fetch = 'b1;
if (fetch_done) 
    decode = 1'b1;
if (decode_done) 
    execute = 1'b1;
if (execute_done) 
    store = 1'b1;
if (store_done)
begin 
   w_en   = 1'b1;
   if(count == 2'b11)
   done = ~done;
end
end
end:ASYNC_CONTROL

always_ff @(posedge clk, negedge reset_n)
begin:COUNT
if(!reset_n)
count <= 'b0;
else
begin 
if(store_done)
count <= count + 1'b1;
else
count <= count;
end
end:COUNT

always_comb
begin
case(op)
1'b0: result = a + b;
1'b1: result = a - b;
endcase
end

always_ff @(posedge clk, negedge reset_n)
begin:WRITE
if(!reset_n)
memory[count] = 'b0;
else begin
memory[count] = output_reg;
end end:WRITE

always_ff @ (posedge clk, negedge reset_n)
begin:READ
if(!reset_n)
{flag_out,result_out} = 'b0;
else
begin
if(done)
{flag_out,result_out} = memory[count];
end
end:READ
endmodule
