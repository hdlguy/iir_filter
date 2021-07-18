#include <stdio.h>
#include "iir.hpp"

data_type iir(data_type x)
{
#pragma HLS PIPELINE II=1

    const int Nsos = 4; // number of second order sections.
    static data_type sig_array[Nsos];
    const coeff_type coeff_array[Nsos][6] = {
        {+0.0927734375, +0.1499023438, +0.0927734375, +1.0000000000, -1.4143066406, +0.9826660156 },
        {+0.0927734375, +0.0200195312, +0.0927734375, +1.0000000000, -1.5029296875, +0.9450683594 },
        {+0.0927734375, -0.0454101562, +0.0927734375, +1.0000000000, -1.6750488281, +0.9016113281 },
        {+0.0927734375, -0.0681152344, +0.0927734375, +1.0000000000, -1.8320312500, +0.8674316406 }
    };

	static data_type sig_array[Nsos+1];
    sig_array[0] = x;

	for(int i=0;i<Nsos;i++){
		sig_array[i+1] = soc(sig_array[i], coeff_array[i][0], coeff_array[i][1], coeff_array[i][2], coeff_array[i][3], coeff_array[i][4], coeff_array[i][5]);
	}

	return(sig_array[Nsos]);
}
