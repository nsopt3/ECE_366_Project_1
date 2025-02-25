// A verilog project for ECE 366
// Nathan Sopt, Jesus Garcia, and Declan Hurless

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

/* Problem 1, part b:

Design a 1-bit full-adder in Verilog using structural modeling. Assume that the inputs are
A, B, and Cin, and outputs are S, Cout. Use the module template of Figure 1(a). [Points : 5]

*/

// INSERT CODE FOR PART B HERE:

/* Problem 1, part c:

Using the 1-bit full adder from either Part (a) or Part (b), design a 4-bit Ripple-Carry Adder
(RCA). Use the module template of 1(b). [Points : 10]

*/

// INSERT CODE FOR PART C HERE: