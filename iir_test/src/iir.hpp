#include <ap_int.h>
#include <ap_fixed.h>

const int DataWordSize = 18;
const int DataIntSize = 4;
const float DataMaxVal = pow(2.0, DataIntSize-1);
typedef ap_fixed<DataWordSize, DataIntSize, AP_RND, AP_SAT, 0> data_type;

const int CoeffWordSize = 20;
const int CoeffIntSize = 4;
const float CoeffMaxVal = pow(2.0, CoeffIntSize-1);
typedef ap_fixed<CoeffWordSize, CoeffIntSize, AP_RND, AP_SAT, 0> coeff_type;

// function prototype
data_type soc(data_type x, const coeff_type a1, coeff_type a2, coeff_type b0, coeff_type b1, coeff_type b2);
