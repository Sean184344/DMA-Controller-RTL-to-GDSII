`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.03.2026 09:49:15
// Design Name: 
// Module Name: dma_tb
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

module tb_dma;

reg clk;
reg rst;

reg [3:0] cpu_addr;
reg [31:0] cpu_wdata;
reg cpu_write;

wire [31:0] cpu_rdata;
wire interrupt;

dma_top dut(
    .clk(clk),
    .rst(rst),
    .cpu_addr(cpu_addr),
    .cpu_wdata(cpu_wdata),
    .cpu_write(cpu_write),
    .cpu_rdata(cpu_rdata),
    .interrupt(interrupt)
);

// clock
always #5 clk = ~clk;

integer i;

initial begin
    clk = 0;
    rst = 1;
    cpu_write = 0;

    #20 rst = 0;

    // initialize memory
    for (i = 0; i < 8; i = i + 1)
        dut.ctrl.memory[i] = i + 10;

    // configure DMA
    write_reg(4'h0, 0);    // SRC
    write_reg(4'h1, 20);   // DST
    write_reg(4'h2, 8);    // LENGTH
    write_reg(4'h3, 1);    // START

    // wait for interrupt
    wait(interrupt);

    // check result
    for (i = 0; i < 8; i = i + 1) begin
        if (dut.ctrl.memory[20+i] != dut.ctrl.memory[i]) begin
            $display("ERROR at %d", i);
            $finish;
        end
    end

    $display("DMA TEST PASSED");
    $finish;
end

task write_reg(input [3:0] addr, input [31:0] data);
begin
    @(posedge clk);
    cpu_addr = addr;
    cpu_wdata = data;
    cpu_write = 1;
    @(posedge clk);
    cpu_write = 0;
end
endtask

endmodule
