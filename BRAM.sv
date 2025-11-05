`timescale 1ns / 1ps

module BRAM#(
    parameter DATA_WIDTH=16,
    parameter ADDR_WIDTH=9
    )
(
    input clka,
    //input rsta, dout <= if(rst) '0 : .. ;
    input wea,//write enable
    input ena,//bram  enable
    input [ADDR_WIDTH-1:0]addra, //address
    input [DATA_WIDTH-1:0]dina, //data_in
    output reg [DATA_WIDTH-1:0]douta //data_out
    );
    localparam RAM_DEPTH= 1<<ADDR_WIDTH;

    reg [DATA_WIDTH-1:0] mem [RAM_DEPTH-1:0];
    //READ_FIRST Mode 
    always @(posedge clka)begin
        if (ena)begin
          if(wea)begin
            mem[addra] <= dina;
           //douta<=dina;
          end
          douta <= mem[addra];
          //else begin
          //douta <= mem[addra];
          //end
        end
    end
    
endmodule
