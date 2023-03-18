/*
 *  Scroll Text Display using a 4x8 Font.  
 * 
 *  Copyright(C) 2023 Robin Grosset
 *  
 *  This file and the entire 4x8 font data created for this project 
 *  is shared under the MIT license 
 * 
 */ 


// This is a 4x8 font for used with iceFUN pixel matrix
// its a very awkward font size

parameter  _s = 8'h00; // single line space
parameter  _cSP = 32'h00000000; // space
parameter  _cEX = 32'h00005F00; // explamation !
parameter  _cQQ = 32'h02015906; // question ?
parameter  _cFS = 32'h00400000; // full stop . 
parameter  _cCO = 32'h00002400; // colon : 
parameter  _cSC = 32'h00402400; // semi colon ; 

parameter  _cPLUS      = 32'h00081C08; // plus + 
parameter  _cMINUS     = 32'h00080808; // minus - 
parameter  _cDIVIDE    = 32'h40300C02; // divide / 
parameter  _cMULTIPLY  = 32'h62142846; // multiply x 
parameter  _cEQUALS    = 32'h14141414; // equals = 

parameter  _cFWDSLASH  = 32'h020C3040; // fwd slash \
parameter  _cOPENSQ    = 32'h00FF8100; // open sq [
parameter  _cCLOSESQ   = 32'h0081FF00; // close sq ]
parameter  _cFWDSLASH  = 32'h020C3040; // fwd slash \
parameter  _cOPENBR    = 32'h3C428100; // open br (
parameter  _cCLOSEBR   = 32'h0081423C; // close br )

// Missing Stuff! 
//  ' " $ # @ ^ % & | { }

// Hex Characters
parameter  _c0 = 32'h7E91897E;
parameter  _c1 = 32'h0002FF00;
parameter  _c2 = 32'hF2898986;
parameter  _c3 = 32'h42898976;
parameter  _c4 = 32'h000C0AFF;
parameter  _c5 = 32'h4F898971;
parameter  _c6 = 32'h7E898972;
parameter  _c7 = 32'h01E11907;
parameter  _c8 = 32'h76898976;
parameter  _c9 = 32'h4689897E;
parameter  _cA = 32'hFE0909FE;
parameter  _cB = 32'hFF898976;
parameter  _cC = 32'h7E818142;
parameter  _cD = 32'hFF81817E;
parameter  _cE = 32'hFF898981; 
parameter  _cF = 32'hFF090901;

// Rest of Alphabet
parameter  _cG = 32'h7E819172;
parameter  _cH = 32'hFF0808FF;
parameter  _cI = 32'h0081FF81;
parameter  _cJ = 32'h41817F01;
parameter  _cK = 32'hFF0814E3;
parameter  _cL = 32'hFF808080;
parameter  _cM = 32'hFF0202FF;
parameter  _cN = 32'hFF0810FF;
parameter  _cO = 32'h7E81817E;
parameter  _cP = 32'hFF090906;
parameter  _cQ = 32'h3E41C1BE;
parameter  _cR = 32'hFF1929B2;
parameter  _cS = 32'h46849162;
parameter  _cT = 32'h01FF0101;
parameter  _cU = 32'h7F80807F;
parameter  _cV = 32'h3F40807F;
parameter  _cW = 32'hFF4040FF;
parameter  _cX = 32'hEF1010EF;
parameter  _cY = 32'h0304F807;
parameter  _cZ = 32'hE1918987;


