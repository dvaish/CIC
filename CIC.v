module CIC #(
    parameter M=1, 
    parameter N=2, 
    parameter BITS=10,
    parameter N_BITS=$clog2(N)
) (
    input clk, 
    input rst, 
    input [BITS-1:0] stream_in, 
    input valid,
    output [BITS-1:0] stream_out, 
    output ready
);

    wire [BITS-1:0] accumulated;
    wire accumulated_ready;
    wire [BITS-1:0] downsampled;
    wire downsampled_ready;

    accumulator #(
        .M(M),
        .BITS(BITS)
    ) accumulator (
        .clk(clk),
        .rst(rst),
        .stream_in(stream_in),
        .valid(valid),
        .stream_out(accumulated),
        .ready(accumulated_ready)
    );

    downsampler #(
        .N(N),
        .BITS(BITS)
    ) downsampler (
        .clk(clk),
        .rst(rst),
        .stream_in(accumulated),
        .valid(accumulated_ready),
        .stream_out(downsampled),
        .ready(downsampled_ready)
    );

    differentiator #(
        .N(N),
        .BITS(BITS)
    ) differentiator (
        .clk(clk),
        .rst(rst),
        .stream_in(downsampled),
        .valid(downsampled_ready),
        .stream_out(stream_out),
        .ready(ready)
    );

endmodule
