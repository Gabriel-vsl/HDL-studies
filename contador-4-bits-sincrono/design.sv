// Code your design here
module counter4 (
    input  logic       clk,
    input  logic       rst_n,   // Reset assíncrono ativo em 0
    input  logic       en,      // Enable síncrono
    output logic [3:0] count
);

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count <= 4'd0;
    else if (en)
        count <= count + 4'd1;
    else
        count <= count;
end

endmodule
