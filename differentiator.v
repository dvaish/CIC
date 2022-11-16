module differentiator #(
    parameter N=2, 
    parameter BITS=10
) (
    input clk, 
    input rst, 
    input [BITS-1:0] stream_in, 
    input valid,
    output reg [BITS-1:0] stream_out, 
    output reg ready
);

    localparam N_BITS = $clog2(N);

    integer i;
    
    reg [BITS-1:0] buffer [N-1:0];
    reg [BITS-1:0] value;
    reg [N_BITS-1:0] pointer;
    
    always @(posedge clk) begin
        if (rst) begin
            stream_out <= 0;
            pointer <= 0;
            ready <= 0;
            for (i = 0; i < N; i = i + 1) begin
                buffer[i] <= 0;
            end
        end else if (valid) begin
            value = stream_in - buffer[pointer];
            stream_out <= value[BITS-1:N_BITS];
            buffer[pointer] <= stream_in;
            pointer <= pointer + 1 == N ? 0 : pointer + 1;
            ready <= 1;
        end else begin
            ready <= 0;
        end
    end

endmodule
