// Structural Verilog for fast 32-bit multiplier 
// Mark Sears and Navya Sri
// 7/21/18


//Top Level multiplier module
//uses booth2 method and compressors on partial products
//complets with a final fast CLA adder
module multiplier_32x32(MR, MC, Prod, clk);

parameter WIDTH = 32;

input [WIDTH-1:0] MC; //multiplicand
input [WIDTH-1:0] MR; //multiplier
input clk;

//registers to hold input and output
reg [WIDTH-1:0] Y;
reg [WIDTH-1:0] X;

wire [2*WIDTH-1:0] P; //64bit computer product 

output reg [2*WIDTH-1:0] Prod; //product output register

//on clock edge, accept new data into Y and X registers
//lock down the computed product from the previous inputs
always @ (posedge clk)
begin
	Y <= MC;
	X <= MR;
	Prod <= P;
end


//generate Partial Products using booth2 (16 total)
genvar j;
//PP are: PPs[0].PP
for ( j = 0; j < WIDTH/2; j = j+1 )
begin : PPs
  
  wire [WIDTH:0] PP; //Booth2 Partial Products have 1 extra bit. 32+1=33 bits
  wire double; //double is used to determine bit shifts
  
  //the first booth2 uses an implied 1'b0 as the previous bit
  booth2PP_32b booth2 (.Xbits( { X[2*j+1:2*j], (j == 0 ? 1'b0 : X[2*j-1]) } ), .Y(Y), .PP(PP), .double(double));
  
end


//Perform Compression
//wires for the compressed bits
wire [2*WIDTH-1:0] final_A;
wire [2*WIDTH:0] final_B;

assign final_B[0] = 1'b0; //First B for final adder is always 0        

genvar i;
//instantiate a compressor for each column of PPs (64 total)
for ( i = 0; i < 2*WIDTH; i = i+1 )
begin : compressors
wire [13:0] Cpass;
//each compressor adds all the bits in the column of partial products. 
  compressor_17b comp_17b(.bits({ (               i<=WIDTH           ? PPs[0].PP[i]     : (i<=WIDTH+2 ?  PPs[0].PP[WIDTH]   : (i==WIDTH+3 ? !PPs[0].PP[WIDTH] : 1'b0))), //bit from PP0
                                (i==0  && !PPs[0].double  ? X[1]   : (i==1 && PPs[0].double   ? X[1] : (i<=WIDTH+2 && i>=2  ? PPs[1].PP[i-2]   : (i==WIDTH+3 ? !PPs[1].PP[WIDTH]   : (i==WIDTH+4 ? 1'b1 : 1'b0))))), //bit from PP1
                                (i==2  && !PPs[1].double  ? X[3]   : (i==3 && PPs[1].double   ? X[3] : (i<=WIDTH+4 && i>=4  ? PPs[2].PP[i-4]   : (i==WIDTH+5 ? !PPs[2].PP[WIDTH]   : (i==WIDTH+6 ? 1'b1 : 1'b0))))), //bit from PP2
                                (i==4  && !PPs[2].double  ? X[5]   : (i==5 && PPs[2].double   ? X[5] : (i<=WIDTH+6 && i>=6  ? PPs[3].PP[i-6]   : (i==WIDTH+7 ? !PPs[3].PP[WIDTH]   : (i==WIDTH+8 ? 1'b1 : 1'b0))))), //bit from PP3
                                (i==6  && !PPs[3].double  ? X[7]   : (i==7 && PPs[3].double   ? X[7] : (i<=WIDTH+8 && i>=8  ? PPs[4].PP[i-8]   : (i==WIDTH+9 ? !PPs[4].PP[WIDTH]   : (i==WIDTH+10? 1'b1 : 1'b0))))), //bit from PP4
                                (i==8  && !PPs[4].double  ? X[9]   : (i==9 && PPs[4].double   ? X[9] : (i<=WIDTH+10&& i>=10 ? PPs[5].PP[i-10]  : (i==WIDTH+11? !PPs[5].PP[WIDTH]   : (i==WIDTH+12? 1'b1 : 1'b0))))), //bit from PP5
                                (i==10 && !PPs[5].double  ? X[11]  : (i==11 && PPs[5].double  ? X[11] : (i<=WIDTH+12&& i>=12 ? PPs[6].PP[i-12]  : (i==WIDTH+13? !PPs[6].PP[WIDTH]   : (i==WIDTH+14? 1'b1 : 1'b0))))), //bit from PP6
                                (i==12 && !PPs[6].double  ? X[13]  : (i==13 && PPs[6].double  ? X[13] : (i<=WIDTH+14&& i>=14 ? PPs[7].PP[i-14]  : (i==WIDTH+15? !PPs[7].PP[WIDTH]   : (i==WIDTH+16? 1'b1 : 1'b0))))), //bit from PP7
                                (i==14 && !PPs[7].double  ? X[15]  : (i==15 && PPs[7].double  ? X[15] : (i<=WIDTH+16&& i>=16 ? PPs[8].PP[i-16]  : (i==WIDTH+17? !PPs[8].PP[WIDTH]   : (i==WIDTH+18? 1'b1 : 1'b0))))), //bit from PP8
                                (i==16 && !PPs[8].double  ? X[17]  : (i==17 && PPs[8].double  ? X[17] : (i<=WIDTH+18&& i>=18 ? PPs[9].PP[i-18]  : (i==WIDTH+19? !PPs[9].PP[WIDTH]   : (i==WIDTH+20? 1'b1 : 1'b0))))), //bit from PP9
                                (i==18 && !PPs[9].double  ? X[19]  : (i==19 && PPs[9].double  ? X[19] : (i<=WIDTH+20&& i>=20 ? PPs[10].PP[i-20] : (i==WIDTH+21? !PPs[10].PP[WIDTH]  : (i==WIDTH+22? 1'b1 : 1'b0))))), //bit from PP10
                                (i==20 && !PPs[10].double ? X[21]  : (i==21 && PPs[10].double ? X[21] : (i<=WIDTH+22&& i>=22 ? PPs[11].PP[i-22] : (i==WIDTH+23? !PPs[11].PP[WIDTH]  : (i==WIDTH+24? 1'b1 : 1'b0))))), //bit from PP11
                                (i==22 && !PPs[11].double ? X[23]  : (i==23 && PPs[11].double ? X[23] : (i<=WIDTH+24&& i>=24 ? PPs[12].PP[i-24] : (i==WIDTH+25? !PPs[12].PP[WIDTH]  : (i==WIDTH+26? 1'b1 : 1'b0))))), //bit from PP12
                                (i==24 && !PPs[12].double ? X[25]  : (i==25 && PPs[12].double ? X[25] : (i<=WIDTH+26&& i>=26 ? PPs[13].PP[i-26] : (i==WIDTH+27? !PPs[13].PP[WIDTH]  : (i==WIDTH+28? 1'b1 : 1'b0))))), //bit from PP13
                                (i==26 && !PPs[13].double ? X[27]  : (i==27 && PPs[13].double ? X[27] : (i<=WIDTH+28&& i>=28 ? PPs[14].PP[i-28] : (i==WIDTH+29? !PPs[14].PP[WIDTH]  : (i==WIDTH+30? 1'b1 : 1'b0))))), //bit from PP14
                                (i==28 && !PPs[14].double ? X[29]  : (i==29 && PPs[14].double ? X[29] : (i<=WIDTH+30&& i>=30 ? PPs[15].PP[i-30] : (i==WIDTH+31? !PPs[15].PP[WIDTH]  : 1'b0                      )))), //bit from PP15                              
                                
                                (i==30 && !PPs[15].double ? X[31]  : (i==31 && PPs[15].double ? X[31] : 1'b0)) }),  //bit from PP16
                        .Cin((i==0 ? 14'b0 : compressors[(i==0 ? i : i-1)].Cpass)), 
                        .S(final_A[i]), 
                        .Cdrop(final_B[i+1]), 
                        .Cpass(Cpass)   );
                        
end //end generate compressors


//Perform Final Fast add
//FA_64b final_adder (.A(final_A), .B(final_B[63:0]), .S(P)); //slow Ripple Carry adder
FA_64b_CLA final_adder (.A(final_A), .B(final_B[63:0]), .S(P)); //fast CLA adder

//the final_adder output is the computed 64b product.

endmodule //end multiplier


//booth module computes one partial product based on the Multiplicand (Y) and 3 of the Multiplier bits (Xbits)
module booth2PP_32b(Xbits, Y, PP, double);
  
parameter WIDTH = 32;

input [WIDTH-1:0] Y; //Multiplicand
input [2:0] Xbits; // X[2:1] are 2 booth bits. X[0] is previous bit

output [WIDTH:0] PP; //Booth2 Partial Products have 1 extra bit. 32+1=33


wire neg; //neg signifies a negative PP. all bits in PP will be inverted
          //need to add 1 for 2's complement (performed in compression)

wire single;
output double; 

assign single = Xbits[0] ^ Xbits[1]; //single is true for R = 1 or -1
assign double = (!Xbits[2] & Xbits[1] & Xbits[0]) | (Xbits[2] & !Xbits[1] & !Xbits[0]); //double is true for R = 2 or -2
assign neg = Xbits[2]; //neg is true for R = -1 or -2

//generate combinational logic for this partial product.
//Each PP bit is a function of the Multiplicand bit, single, double, and neg signals
genvar i;
for(i = 0; i < WIDTH; i = i+1)
begin : booth2_PPs
	assign PP[i] = (double && i == 0 ? 1'b0 : (((single & Y[i]) | (double & Y[i-1]))^ neg));
end

assign PP[WIDTH] = ((single | double) & Y[WIDTH-1]) ^ neg ; //last PP bit is simplified because bit Y[8] is always 0

endmodule //booth2PP_32b

//compressor used to compress all the PP bits in a column
//each compressor is a tree of adders
//for a 17bit compressor, there are 15 Full Adders and 14 pass carries
//output is Sum bit and Cdrop bit
module compressor_17b (bits, Cin, S, Cdrop, Cpass);
  input [16:0] bits;
  input [13:0] Cin;
  output S, Cdrop;
  output [13:0] Cpass;
  
  wire [13:0] sums; //wires to pass the sums between FAs
  
  FA FA0  (.A(bits[0]),  .B(bits[1]),  .Cin(bits[2]),  .S(sums[0]), .Cout(Cpass[0]));
  FA FA1  (.A(bits[3]),  .B(bits[4]),  .Cin(bits[5]),  .S(sums[1]), .Cout(Cpass[1]));
  FA FA2  (.A(bits[6]),  .B(bits[7]),  .Cin(bits[8]),  .S(sums[2]), .Cout(Cpass[2]));  
  FA FA3  (.A(bits[9]),  .B(bits[10]), .Cin(bits[11]), .S(sums[3]), .Cout(Cpass[3]));
  FA FA4  (.A(bits[12]), .B(bits[13]), .Cin(bits[14]), .S(sums[4]), .Cout(Cpass[4]));
  FA FA5  (.A(sums[0]),  .B(sums[1]),  .Cin(sums[2]),  .S(sums[5]), .Cout(Cpass[5]));
  FA FA6  (.A(sums[3]),  .B(sums[4]),  .Cin(bits[15]), .S(sums[6]), .Cout(Cpass[6]));
  FA FA7  (.A(bits[16]), .B(Cin[0]),   .Cin(Cin[1]),   .S(sums[7]), .Cout(Cpass[7]));
  FA FA8  (.A(sums[5]),  .B(sums[6]),  .Cin(sums[7]),  .S(sums[8]), .Cout(Cpass[8]));
  FA FA9  (.A(Cin[2]),   .B(Cin[3]),   .Cin(Cin[4]),   .S(sums[9]), .Cout(Cpass[9]));
  FA FA10 (.A(Cin[5]),   .B(Cin[6]),   .Cin(Cin[7]),   .S(sums[10]), .Cout(Cpass[10]));
  FA FA11 (.A(sums[8]),  .B(sums[9]),  .Cin(sums[10]), .S(sums[11]), .Cout(Cpass[11]));
  FA FA12 (.A(Cin[8]),   .B(Cin[9]),   .Cin(Cin[10]),  .S(sums[12]), .Cout(Cpass[12]));
  FA FA13 (.A(sums[11]), .B(sums[12]), .Cin(Cin[11]),  .S(sums[13]), .Cout(Cpass[13]));
  FA FA14 (.A(sums[13]), .B(Cin[12]),  .Cin(Cin[13]),  .S(S), .Cout(Cdrop));
      
endmodule //compressor_17b


//Simple Ripple Carry adder
//easy to implement, low area and power
//but slow due to the ripple
module FA_64b (A, B, S);

parameter WIDTH = 64;
  
input  [WIDTH-1:0] A;
input  [WIDTH-1:0] B;
output [WIDTH-1:0] S;

genvar i;

//carries can be referenced as: FAs[0].cout
//Full Adders can be referenced as: FAs[0].myFA
for( i = 0; i < WIDTH; i = i+1)
begin : FAs
	wire cout;
	
	//first Full Adder has 0 carry in, all others use previous Carry-in
	if(i==0)
		FA myFA (.A(A[i]), .B(B[i]), .Cin(1'b0), .S(S[i]), .Cout(cout));
	else
		FA myFA (.A(A[i]), .B(B[i]), .Cin(FAs[i-1].cout), .S(S[i]), .Cout(cout));
end

endmodule //FA_64b


//single 1-bit Full Adder module
//uses mirror carry and mirror sum function
module FA (A, B, Cin, S, Cout);
input A;
input B;
input Cin;

wire Cout_b;
wire S_b;

output S;
output Cout;

assign Cout_b = !( (A&B) | (Cin&(A|B)) );         //mirror carry
assign S_b = !((A&B&Cin) | (Cout_b & (A|B|Cin))); //mirror sum

assign Cout = !Cout_b; //give non-inverted logic outputs for simplicity
assign S = !S_b;

endmodule //FA


//carry look-ahead tree used to speed up the final adder by precalculating the carries
//         G2
//        /  \ 
//       /    \
//     G1      G1
//    /  \    /  \
//  G0   G0  G0  G0
module CLA_tree_64b(A, B, G0, P0, G1, P1, G2, P2, G3, P3, G4, P4, G5, P5, G6, P6); //carry look-ahead tree for a 64bit adder

parameter WIDTH = 64;
  
input  [WIDTH-1:0] A;
input  [WIDTH-1:0] B;

output [WIDTH-1   :0] G0; //individual generates  (size 64)
output [WIDTH-1   :0] P0; //individual propagates (size 64)
output [WIDTH/2-1 :0] G1; //first layer of group generates (size 32)
output [WIDTH/2-1 :0] P1; //first layer of group propagates(size 32)
output [WIDTH/4-1 :0] G2; 
output [WIDTH/4-1 :0] P2;
output [WIDTH/8-1 :0] G3; 
output [WIDTH/8-1 :0] P3;
output [WIDTH/16-1:0] G4; 
output [WIDTH/16-1:0] P4;
output [WIDTH/32-1:0] G5; //fifth layer of group generates (size 2) 
output [WIDTH/32-1:0] P5; //fifth layer of group propagates(size 2)
output G6; //top group generate
output P6; //top group propagate

//generate logic gates for G0 and P0
genvar i;
for(i = 0; i <= WIDTH-1; i = i+1)
begin : layer0
	assign G0[i] = A[i] & B[i]; //individual generate
	assign P0[i] = A[i] | B[i]; //individual propagate	
end

//generate logic gates for G1 and P1
for(i = 0; i <= WIDTH/2-1; i = i+1)
begin : layer1
	assign G1[i] = G0[(2*i)+1] | (P0[(2*i)+1] & G0[(2*i)]); //group generates
	assign P1[i] = P0[(2*i)+1] & P0[(2*i)];                //group propagates	
end

//generate logic gates for G2 and P2
for(i = 0; i <= WIDTH/4-1; i = i+1)
begin : layer2
	assign G2[i] = G1[(2*i)+1] | (P1[(2*i)+1] & G1[(2*i)]); //group generates
	assign P2[i] = P1[(2*i)+1] & P1[(2*i)];                //group propagates	
end

//generate logic gates for G3 and P3
for(i = 0; i <= WIDTH/8-1; i = i+1)
begin : layer3
	assign G3[i] = G2[(2*i)+1] | (P2[(2*i)+1] & G2[(2*i)]); //group generates
	assign P3[i] = P2[(2*i)+1] & P2[(2*i)];                //group propagates	
end

//generate logic gates for G4 and P4
for(i = 0; i <= WIDTH/16-1; i = i+1)
begin : layer4
	assign G4[i] = G3[(2*i)+1] | (P3[(2*i)+1] & G3[(2*i)]); //group generates
	assign P4[i] = P3[(2*i)+1] & P3[(2*i)];                //group propagates	
end

//generate logic gates for G5 and P5
for(i = 0; i <= WIDTH/32-1; i = i+1)
begin : layer5
	assign G5[i] = G4[(2*i)+1] | (P4[(2*i)+1] & G4[(2*i)]); //group generates
	assign P5[i] = P4[(2*i)+1] & P4[(2*i)];                //group propagates	
end

//generate logic gates for G6 and P6
	assign G6 = G5[1] | (P5[1] & G5[0]);  //top layer group generates
	assign P6 = P5[1] & P5[0];           //top layer group propagates	


endmodule //CLA_tree_64b


//final adder with carry look-ahead
//increased speed of final addition
//uses significantly more area than Ripple-Carry adder
module FA_64b_CLA(A, B, S); 

parameter WIDTH = 64;
  
input  [WIDTH-1:0] A;
input  [WIDTH-1:0] B;
output [WIDTH-1:0] S;

wire [WIDTH-1:0]    G0s  [WIDTH/4-1:0]; //wire for all 16 trees
wire [WIDTH-1:0]    P0s  [WIDTH/4-1:0]; 
wire [WIDTH/2-1:0]  G1s  [WIDTH/4-1:0]; 
wire [WIDTH/2-1:0]  P1s  [WIDTH/4-1:0]; 
wire [WIDTH/4-1:0]  G2s  [WIDTH/4-1:0]; 
wire [WIDTH/4-1:0]  P2s  [WIDTH/4-1:0]; 
wire [WIDTH/8-1:0]  G3s  [WIDTH/4-1:0]; 
wire [WIDTH/8-1:0]  P3s  [WIDTH/4-1:0]; 
wire [WIDTH/16-1:0] G4s [WIDTH/4-1:0]; 
wire [WIDTH/16-1:0] P4s [WIDTH/4-1:0]; 
wire [WIDTH/32-1:0] G5s [WIDTH/4-1:0]; 
wire [WIDTH/32-1:0] P5s [WIDTH/4-1:0]; 
wire G6s [WIDTH/4-1:0]; 
wire P6s [WIDTH/4-1:0]; 



//generate 16 CLA trees to pre-calculate the carries quickly (at great expense to area/power)
//reference CLA trees with: trees[0].CLA_tree
genvar i;
for(i=0; i < 16; i=i+1)
begin : trees

//CLA trees output all the group generates and propagates
if(i == 0)
    CLA_tree_64b CLA_tree (.A({A[63:0]}),              .B({B[63:0]}),              .G0(G0s[i]), .P0(P0s[i]), .G1(G1s[i]), .P1(P1s[i]), .G2(G2s[i]), .P2(P2s[i]), .G3(G3s[i]), .P3(P3s[i]), .G4(G4s[i]), .P4(P4s[i]), .G5(G5s[i]), .P5(P5s[i]), .G6(G6s[i]), .P6(P6s[i]));
else  //CLA trees take 0s as inputs before the 0 index
    CLA_tree_64b CLA_tree (.A({A[63-i:0], {i{1'b0}}}), .B({B[63-i:0], {i{1'b0}}}), .G0(G0s[i]), .P0(P0s[i]), .G1(G1s[i]), .P1(P1s[i]), .G2(G2s[i]), .P2(P2s[i]), .G3(G3s[i]), .P3(P3s[i]), .G4(G4s[i]), .P4(P4s[i]), .G5(G5s[i]), .P5(P5s[i]), .G6(G6s[i]), .P6(P6s[i]));
    
end

wire [WIDTH-1:0] carries;
//generate logic to compute all 64 carries using the CLA trees
for(i=0; i < 64; i=i+1)
begin : carry_calculations
     
  if(i < WIDTH/4) //0 to 15
    assign carries[i] = G4s[WIDTH/4-i-1][0];   //carry in for this node is 0, so (propagate & Cin) is not needed
else if(i >= WIDTH/4 && i < 2*WIDTH/4) //15 to 31
    assign carries[i] = G5s[2*WIDTH/4-i-1][0]; //carry in for this node is 0
else if(i >= 2*WIDTH/4 && i < 3*WIDTH/4)//32 to 47
    assign carries[i] = G4s[3*WIDTH/4-i-1][2] | (P4s[3*WIDTH/4-i-1][2] && carries[2*WIDTH/4-1]);  //carry in for this node is carries[31]
else if(i >= 3*WIDTH/4) //48 to 63
    assign carries[i] = G6s[WIDTH-i-1];        //carry in for this node is 0
    
end

//generate full adders to sum up the bits
//use carries that were generated with CLA
for( i = 0; i < WIDTH; i = i+1)
begin : FAs
	wire cout;
	
		//first Full Adder has 0 carry in. All others use carries precomputed with CLA trees
		FA myFA (.A(A[i]), .B(B[i]), .Cin(i == 0 ? 1'b0 : carries[i-1]), .S(S[i]), .Cout(cout));
		
end

endmodule //FA_64b_CLA