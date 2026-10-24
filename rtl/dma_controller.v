`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2026 09:45:36
// Design Name: 
// Module Name: dma_controller
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


module dma_controller(
    input clk,
    input rst,

    input start,                // start pulse from registers
    input [31:0] src_addr,      // source address
    input [31:0] dst_addr,      // destination address
    input [31:0] length,        // number of words

    output reg busy,            // DMA is working
    output reg done,            // transfer completed
    output reg interrupt        // interrupt signal
);

// FSM states
localparam IDLE = 2'b00;
localparam TRANSFER = 2'b01;
localparam COMPLETE = 2'b10;

reg [1:0] state;

// internal registers
reg [31:0] src;
reg [31:0] dst;
reg [31:0] count;

// simple internal memory (for demo)
// NOTE: This will infer block RAM in synthesis
reg [31:0] memory [0:255];

integer i;

// initialize memory (for simulation clarity only)
initial begin
    for (i = 0; i < 256; i = i + 1)
        memory[i] = 0;
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
        busy <= 0;
        done <= 0;
        interrupt <= 0;
    end
    else begin
        case (state)

        // ---------------- IDLE ----------------
        IDLE: begin
            done <= 0;
            interrupt <= 0;

            if (start && length != 0) begin
                busy <= 1;

                // load initial values
                src <= src_addr;
                dst <= dst_addr;
                count <= length;

                state <= TRANSFER;
            end
        end

        // ---------------- TRANSFER ----------------
        TRANSFER: begin
            // copy one word per clock
            memory[dst] <= memory[src];

            src <= src + 1;
            dst <= dst + 1;
            count <= count - 1;

            // last transfer
            if (count == 1) begin
                state <= COMPLETE;
            end
        end

        // ---------------- COMPLETE ----------------
        COMPLETE: begin
            busy <= 0;
            done <= 1;
            interrupt <= 1;

            state <= IDLE;
        end

        endcase
    end
end

endmodule
