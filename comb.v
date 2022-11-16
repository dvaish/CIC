module comb #(
    parameter M=1,
    parameter N=2,
    parameter BITS=10
) (
    input clk, 
    input rst, 
    input [BITS-1:0] stream_in, 
    input valid,
    output [BITS-1:0] stream_out, 
    output ready
);
    wire [BITS-1:0] data [M:0];
    wire handshake [M:0];

    genvar m;
    generate
        for (m = 0; m < M; m = m + 1) begin
            differentiator #(
                .N(N), 
                .BITS(BITS)
            ) dt (
                .clk(clk), 
                .rst(rst), 
                .stream_in(data[m]),
                .valid(handshake[m]),
                .stream_out(data[m + 1]),
                .ready(handshake[m + 1])
            );
        end
    endgenerate

    assign data[0] = stream_in;
    assign handshake[0] = valid;
    assign stream_out = data[M];
    assign ready = handshake[M];

endmodule
