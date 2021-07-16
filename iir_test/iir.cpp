#include <stdio.h>
#include "iir.hpp"

data_type iir(data_type x)
{
	const int Nsoc = 3; // number of second order sections.
	static data_type sig_array[Nsoc];
	const coeff_type coeff_array[Nsoc][5] = {
			// These are not valid coefficients.
			{ 1.5, 2.3, 0.8, 3.3, 1.2 },
			{ 1.4, 2.2, 0.7, 3.2, 1.1 },
			{ 1.6, 2.4, 0.9, 3.4, 1.3 }
	};

	for(int i=0;i<Nsoc;i++){
		sig_array[i] = soc(x, coeff_array[i][0], coeff_array[i][1], coeff_array[i][2], coeff_array[i][3], coeff_array[i][4]);
	}

	return(sig_array[Nsoc-1]);
}
