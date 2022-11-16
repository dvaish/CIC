`timescale 1ps/1ps

`define assert(signal, value) \
	if (signal != value) begin \
		$display("ASSERTION FAILED in %m: signal != value"); \
	end


module CIC_tb();

    localparam T = 2;
    localparam N = 2;
    localparam M = 1;
    localparam BITS = 32;

    integer fr, fw;

    reg clk = 0;
    reg rst = 0;
    reg [BITS-1:0] stream_in = 0;
    reg valid = 0;
    wire [BITS-1:0] stream_out;
    wire ready;

    reg [31:0] value = 0;

    CIC #(
        .M(M),
        .N(N),
        .BITS(BITS)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .stream_in(stream_in),
        .valid(valid),
        .stream_out(stream_out),
        .ready(ready)
    );

    initial begin
        clk = 1'b0;
        forever #(T / 2) clk = ~clk;
    end

    initial begin
        rst = 1;
        valid = 0;
        repeat (2) @(posedge clk);
        rst = 0;
        valid = 1;
    end
    
    initial begin
        repeat (2) @(posedge clk)
        fr = $fopen("inputs.txt", "rb");
        while ($fscanf(fr, "%d\n", value)) begin
            stream_in <= value[9:0];
            @(posedge clk);
        end
    end

    initial begin
        repeat (2) @(posedge clk)
        fw = $fopen("outputs.txt", "w");
        while (1) begin
            if (ready) begin 
                $fwrite(fw, "%d\n", stream_out);
            end 
            @(posedge clk);
        end
    end

    initial begin
        $dumpfile("test.vcd");
        $dumpvars;
        #(2 * 1024 *T);
        $finish;
    end

endmodule 