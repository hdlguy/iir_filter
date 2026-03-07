#include <ap_int.h>
#include <ap_fixed.h>
#include <math.h>


// Data format
const int DataWordSize = 25;
const int DataIntSize = 3;
const float DataMaxVal = pow(2.0, DataIntSize-1);
typedef ap_fixed<DataWordSize, DataIntSize, AP_RND, AP_SAT, 0> data_type;
//typedef ap_fixed<DataWordSize, DataIntSize, AP_TRN, AP_WRAP, 0> data_type;




// Coeff format from iirgen.m


const int CoeffWordSize = 18;
const int CoeffIntSize = 4;
typedef ap_fixed<CoeffWordSize, CoeffIntSize, AP_RND, AP_SAT, 0> coeff_type;
const int Nsos = 3; // number of second order sections.
const coeff_type coeff_array[Nsos][6] = {
    { +0.9921264648, -1.9801635742, +0.9880371094, +1.0000000000, -1.9765014648, +0.9766845703 },
    { +0.9921264648, -1.9883422852, +0.9962158203, +1.0000000000, -1.9825439453, +0.9826660156 },
    { +0.9921264648, -1.9842529297, +0.9921264648, +1.0000000000, -1.9935302734, +0.9937133789 }
};


typedef ap_fixed<DataWordSize+CoeffWordSize+3, DataIntSize+CoeffIntSize, AP_TRN, AP_WRAP, 0> accum_type;

class iir {
  private:
	data_type x_array[Nsos][3];
	data_type y_array[Nsos][3];
  public:
    iir();
    data_type filter(data_type x);
};

