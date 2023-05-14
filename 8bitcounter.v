`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Stanislav 
// 
// Create Date:    18:46:04 05/13/2023 
// Design Name: 
// Module Name:    8bitcounter 
// Project Name:   8bitcounter 
// Target Devices: 
// Tool versions: 
// Description: 8 bit counter that worked from button
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module debounce (
    input wire clock,
    input wire in,
    output reg out
    );
    
    reg [15:0] counter;

    initial begin
        counter = 0;
        out = 0;
    end
    
    always @(posedge clock) begin
        counter <= 0;

        if (counter == 15) begin
            out <= in;
        end
        else if (in != out) begin
            counter <= counter + 1;
        end
    end
endmodule

module sync(
    input wire clock,
    input wire in,
    output wire out
    );
    
    reg[2:0] sync_buffer;
    assign out = sync_buffer[2];
    
    always @(posedge clock) begin
        sync_buffer[2:0] <= {sync_buffer[1:0], in};
    end
endmodule

module counter(
    input wire clock,
    input wire button,
    output reg [7:0] count
    );
    
    initial begin
        count = 8'h0;
    end

    wire button_buffered;
    wire clock_buffered;
    
    IBUF BUTTON_BUF(.I(button), .O(button_buffered));
    IBUF CLOCK_BUF(.I(clock), .O(clock_buffered));
    
    wire button_sync;

    sync s_inst(
        .clock(clock_buffered),
        .in(button_buffered),
        .out(button_sync)
    );
    
    wire button_sync_debounced;

    debounce d_inst(
        .clock(clock_buffered),
        .in(button_sync),
        .out(button_sync_debounced)
    );
    
    always @(posedge button_sync_debounced) begin
        count <= count + 8'h01;
    end
endmodule
