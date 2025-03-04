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

    assign S = A ^ B ^ Cin; // Sum = A XOR B XOR Cin
    assign Cout = (A & B) | (B & Cin) | (A & Cin); // Cout = (A AND B) OR (B AND Cin) OR (A AND Cin)

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
module four_bit_RCA_RCS_tb();
  reg [3:0] A, B;
  reg Cin;
  wire [3:0] S;
  wire Cout;
  
  four_bit_RCA_RCS uut (
    .A 		(A),
    .B		(B),
    .Cin	(Cin),
    .S		(S),
    .Cout	(Cout)
  );
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1, four_bit_RCA_RCS_tb);
    
    Cin = 1'b0;
    A = 4'd10;
    B = 4'd4;
    #100;
    Cin = 1'b1;
    A = 4'd10;
    B = 4'd4;
    #100;
  end

endmodule

// ******************************** Begin problem #2 **********************************

// Problem 2 (Designing a 32-bit CLA Adder/Subtractor).

/* 

Problem 2, part a: 

Design a 32-bit Carry Lookahead Adder (CLA) using a block size of four (4). Assume that
the inputs are A[31:0], B[31:0], and Cin, and outputs are S[31:0], Cout. Use the 4-bit full
adder (RCA) that you designed in Problem 1 as the component. You can only use 2-input
AND and OR gates to construct the carry propagation and carry generate logic. No need to
include subtraction operation for the CLA.

*/

// Ok, so before we can build the full 32-Bit CLA, we have to build a 4-Bit CLA block thingy to clone 8 times to give us 32-Bit CLA block

module 4Bit_CLA(A, B, Cin, S, Cout);

input [3:0] A, B;
input Cin;
output [3:0] S
output Cout;

wire [3:0] G, P, C; // Generate, propogate, and carry signals

// Define what generate and propogate are
assign G = A & B;   // A AND B
assign P = A ^ B;   // A XOR B

// Figuring out the carry computations (You can only use 2-Input AND and OR gates)
assign C[0] = Cin;
assign C[1] = G[0] | (P[0] & C[0]);
assign C[2] = G[1] | (P[1] & C[1]);
assign C[3] = G[2] | (P[2] & C[2]);
assign Cout = G[3] | (P[3] & C[3]);

// I'm not sure if this is how you get the sum, but hey we'll give it a go
assign S = P ^ C[3:0];

endmodule

// Now that we have the 4-Bit CLA, we can hopefuly stack them side by side until we get a 32-Bit CLA

module CLA(A, B, Cin, S, Cout); 

input [31:0] A, B;
input Cin;
output [31:0] S
output Cout;

wire [7:0] C; // This should handle the carry bits between the 8 4-Bit CLA blocks

// Here's the part where we smash these bad boys together to make a 32-Bit CLA super block
4Bit_CLA cla0 (A[3:0], B[3:0], Cin, S[3:0], C[0]);
4Bit_CLA cla1 (A[7:4], B[7:4], C[0], S[7:4], C[1]);
4Bit_CLA cla2 (A[11:8], B[11:8], C[1], S[11:8], C[2]);
4Bit_CLA cla3 (A[15:12], B[15:12], C[2], S[15:12], C[3]);
4Bit_CLA cla4 (A[19:16], B[19:16], C[3], S[19:16], C[4]);
4Bit_CLA cla5 (A[23:20], B[23:20], C[4], S[23:20], C[5]);
4Bit_CLA cla6 (A[27:24], B[27:24], C[5], S[27:24], C[6]);
4Bit_CLA cla7 (A[31:28], B[31:28], C[6], S[31:28], Cout);


endmodule


