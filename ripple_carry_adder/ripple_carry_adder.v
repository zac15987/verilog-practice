module ripple_carry_adder(sum_o, carry_o, a_i, b_i, carry_i);
    input [3:0]a_i, b_i;
    input carry_i;
    output [3:0]sum_o;
    output carry_o;

    wire carry_w1, carry_w2, carry_w3;
    
    full_adder u_fa0(
        .a_i(a_i[0]),
        .b_i(b_i[0]),
        .carry_i(carry_i),
        .sum_o(sum_o[0]),
        .carry_o(carry_w1)
    );
    
    full_adder u_fa1(
        .a_i(a_i[1]),
        .b_i(b_i[1]),
        .carry_i(carry_w1),
        .sum_o(sum_o[1]),
        .carry_o(carry_w2)
    );
    
    full_adder u_fa2(
        .a_i(a_i[2]),
        .b_i(b_i[2]),
        .carry_i(carry_w2),
        .sum_o(sum_o[2]),
        .carry_o(carry_w3)
    );
    
    full_adder u_fa3(
        .a_i(a_i[3]),
        .b_i(b_i[3]),
        .carry_i(carry_w3),
        .sum_o(sum_o[3]),
        .carry_o(carry_o)
    );

endmodule
