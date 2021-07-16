#include <math.h>
#include <complex>
#include <iostream>
#include "inv_4x4.hpp" 
using namespace std;

void inv_2x2(CF x[2][2], CF y[2][2]);
void mult_2x2(CF x[2][2], CF y[2][2], CF z[2][2]);

void inv_2x2(CF x[2][2], CF y[2][2])
{
    
    CF repdet = CF_base(1.0)/(x[0][0]*x[1][1] - x[0][1]*x[1][0]);
    
    y[0][0]  =   x[1][1] * repdet;
    y[1][1]  =   x[0][0] * repdet;
    y[0][1]  =  -x[0][1] * repdet;
    y[1][0]  =  -x[1][0] * repdet;
}

void mult_2x2(CF x[2][2], CF y[2][2], CF z[2][2])
{
    
    z[0][0] = x[0][0]*y[0][0] + x[0][1]*y[1][0];
    z[0][1] = x[0][0]*y[0][1] + x[0][1]*y[1][1];
    z[1][0] = x[1][0]*y[0][0] + x[1][1]*y[1][0];
    z[1][1] = x[1][0]*y[0][1] + x[1][1]*y[1][1];
}

void inv_4x4(CF x[4][4], CF y[4][4])
{
#pragma HLS RESOURCE variable=x core=RAM_1P_LUTRAM
#pragma HLS RESOURCE variable=y core=RAM_1P_LUTRAM
#pragma HLS PIPELINE II=1000

    // Uses the following algorithm for block-wise inversion of a complex 
    // 4x4 Hermitian matrix.  From "On Matrix Inversion for LTE MIMO 
    // Applications Using Texas Instruments Floating Point DSP" by Yan & 
    // Song.
    //
    // 
    //      | A  B |      | Ai+AiBEiCAi    -AiBEi |
    //  inv(|      |)  =  |                       |
    //      | C  D |      |   -EiCAi         Ei   |
    //
    // where Ai = inv(A) and Ei = inv(D-CAiB).
    
	CF A[2][2], B[2][2], C[2][2], D[2][2], Ai[2][2];
	CF CAi[2][2], AiB[2][2], T1[2][2], T2[2][2], Inv2[2][2];
    
    // Form 2x2 sub-block matrices.
    A[0][0] = x[0][0];
    A[0][1] = x[0][1];
    A[1][0] = x[1][0];
    A[1][1] = x[1][1];

    B[0][0] = x[0][2];
    B[0][1] = x[0][3];
    B[1][0] = x[1][2];
    B[1][1] = x[1][3];

    C[0][0] = x[2][0];
    C[0][1] = x[2][1];
    C[1][0] = x[3][0];
    C[1][1] = x[3][1];

    D[0][0] = x[2][2];
    D[0][1] = x[2][3];
    D[1][0] = x[3][2];
    D[1][1] = x[3][3];
     
    // 1st term.
    inv_2x2(A,Ai);
    
    // 2nd term.
    mult_2x2(Ai,B,AiB);
    
    // 3rd term.
    mult_2x2(C,Ai,CAi);
    
    // 2nd inverse.
    mult_2x2(CAi,B,T1);
    T2[0][0] = D[0][0] - T1[0][0];
    T2[0][1] = D[0][1] - T1[0][1];
    T2[1][0] = D[1][0] - T1[1][0];
    T2[1][1] = D[1][1] - T1[1][1];
    inv_2x2(T2,Inv2);
    
    // Lower right block.
    y[2][2] = Inv2[0][0];
    y[2][3] = Inv2[0][1];
    y[3][2] = Inv2[1][0];
    y[3][3] = Inv2[1][1];
    
    // Upper right block.
    mult_2x2(AiB,Inv2,T1);
    y[0][2] = -T1[0][0];
    y[0][3] = -T1[0][1];
    y[1][2] = -T1[1][0];
    y[1][3] = -T1[1][1];
    
    // Lower left block.
    mult_2x2(Inv2,CAi,T1);
    y[2][0] = -T1[0][0];
    y[2][1] = -T1[0][1];
    y[3][0] = -T1[1][0];
    y[3][1] = -T1[1][1];
    
    // Upper left block.
    mult_2x2(AiB,T1,T2);
    y[0][0] = Ai[0][0] + T2[0][0];
    y[0][1] = Ai[0][1] + T2[0][1];
    y[1][0] = Ai[1][0] + T2[1][0];
    y[1][1] = Ai[1][1] + T2[1][1];
    
    return;
}
