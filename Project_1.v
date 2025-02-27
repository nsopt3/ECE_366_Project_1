// A verilog project for ECE 366
// Nathan Sopt, Jesus Garcia, Declan Hurless, and Ephren Manning

// ************************** Some useful information ***********************************

/* 

In Verilog, "behavioral modeling" describes the functionality of a circuit at a high level, 
focusing on "what" the circuit should do using algorithmic descriptions, 
while "structural modeling" details the exact hardware components and their connections, 
essentially describing "how" the circuit is built using lower-level logic gates, 
representing a lower level of abstraction compared to behavioral modeling

// Arithmetic Operators
// *   : Multiply
// /   : Division
// +   : Add
// -   : Subtract
// %   : Modulus
// +   : Unary plus
// -   : Unary minus

// Logical Operators
// !   : Logical negation
// &&  : Logical AND
// ||  : Logical OR

// Relational Operators
// >   : Greater than
// <   : Less than
// >=  : Greater than or equal
// <=  : Less than or equal

// Equality Operators
// ==  : Equality
// !=  : Inequality

// Reduction Operators
// ~   : Bitwise negation
// ~&  : NAND
// |   : OR
// ~|  : NOR
// ^   : XOR
// ^~  : XNOR
// ~^  : XNOR

// Shift Operators
// >>  : Right shift
// <<  : Left shift

// Concatenation
// { } : Concatenation

// Conditional Operator
// ?   : Conditional (Ternary operator)

*/

// Problem 1: Problem 1 (Designing a 1-bit/4-bit Full Adder/Subtractor).

// ************************************************************************************

/* Problem 1, part a: 

Design a 1-bit full-adder in Verilog using behavioral modeling. Assume that the inputs are
A, B, and Cin, and outputs are S, Cout. Use the module template of Figure 1(a). [Points : 5]

*/

module one_bit_full_adder(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    // The always block will execute whenever A, B, Cin changes. The * means "all inputs used inside the block", which in our case is A, B, Cin.
    always @(*) begin
        S = A ^ B ^ Cin; // Sum = A XOR B XOR Cin
        Cout = (A & B) | (B & Cin) | (A & Cin); // Cout = (A AND B) OR (B AND Cin) OR (A AND Cin)
    end

endmodule

// ************************************************************************************

/* Problem 1, part b:

Design a 1-bit full-adder in Verilog using structural modeling. Assume that the inputs are
A, B, and Cin, and outputs are S, Cout. Use the module template of Figure 1(a). [Points : 5]

*/

module one_bit_full_adder(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    wire AxorB, AB, AxorB_Cin; // Input connections

    // Gates to create the 1 bit full adder
    xor (AxorB, A, B);              // A XOR B
    xor (S, AxorB, Cin);            // (A XOR B) XOR Cin
    and (AB, A, B)                  // A AND B
    and (AxorB_Cin, AxorB, Cin);    // (A XOR B) AND Cin
    or (Cout, AB, AxorB_Cin);       // Basically Cout
    
endmodule

// ************************************************************************************

/* Problem 1, part c:

Using the 1-bit full adder from either Part (a) or Part (b), design a 4-bit Ripple-Carry Adder
(RCA). Use the module template of 1(b). [Points : 10]

*/

module four_bit_RCA(A, B, Cin, S, Cout);
    input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;

    wire C1, C2, C3;

    one_bit_full_adder FA0 (A[0], B[0], Cin, S[0], C1);
    one_bit_full_adder FA1 (A[1], B[1], C1, S[1], C2);
    one_bit_full_adder FA2 (A[2], B[2], C2, S[2], C3);
    one_bit_full_adder FA3 (A[3], B[3], C3, S[3], Cout);


endmodule

// ************************************************************************************

/* Problem 1, part d:

Enhance the 4-bit RCA of Part (c) to construct 4-bit Ripple-Carry Subtractor (RCS). Use the
module template of 1(b). [Hint: Look at Lecture Slide 2, Slide 18.] [Points : 10]

*/

module four_bit_RCA_RCS (
    input [3:0] A, B,
    input Cin, // Cin = 0 for addition, Cin = 1 for subtraction
    output [3:0] S,
    output Cout
);
    wire [3:0] B_xor; // B after XOR with Cin
    wire c1, c2, c3;

    assign B_xor = B ^ {4{Cin}}; // If Cin=1, invert B for subtraction

    one_bit_full_adder FA0 (A[0], B_xor[0], Cin, S[0], c1);
    one_bit_full_adder FA1 (A[1], B_xor[1], c1, S[1], c2);
    one_bit_full_adder FA2 (A[2], B_xor[2], c2, S[2], c3);
    one_bit_full_adder FA3 (A[3], B_xor[3], c3, S[3], Cout);
    
endmodule

// ************************************************************************************

/* Problem 1, part e:

Design a testbench to test the 4-bit RCA/RCS. The testbench must perform at least one addition and one subtraction of two numbers (both signed and unsigned numbers.). (See the link
at Testbench writing). [Hint: See Lecture 1 and Lecture 2 for signed number arithmetic.]
[Points : 20]

*/

// INSERT CODE FOR PART E HERE:

// ************************************************************************************