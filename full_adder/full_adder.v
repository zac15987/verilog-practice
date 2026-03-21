module full_adder(sum_o, carry_o, a_i, b_i, carry_i);
    input a_i, b_i, carry_i;
    output sum_o, carry_o;

    wire sum_w, carry_w1, carry_w2;

    half_adder u_ha0(
        .sum_o(sum_w), 
        .carry_o(carry_w1),
        .a_i(a_i),
        .b_i(b_i)
    );

    half_adder u_ha1(
        .sum_o(sum_o), 
        .carry_o(carry_w2),
        .a_i(sum_w),
        .b_i(carry_i)
    );

    or u_or0(carry_o, carry_w1, carry_w2);

endmodule
