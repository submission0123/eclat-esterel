module \$ff #(
    parameter WIDTH = 1
) (
    input  wire              clk,
    input  wire [WIDTH-1:0]  D,
    output reg  [WIDTH-1:0]  Q
);

always @(posedge clk) begin
    Q <= D;
end

endmodule
