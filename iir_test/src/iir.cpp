#include <stdio.h>
#include "iir.hpp"

data_type iir(data_type x)
{
#pragma HLS PIPELINE II=1

    // coefficients from iirgen.m
    const int Nsos = 2; // number of second order sections.
    const coeff_type coeff_array[Nsos][6] = {
        { +0.0305175781, +0.0610351562, +0.0305175781, +1.0000000000, -1.3652343750, +0.4775390625 },
        { +0.0305175781, +0.0610351562, +0.0305175781, +1.0000000000, -1.6118164062, +0.7446289062 }
    };

	data_type sig_array[Nsos+1];
    sig_array[0] = x;

	for(int i=0;i<Nsos;i++){
#pragma HLS UNROLL
		sig_array[i+1] = sos(sig_array[i], coeff_array[i][0], coeff_array[i][1], coeff_array[i][2], coeff_array[i][3], coeff_array[i][4], coeff_array[i][5]);
	}
	std::cout << sig_array[0] << " " << sig_array[1] << " " << sig_array[2] << "\n";

	//return(sig_array[Nsos]);
	return(sig_array[1]);
}
