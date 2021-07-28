#include "iir.hpp"

data_type iir(data_type x)
{
#pragma HLS PIPELINE II=1

	static data_type x_array[Nsos][3];
	static data_type y_array[Nsos][3];
	coeff_type b0, b1, b2, a0, a1, a2;

	data_type temp = x;

	// loop over the Second Order Sections
	for(int i=0;i<Nsos;i++){

		// get coeffs
		b0=coeff_array[i][0]; b1=coeff_array[i][1]; b2=coeff_array[i][2]; a1=coeff_array[i][4]; a2=coeff_array[i][5];

		// feed forward shift register
		x_array[i][2] = x_array[i][1];
		x_array[i][1] = x_array[i][0];
		x_array[i][0] = temp;

		// the filter
		y_array[i][0] = b0*x_array[i][0] + b1*x_array[i][1] + b2*x_array[i][2] - a1*y_array[i][1] - a2*y_array[i][2];

		// feedback shift register
		y_array[i][2] = y_array[i][1];
		y_array[i][1] = y_array[i][0];
		temp = y_array[i][0];

	}

	return(temp);
}
