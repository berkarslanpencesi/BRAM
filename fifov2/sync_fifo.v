`timescale 1ns / 1ps
module sync_fifo #(parameter DEPTH=8, DWIDTH=4, READWIDTH=1)
(
        input               	rstn,               // Active low reset
        input                   clk,
                            	wr_ea,
                            	rd_ea,         	
        input      [DWIDTH-1:0] din, 				// Data written into FIFO
        output     [READWIDTH-1:0] dout,         	// Data read from FIFO
        output              	empty, 				// FIFO is empty when high
                            	full 				// FIFO is full when high
);
  localparam RATIO = DWIDTH/READWIDTH;
  localparam RATIOLOG = $clog2(RATIO);
  localparam ADDR_WIDTH = $clog2(DEPTH);
  localparam READ_WIDTH = ADDR_WIDTH + RATIOLOG;
  reg [ADDR_WIDTH:0] wrptr; 
  reg [READ_WIDTH:0] rdptr;
  reg [DWIDTH-1:0]doutbram;
  reg wr_ea_bram;
    
    
  assign wr_ea_bram = wr_ea && !full;
  reg [RATIOLOG-1:0] rd_ptr_lsb_d;
  reg [ADDR_WIDTH-1:0] addr_bram;
   
  assign addr_bram = wr_ea ? wrptr[ADDR_WIDTH-1:0] : rdptr[READ_WIDTH-1 : RATIOLOG];
  BRAM #(
            .DATA_WIDTH(DWIDTH),        // Pass parameter DWIDTH
            .ADDR_WIDTH(ADDR_WIDTH)     // Pass parameter ADDR_WIDTH
        ) BRAM_inst (
        .clk(clk),
        .wr_ea(wr_ea_bram),
        .addr(addr_bram),
        .data_in(din),
        
        //.rd_ea(rd_ea),
        //.rd_addr(rdptr[READ_WIDTH-1 : RATIOLOG]),
        .douta(doutbram)
    );
    always_ff @(posedge clk) begin
            if(!rstn) begin
                wrptr <= 0;
                rdptr <= 0;
                rd_ptr_lsb_d <= 0; // Reset
            end
            else begin
                if(wr_ea && !full) begin
                    wrptr <= wrptr + 1;
                end
                if(rd_ea && !empty) begin
                    rdptr <= rdptr + 1;
                    rd_ptr_lsb_d <= rdptr[RATIOLOG-1:0]; 
                end
            end
        end
        
        assign full = 
                (wrptr[ADDR_WIDTH-1:0] == rdptr[ADDR_WIDTH+RATIOLOG-1 : RATIOLOG]) && 
                (wrptr[ADDR_WIDTH]     != rdptr[ADDR_WIDTH+RATIOLOG]);
        
        assign empty = (wrptr == rdptr[ADDR_WIDTH+RATIOLOG : RATIOLOG]);
        assign dout = doutbram[rd_ptr_lsb_d * READWIDTH +: READWIDTH];
    
    endmodule
