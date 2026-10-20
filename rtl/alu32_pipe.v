module alu32_pipe (
    input  wire        clk,
    input  wire        rst,
    input  wire        valid_in,
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire [2:0]  opcode,

    output reg         valid_out,
    output reg  [31:0] result
);

    reg [31:0] a_reg;
    reg [31:0] b_reg;
    reg [2:0]  op_reg;
    reg        valid_reg;

    reg [31:0] alu_result;

    always @(*) begin
        case (op_reg)
            3'b000: alu_result = a_reg + b_reg;
            3'b001: alu_result = a_reg - b_reg;
            3'b010: alu_result = a_reg & b_reg;
            3'b011: alu_result = a_reg | b_reg;
            3'b100: alu_result = a_reg ^ b_reg;
            3'b101: alu_result = a_reg << b_reg[4:0];
            3'b110: alu_result = a_reg >> b_reg[4:0];
            3'b111: alu_result =
                        ($signed(a_reg) < $signed(b_reg)) ? 32'd1 : 32'd0;
            default: alu_result = 32'd0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            a_reg     <= 32'd0;
            b_reg     <= 32'd0;
            op_reg    <= 3'd0;
            valid_reg <= 1'b0;
            result    <= 32'd0;
            valid_out <= 1'b0;
        end else begin
            a_reg     <= a;
            b_reg     <= b;
            op_reg    <= opcode;
            valid_reg <= valid_in;

            result    <= alu_result;
            valid_out <= valid_reg;
        end
    end

endmodule
