`timescale 1ns/1ps

module tb_alu32_pipe;

    reg clk = 0;
    reg rst = 1;
    reg valid_in = 0;
    reg [31:0] a = 0;
    reg [31:0] b = 0;
    reg [2:0] opcode = 0;

    wire valid_out;
    wire [31:0] result;

    integer errors = 0;

    alu32_pipe dut (
        .clk(clk),
        .rst(rst),
        .valid_in(valid_in),
        .a(a),
        .b(b),
        .opcode(opcode),
        .valid_out(valid_out),
        .result(result)
    );

    always #5 clk = ~clk;

    task check;
        input [2:0] op;
        input [31:0] x;
        input [31:0] y;
        input [31:0] expected;
        begin
            @(negedge clk);
            opcode = op;
            a = x;
            b = y;
            valid_in = 1;

            @(posedge clk);
            #1;
            @(posedge clk);
            #1;

            if (result !== expected) begin
                $display("FAIL op=%b a=%h b=%h got=%h expected=%h",
                         op, x, y, result, expected);
                errors = errors + 1;
            end else begin
                $display("PASS op=%b result=%h", op, result);
            end
        end
    endtask

    initial begin
        $dumpfile("alu32_pipe.vcd");
        $dumpvars(0, tb_alu32_pipe);

        repeat (2) @(negedge clk);
        rst = 0;

        check(3'b000, 32'd10, 32'd5, 32'd15);
        check(3'b001, 32'd10, 32'd5, 32'd5);
        check(3'b010, 32'hF0F0, 32'h0FF0, 32'h00F0);
        check(3'b011, 32'hF000, 32'h00F0, 32'hF0F0);
        check(3'b100, 32'hAAAA, 32'h0FF0, 32'hA55A);
        check(3'b101, 32'd3, 32'd2, 32'd12);
        check(3'b110, 32'd16, 32'd2, 32'd4);
        check(3'b111, 32'hFFFFFFFF, 32'd1, 32'd1);

        @(negedge clk);
        valid_in = 0;

        repeat (3) @(posedge clk);
        #1;

        if (valid_out !== 1'b0) begin
            $display("FAIL: valid_out did not return low");
            errors = errors + 1;
        end

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d error(s)", errors);

        $finish;
    end

endmodule
