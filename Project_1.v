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

Design a 1-bit full-adder_ in Verilog using structural modeling. Assume that the inputs are
A, B, and Cin, and outputs are S, Cout. Use the module template of Figure 1(a). [Points : 5]

*/

module one_bit_full_adder_structural(A, B, Cin, S, Cout);
    input A, B, Cin;
    output S, Cout;

    wire AxorB, AB, AxorB_Cin; // Input connections

    // Gates to create the 1 bit full adder
    xor (AxorB, A, B);              // A XOR B
    xor (S, AxorB, Cin);            // (A XOR B) XOR Cin
  	and (AB, A, B);                  // A AND B
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
    $dumpvars(1);
    
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

module four_bit_CLA(A, B, Cin, S, Cout);

  input [3:0] A, B;
  input Cin;
  output [3:0] S;
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
  output [31:0] S;
  output Cout;

  wire [7:0] C; // This should handle the carry bits between the 8 4-Bit CLA blocks

  // Here's the part where we smash these bad boys together to make a 32-Bit CLA super block
  four_bit_CLA cla0 (A[3:0], B[3:0], Cin, S[3:0], C[0]);
  four_bit_CLA cla1 (A[7:4], B[7:4], C[0], S[7:4], C[1]);
  four_bit_CLA cla2 (A[11:8], B[11:8], C[1], S[11:8], C[2]);
  four_bit_CLA cla3 (A[15:12], B[15:12], C[2], S[15:12], C[3]);
  four_bit_CLA cla4 (A[19:16], B[19:16], C[3], S[19:16], C[4]);
  four_bit_CLA cla5 (A[23:20], B[23:20], C[4], S[23:20], C[5]);
  four_bit_CLA cla6 (A[27:24], B[27:24], C[5], S[27:24], C[6]);
  four_bit_CLA cla7 (A[31:28], B[31:28], C[6], S[31:28], Cout);

endmodule

module thirty_two_bit_CLA_tb();
  reg [31:0] A, B;
  reg Cin;
  wire [31:0] S;
  wire Cout;
  
  CLA uut (
    .A 		(A),
    .B		(B),
    .Cin	(Cin),
    .S		(S),
    .Cout	(Cout)
  );
  
  initial begin
    //initialize dumpfile for tb storage
    $dumpfile("dump.vcd");
    $dumpvars(1);
    
    //Test Cases where Cin = 0
    A=32'd0;
    B=32'd0;
    Cin=1'd0;
    
    //loop through all 2^x values
    //adds values and checks for correct value
    for(A=32'd1;A!=32'd0;A=A*2) begin
      for(B=32'd1;B!=32'd0;B=B*2) begin
        #1;
        if(S!=(A+B)) begin
          $display("Error at %0d + %1d. S = %2d.", A, B, S);
        end
        #1;
      end
    end
    
    //Test cases where Cin = 1
    A=32'd0;
    B=32'd0;
    Cin=1'd1;
    
    for(A=32'd1;A!=32'd0;A=A*2) begin
      for(B=32'd1;B!=32'd0;B=B*2) begin
        #1;
        if(S!=(A+B+1)) begin
          $display("Error at %0d + %1d. S = %2d.", A, B, S);
        end
        #1;
      end
    end
    
    $display("All test cases finished!");
  end
 
endmodule

// ******************************** Begin problem #3 **********************************

