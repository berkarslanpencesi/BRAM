`timescale 1ns / 1ps
module sync_fifo #(parameter DEPTH=8, DWIDTH=16)
(
        input               	rstn,               // Active low reset
        input                   clk,
                            	wr_ea,rd_ea,         	
        input      [DWIDTH-1:0] din, 				// Data written into FIFO
        output     [DWIDTH-1:0] dout, 				// Data read from FIFO
        output              	empty, 				// FIFO is empty when high
                            	full 				// FIFO is full when high
);
    localparam ADDR_WIDTH = $clog2(DEPTH);
    
    reg [ADDR_WIDTH:0] wrptr; 
    reg [ADDR_WIDTH:0] rdptr;
    reg wr_ea_bram;
    
    
    assign wr_ea_bram = wr_ea && !full;
  
   BRAM #(
            .DATA_WIDTH(DWIDTH),        // Pass parameter DWIDTH
            .ADDR_WIDTH(ADDR_WIDTH)     // Pass parameter ADDR_WIDTH
        ) BRAM_inst (
        .clk(clk),
        .wr_ea(wr_ea_bram),
        .wr_addr(wrptr[ADDR_WIDTH-1:0]),
        .data_in(din),
        
        .rd_ea(rd_ea),
        .rd_addr(rdptr[ADDR_WIDTH-1:0]),
        .douta(dout)
    );
  
    always_ff @(posedge clk) begin
        if(!rstn)begin
         wrptr<=0;
         rdptr<=0;
        end
        else begin
         if(wr_ea && !full) begin
          wrptr <= wrptr + 1;
         end
         if(rd_ea && !empty)begin
          rdptr <= rdptr + 1;
         end
        end
    end
    
     assign full  =
        (wrptr[ADDR_WIDTH-1:0] == rdptr[ADDR_WIDTH-1:0]) &&
        (wrptr[ADDR_WIDTH]     != rdptr[ADDR_WIDTH]);
    assign empty = wrptr == rdptr;
endmodule