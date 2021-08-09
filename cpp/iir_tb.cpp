#include <fstream>
#include <iostream>
#include <complex>
#include <cmath>
#include "iir.hpp"

int main()
{

    // create the filters
    iir iir_real, iir_imag;

    // test frequency response with linear fm signal.
    const int Nsim = 64*1024;
    const std::complex<double> j(0.0, 1.0);

    std::complex<data_type> x, y;
    double freq, phase, rate;
    double zoom = 4;
    rate = 2.0*M_PI/(zoom*Nsim); freq = -M_PI/zoom; phase = 0.0;

	std::cout << "writing lfm.dat\n";
	std::ofstream outf2 { "./lfm.dat" };
	for (int i=0; i<Nsim; i++){

        phase += freq;
        freq  += rate;
        x = exp(j*phase);

        y.real(iir_real.filter(x.real())); 
        y.imag(iir_imag.filter(x.imag()));

        double absval = sqrt( double(y.real())*double(y.real()) + double(y.imag())*double(y.imag()));
        outf2 << y.real() << "  " << y.imag() << "  " << absval << "\n";
    }


	return(0);
}

