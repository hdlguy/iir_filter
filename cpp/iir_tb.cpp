#include <fstream>
#include <iostream>
#include <complex>
#include <cmath>
#include "iir.hpp"

int main()
{

    iir iir1, iir2;

    data_type y1, y2, x1, x2;

    x1 = 1.0; y1 = iir1.iirfilt(x1);
    x2 = 1.0; y2 = iir2.iirfilt(x2);

	return(0);
}

