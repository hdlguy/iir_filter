#include <stdio.h>
#include "iir.hpp"

data_type iir(data_type x)
{
#pragma HLS INTERFACE mode=axis register_mode=both port=x register
#pragma HLS PIPELINE II=1

    // coefficients from iirgen.m
    const int Nsos = 4; // number of second order sections.
    const coeff_type coeff_array[Nsos][6] = {
        { +0.1018066406, +0.2070312500, +0.1049804688, +1.0000000000, -0.8349609375, +0.1809082031 },
        { +0.1018066406, +0.2038574219, +0.1020507812, +1.0000000000, -0.8906250000, +0.2595214844 },
        { +0.1018066406, +0.2006835938, +0.0988769531, +1.0000000000, -1.0153808594, +0.4357910156 },
        { +0.1018066406, +0.2038574219, +0.1018066406, +1.0000000000, -1.2426757812, +0.7575683594 }
    };

	static data_type sig_array[Nsos+1];
    sig_array[0] = x;

	for(int i=0;i<Nsos;i++){
		sig_array[i+1] = soc(sig_array[i], coeff_array[i][0], coeff_array[i][1], coeff_array[i][2], coeff_array[i][3], coeff_array[i][4], coeff_array[i][5]);
	}

	return(sig_array[Nsos]);
}
