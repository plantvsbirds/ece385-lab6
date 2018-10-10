module bitwise_andder
(
    input   logic[15:0]     A,
    input   logic[15:0]     B,
    output  logic[15:0]     Result
);

assign Result = A & B;

endmodule