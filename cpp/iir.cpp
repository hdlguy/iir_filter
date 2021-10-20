#include "iir.hpp"

iir::iir(){
    // initialize the data delay lines.
    for (int sec=0; sec<Nsos; sec++) {
        for (int i=0; i<3; i++) {
            x_array[sec][i] = 0.0;
            y_array[sec][i] = 0.0;
        }
    }
}


data_type iir::filter(data_type x)
{
#pragma HLS ALLOCATION operation instances=mul limit=4
#pragma HLS PIPELINE II=6

	coeff_type b0, b1, b2, a1, a2;

	data_type temp = x;

	// loop over the Second Order Sections
	label0:for(int i=0;i<Nsos;i++){

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