module PPA(A, B, Cin, S, Cout);
  
  input [15:0] A, B;
  input Cin;
  output [15:0] S;
  output Cout;

  wire [15:-1] [15:-1] G, P;
  
  assign G[-1][-1] = Cin;
  assign P[-1][-1] = 1'b0;
  
  assign G[0][0] = A[0] & B[0];
  assign G[1][1] = A[1] & B[1];
  assign G[2][2] = A[2] & B[2];
  assign G[3][3] = A[3] & B[3];
  assign G[4][4] = A[4] & B[4];
  assign G[5][5] = A[5] & B[5];
  assign G[6][6] = A[6] & B[6];
  assign G[7][7] = A[7] & B[7];
  assign G[8][8] = A[8] & B[8];
  assign G[9][9] = A[9] & B[9];
  assign G[10][10] = A[10] & B[10];
  assign G[11][11] = A[11] & B[11];
  assign G[12][12] = A[12] & B[12];
  assign G[13][13] = A[13] & B[13];
  assign G[14][14] = A[14] & B[14];
  assign G[15][15] = A[15] & B[15];
 
  assign P[0][0] = A[0] | B[0];
  assign P[1][1] = A[1] | B[1];
  assign P[2][2] = A[2] | B[2];
  assign P[3][3] = A[3] | B[3];
  assign P[4][4] = A[4] | B[4];
  assign P[5][5] = A[5] | B[5];
  assign P[6][6] = A[6] | B[6];
  assign P[7][7] = A[7] | B[7];
  assign P[8][8] = A[8] | B[8];
  assign P[9][9] = A[9] | B[9];
  assign P[10][10] = A[10] | B[10];
  assign P[11][11] = A[11] | B[11];
  assign P[12][12] = A[12] | B[12];
  assign P[13][13] = A[13] | B[13];
  assign P[14][14] = A[14] | B[14];
  assign P[15][15] = A[15] | B[15];
  
  //row 1
  assign G[0][-1] = G[0][0] | (P[0][0] & G[-1][-1]);
  assign P[0][-1] = P[0][0] & P[-1][-1];
  assign G[2][1] = G[2][2] | (P[2][2] & G[1][1]);
  assign P[2][1] = P[2][2] & P[1][1];
  assign G[4][3] = G[4][4] | (P[4][4] & G[3][3]);
  assign P[4][3] = P[4][4] & P[3][3];
  assign G[6][5] = G[6][6] | (P[6][6] & G[5][5]);
  assign P[6][5] = P[6][6] & P[5][5];
  assign G[8][7] = G[8][8] | (P[8][8] & G[7][7]);
  assign P[8][7] = P[8][8] & P[7][7];
  assign G[10][9] = G[10][10] | (P[10][10] & G[9][9]);
  assign P[10][9] = P[10][10] & P[9][9];
  assign G[12][11] = G[12][12] | (P[12][12] & G[11][11]);
  assign P[12][11] = P[12][12] & P[11][11];
  assign G[14][13] = G[14][14] | (P[14][14] & G[13][13]);
  assign P[14][13] = P[14][14] & P[13][13];
  
  //row 2
  assign G[1][-1] = G[1][1] | (P[1][1] & G[0][-1]);
  assign P[1][-1] = P[1][1] & P[0][-1];
  assign G[2][-1] = G[2][1] | (P[2][1] & G[0][-1]);
  assign P[2][-1] = P[2][1] & P[0][-1];
  assign G[5][3] = G[5][5] | (P[5][5] & G[4][3]);
  assign P[5][3] = P[5][5] & P[4][3];
  assign G[6][3] = G[6][5] | (P[6][5] & G[4][3]);
  assign P[6][3] = P[6][5] & P[4][3];
  assign G[9][7] = G[9][9] | (P[9][9] & G[8][7]);
  assign P[9][7] = P[9][9] & P[8][7];
  assign G[10][7] = G[10][9] | (P[10][9] & G[8][7]);
  assign P[10][7] = P[10][9] & P[8][7];
  assign G[13][11] = G[13][13] | (P[13][13] & G[12][11]);
  assign P[13][11] = P[13][13] & P[12][11];
  assign G[14][11] = G[14][13] | (P[14][13] & G[12][11]);
  assign P[14][11] = P[14][13] & P[12][11];
  
  //row 3
  assign G[3][-1] = G[3][3] | (P[3][3] & G[2][-1]);
  assign P[3][-1] = P[3][3] & P[2][-1];
  assign G[4][-1] = G[4][3] | (P[4][3] & G[2][-1]);
  assign P[4][-1] = P[4][3] & P[2][-1];
  assign G[5][-1] = G[5][3] | (P[5][3] & G[2][-1]);
  assign P[5][-1] = P[5][3] & P[2][-1];
  assign G[6][-1] = G[6][3] | (P[6][3] & G[2][-1]);
  assign P[6][-1] = P[6][3] & P[2][-1];
  assign G[11][7] = G[11][11] | (P[11][11] & G[10][7]);
  assign P[11][7] = P[11][11] & P[10][7];
  assign G[12][7] = G[12][11] | (P[12][11] & G[10][7]);
  assign P[12][7] = P[12][11] & P[10][7];
  assign G[13][7] = G[13][11] | (P[13][11] & G[10][7]);
  assign P[13][7] = P[13][11] & P[10][7];
  assign G[14][7] = G[14][11] | (P[14][11] & G[10][7]);
  assign P[14][7] = P[14][11] & P[10][7];
  
  //row 4
  assign G[7][-1] = G[7][7] | (P[7][7] & G[6][-1]);
  assign P[7][-1] = P[7][7] & P[6][-1];
  assign G[8][-1] = G[8][7] | (P[8][7] & G[6][-1]);
  assign P[8][-1] = P[8][7] & P[6][-1];
  assign G[9][-1] = G[9][7] | (P[9][7] & G[6][-1]);
  assign P[9][-1] = P[9][7] & P[6][-1];
  assign G[10][-1] = G[10][7] | (P[10][7] & G[6][-1]);
  assign P[10][-1] = P[10][7] & P[6][-1];
  assign G[11][-1] = G[11][7] | (P[11][7] & G[6][-1]);
  assign P[11][-1] = P[11][7] & P[6][-1];
  assign G[12][-1] = G[12][7] | (P[12][7] & G[6][-1]);
  assign P[12][-1] = P[12][7] & P[6][-1];
  assign G[13][-1] = G[13][7] | (P[13][7] & G[6][-1]);
  assign P[13][-1] = P[13][7] & P[6][-1];
  assign G[14][-1] = G[14][7] | (P[14][7] & G[6][-1]);
  assign P[14][-1] = P[14][7] & P[6][-1];
  
  //sums
  assign S[0] = G[-1][-1] ^ (A[0] ^ B[0]);
  assign S[1] = G[0][-1] ^ (A[1] ^ B[1]);
  assign S[2] = G[1][-1] ^ (A[2] ^ B[2]);
  assign S[3] = G[2][-1] ^ (A[3] ^ B[3]);
  assign S[4] = G[3][-1] ^ (A[4] ^ B[4]);
  assign S[5] = G[4][-1] ^ (A[5] ^ B[5]);
  assign S[6] = G[5][-1] ^ (A[6] ^ B[6]);
  assign S[7] = G[6][-1] ^ (A[7] ^ B[7]);
  assign S[8] = G[7][-1] ^ (A[8] ^ B[8]);
  assign S[9] = G[8][-1] ^ (A[9] ^ B[9]);
  assign S[10] = G[9][-1] ^ (A[10] ^ B[10]);
  assign S[11] = G[10][-1] ^ (A[11] ^ B[11]);
  assign S[12] = G[11][-1] ^ (A[12] ^ B[12]);
  assign S[13] = G[12][-1] ^ (A[13] ^ B[13]);
  assign S[14] = G[13][-1] ^ (A[14] ^ B[14]);
  assign S[15] = G[14][-1] ^ (A[15] ^ B[15]);
  
  //for(integer i = 0; i<16; i=i+1) begin
  //  assign S[i] = G[i-1][-1] ^ (A[i] ^ B[i]);
  //end
  
