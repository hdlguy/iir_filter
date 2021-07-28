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

// function prototypes
data_type iir(data_type x);

// coefficients from Octave script
const int Nsos = 4; // number of second order sections.
const coeff_type coeff_array[Nsos][6] = {
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9562988281, +0.9829101562 },
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9567871094, +0.9938964844 },
    { +0.0026855469, +0.0051269531, +0.0024414062, +1.0000000000, -1.9624023438, +0.9743652344 },
    { +0.0026855469, +0.0051269531, +0.0026855469, +1.0000000000, -1.9680175781, +0.9697265625 }
};
