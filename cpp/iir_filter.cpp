//#include <fstream>
//#include <iostream>
//#include <complex>
//#include <cmath>
#include "iir.hpp"

data_type iir_filter(data_type x)
{

    static iir iir1;
    data_type y;

    y = iir1.filter(x); 

	return(y);

}