endmodule

// ************ Problem #3 testbench *********************

module PPA_tb();
  reg [15:0] A, B;
  reg Cin;
  wire [15:0] S;
  wire Cout;
  
  PPA uut (
    .A 		(A),
    .B		(B),
    .Cin	(Cin),
    .S		(S),
    .Cout	(Cout)
  );
  
  initial begin
    //initialize dumpfile for tb storage
    $dumpfile("dump.vcd");
    $dumpvars(1, uut);
    
    A=15'd0;
    B=15'd0;
    Cin = 1'b0;
   	#1
    
    for(A=16'd1;A!=16'd0;A=A*2) begin
      for(B=16'd1;B<16'd100;B=B+1) begin
        #1;
        if(S!=(A+B)) begin
          $display("Error at %0d + %1d. S = %2d.", A, B, S);
        end
        #1;
      end
    end
    
    $display("All test cases finished  for PPA!");  
  end
  
endmodule

// **************************************** BONUS PROBLEM #4 KOGGE-STONE ADDER *****************************************

module kogge_stone_16bit_adder(
    input [15:0] A, B,
    input Cin,
    output [15:0] S,
    output Cout
);
    wire [15:0] G, P, C;
    
    // Step 1: Precompute Generate and Propagate
    assign G = A & B;   // Generate
    assign P = A ^ B;   // Propagate
    
    // Step 2: Prefix Computation using Kogge-Stone Tree
    wire [15:0] G1, P1, G2, P2, G3, P3, G4, P4;
    
    // Level 1
    assign G1[0]  = G[0];
    assign P1[0]  = P[0];
    genvar i;
    generate
        for (i = 1; i < 16; i = i + 1) begin
            assign G1[i] = G[i] | (P[i] & G[i-1]);
            assign P1[i] = P[i] & P[i-1];
        end
    endgenerate
    
    // Level 2
    assign G2[0] = G1[0];
    assign G2[1] = G1[1];
    assign P2[0] = P1[0];
    assign P2[1] = P1[1];
    generate
        for (i = 2; i < 16; i = i + 1) begin
            assign G2[i] = G1[i] | (P1[i] & G1[i-2]);
            assign P2[i] = P1[i] & P1[i-2];
        end
    endgenerate
    
    // Level 3
    assign G3[0] = G2[0];
    assign G3[1] = G2[1];
    assign G3[2] = G2[2];
    assign G3[3] = G2[3];
    generate
        for (i = 4; i < 16; i = i + 1) begin
            assign G3[i] = G2[i] | (P2[i] & G2[i-4]);
            assign P3[i] = P2[i] & P2[i-4];
        end
    endgenerate
    
    // Level 4
    assign G4[0] = G3[0];
    assign G4[1] = G3[1];
    assign G4[2] = G3[2];
    assign G4[3] = G3[3];
    assign G4[4] = G3[4];
    assign G4[5] = G3[5];
    assign G4[6] = G3[6];
    assign G4[7] = G3[7];
    generate
        for (i = 8; i < 16; i = i + 1) begin
            assign G4[i] = G3[i] | (P3[i] & G3[i-8]);
        end
    endgenerate
    
    // Step 3: Compute Final Carry Values
    assign C[0] = Cin;
    assign C[1] = G1[0] | (P1[0] & Cin);
    assign C[2] = G2[1] | (P2[1] & C[1]);
    assign C[3] = G3[2] | (P3[2] & C[2]);
    assign C[4] = G4[3] | (P4[3] & C[3]);
    assign C[5] = G4[4] | (P4[4] & C[4]);
    assign C[6] = G4[5] | (P4[5] & C[5]);
    assign C[7] = G4[6] | (P4[6] & C[6]);
    assign C[8] = G4[7] | (P4[7] & C[7]);
    assign C[9] = G4[8] | (P4[8] & C[8]);
    assign C[10] = G4[9] | (P4[9] & C[9]);
    assign C[11] = G4[10] | (P4[10] & C[10]);
    assign C[12] = G4[11] | (P4[11] & C[11]);
    assign C[13] = G4[12] | (P4[12] & C[12]);
    assign C[14] = G4[13] | (P4[13] & C[13]);
    assign C[15] = G4[14] | (P4[14] & C[14]);
    assign Cout = G4[15] | (P4[15] & C[15]);
    
    // Step 4: Compute Sum
    assign S = P ^ C;
    
endmodule

// Testbench for Kogge-Stone 16-bit Adder
module kogge_stone_16bit_adder_tb;
    reg [15:0] A, B;
    reg Cin;
    wire [15:0] S;
    wire Cout;
    
    kogge_stone_16bit_adder uut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
    
    initial begin
        $dumpfile("kogge_stone_tb.vcd");
        $dumpvars(0, kogge_stone_16bit_adder_tb);
        
        A = 16'h0001; B = 16'h0001; Cin = 0; #10;
        A = 16'hFFFF; B = 16'h0001; Cin = 0; #10;
        A = 16'hAAAA; B = 16'h5555; Cin = 1; #10;
        A = 16'h1234; B = 16'h5678; Cin = 0; #10;
        A = 16'hFFFF; B = 16'hFFFF; Cin = 1; #10;
        
        $display("Test completed.");
        $finish;
    end
endmodule

