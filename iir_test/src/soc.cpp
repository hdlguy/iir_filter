// This function implements a second order section (SOC) of an IIR filter.
// Cascade them to make higher order filters.
#include <stdio.h>
#include "iir.hpp"

data_type soc(data_type x, const coeff_type a1, coeff_type a2, coeff_type b0, coeff_type b1, coeff_type b2)
{
#pragma HLS PIPELINE II=1
	static data_type x_array[3], y_array[3];

	y_array[0] = x_array[0]*b0 + x_array[1]*b1 + x_array[2]*b2 + y_array[1]*a1 + y_array[2]*a2;

	y_array[2] = y_array[1];
	y_array[1] = y_array[0];

	x_array[2] = x_array[1];
	x_array[1] = x_array[0];
	x_array[0] = x;

	return(y_array[0]);
}
