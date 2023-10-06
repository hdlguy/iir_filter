#include <ap_int.h>
#include <ap_fixed.h>
#include <math.h>


// Data format
const int DataWordSize = 20;
const int DataIntSize = 4;
const float DataMaxVal = pow(2.0, DataIntSize-1);
typedef ap_fixed<DataWordSize, DataIntSize, AP_RND, AP_SAT, 0> data_type;




// Coeff format from iirgen.m

const int CoeffWordSize = 14;
const int CoeffIntSize = 2;
typedef ap_fixed<CoeffWordSize, CoeffIntSize, AP_RND, AP_SAT, 0> coeff_type;
const int Nsos = 4; // number of second order sections.
const coeff_type coeff_array[Nsos][6] = {
    { +0.0085449219, +0.0173339844, +0.0087890625, +1.0000000000, -1.6464843750, +0.6787109375 },
    { +0.0085449219, +0.0170898438, +0.0085449219, +1.0000000000, -1.6877441406, +0.7209472656 },
    { +0.0085449219, +0.0168457031, +0.0083007812, +1.0000000000, -1.7697753906, +0.8044433594 },
    { +0.0085449219, +0.0170898438, +0.0085449219, +1.0000000000, -1.8896484375, +0.9267578125 }
};




const float CoeffMaxVal = pow(2.0, CoeffIntSize-1);

class iir {
  private:
	data_type x_array[Nsos][3];
	data_type y_array[Nsos][3];
  public:
    iir();
    data_type filter(data_type x);
};

