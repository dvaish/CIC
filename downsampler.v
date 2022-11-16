module downsampler #(
    parameter N=2, 
    parameter BITS=10, 
    parameter N_BITS=$clog2(N)+1
) (
    input clk, 
    input rst,
    input [BITS-1:0] stream_in, 
    input valid,
    output reg [BITS-1:0] stream_out, 
    output reg ready
);
    reg [N_BITS-1:0] sample;
    
    always @(posedge clk) begin
        if (rst) begin
            sample <= 0;
            stream_out <= 0;
            ready <= 0;
        end 

        if (valid) begin
            if (sample == 0) begin
                stream_out <= stream_in;
                ready <= 1;
            end else ready <= 0;
            sample <= sample + 1 == N ? 0 : sample + 1;
        end else begin
            ready <= 0;
        end
    end
        
endmodule
