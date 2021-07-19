#include <stdio.h>
#include "iir.hpp"

data_type iir(data_type x)
{
#pragma HLS INTERFACE mode=axis register_mode=both port=x register
#pragma HLS PIPELINE II=1

    // coefficients from iirgen.m
    const int Nsos = 2; // number of second order sections.
    const coeff_type coeff_array[Nsos][6] = {
        { +0.1010742188, +0.2021484375, +0.1010742188, +1.0000000000, -0.8554687500, +0.2097167969 },
        { +0.1010742188, +0.2021484375, +0.1010742188, +1.0000000000, -1.1130371094, +0.5739746094 }
    };

	static data_type sig_array[Nsos+1];
    sig_array[0] = x;

	for(int i=0;i<Nsos;i++){
		sig_array[i+1] = sos(sig_array[i], coeff_array[i][0], coeff_array[i][1], coeff_array[i][2], coeff_array[i][3], coeff_array[i][4], coeff_array[i][5]);
	}

	return(sig_array[Nsos]);
}
