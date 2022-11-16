module integrator #(
    parameter BITS=10
) (
    input clk, 
    input rst, 
    input [BITS-1:0] stream_in, 
    input valid,
    output [BITS-1:0] stream_out, 
    output reg ready
); 

    reg [BITS-1:0] buffer;

    always @(posedge clk) begin
        if (rst) begin
            buffer <= 0;
            ready <= 0;
        end else if (valid) begin
            buffer <= stream_in + buffer;
            ready <= 1;
        end
    end

    assign stream_out = buffer;

endmodule
