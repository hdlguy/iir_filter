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
data_type sos(data_type x, const coeff_type b0, coeff_type b1, coeff_type b2, coeff_type a0, coeff_type a1, coeff_type a2);
data_type iir(data_type x);
