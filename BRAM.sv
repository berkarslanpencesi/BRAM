`timescale 1ns / 1ps
    //Read first BRAM
    //WRITE_FIRST Yapmak için Bypass konulmali
module BRAM#(
    parameter DATA_WIDTH=16,
    parameter ADDR_WIDTH=9
    )
(
    input clka,
    input wea,//write enable
    input [ADDR_WIDTH-1:0]addra, //address
    input [DATA_WIDTH-1:0]dina, //data_in
    output reg [DATA_WIDTH-1:0]douta //data_out
    );
    localparam RAM_DEPTH= 1<<ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];
    //READ_FIRST Mode 
    always @(posedge clka)begin
          douta <= #1 mem[addra];
          if(wea)begin
            mem[addra] <= #1 dina;
          end
    end
    
endmodule
