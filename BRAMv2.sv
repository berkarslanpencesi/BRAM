    `timescale 1ns / 1ps
    //Read first BRAM
    //WRITE_FIRST Yapmak için Bypass konulmalý
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
       
        reg [ADDR_WIDTH-1:0]addra_f; //address
        reg [DATA_WIDTH-1:0]dina_f ;//data_in
        //reg [DATA_WIDTH-1:0]douta_f;//data_out
        reg wea_f;
        always @(posedge clka)begin
              addra_f <= addra;
              dina_f <=dina;
              wea_f <= wea;
              //douta <= douta_f;
              if(wea_f)begin
                mem[addra_f] <= dina_f;
              end
            end
          //assign douta_f = mem[addra_f];
            assign douta = mem[addra_f];
    endmodule
