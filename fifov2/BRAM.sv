`timescale 1ns / 1ps
    //Read first BRAM
    //WRITE_FIRST Yapmak için Bypass konulmali
module BRAM#(
    parameter DATA_WIDTH=16,
    parameter ADDR_WIDTH=9
    )
(
    input clk,
    input wr_ea,//write enable
    input [ADDR_WIDTH-1:0]wr_addr,
    input [DATA_WIDTH-1:0]data_in, 
    
    input [ADDR_WIDTH-1:0]rd_addr, //address  
    output reg [DATA_WIDTH-1:0]douta //data_out
    );
    localparam RAM_DEPTH= 1<<ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];
    //READ_FIRST Mode 
    always @(posedge clk)begin
          if(wr_ea)begin
            mem[wr_addr] <= #1 data_in;
          end
            douta <= #1 mem[rd_addr];
    end
   
endmodule