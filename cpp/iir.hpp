#include <ap_int.h>
#include <ap_fixed.h>
#include <math.h>

// Data format
const int DataWordSize = 20;
const int DataIntSize = 4;
const float DataMaxVal = pow(2.0, DataIntSize-1);
typedef ap_fixed<DataWordSize, DataIntSize, AP_RND, AP_SAT, 0> data_type;

// Coefficient format
const int CoeffWordSize = 14;
const int CoeffIntSize = 2;
const float CoeffMaxVal = pow(2.0, CoeffIntSize-1);
typedef ap_fixed<CoeffWordSize, CoeffIntSize, AP_RND, AP_SAT, 0> coeff_type;

// coefficients from Octave script
const int Nsos = 4; // number of second order sections.
const coeff_type coeff_array[Nsos][6] = {
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9562988281, +0.9829101562 },
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9567871094, +0.9938964844 },
    { +0.0026855469, +0.0051269531, +0.0024414062, +1.0000000000, -1.9624023438, +0.9743652344 },
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9680175781, +0.9697265625 }
};


class iir {
  private:
	data_type x_array[Nsos][3];
	data_type y_array[Nsos][3];
  public:
    iir();
    data_type iirfilt(data_type x);
};


iir::iir(){
    // initialize the data delay lines.
    for (int sec=0; sec<Nsos; sec++) {
        for (int i=0; i<3; i++) {
            x_array[sec][i] = 0.0;
            y_array[sec][i] = 0.0;
        }
    }

}


data_type iir::iirfilt(data_type x)
{

	coeff_type b0, b1, b2, a1, a2;

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
