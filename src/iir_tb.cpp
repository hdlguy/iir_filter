#include <fstream>
#include <iostream>
#include <complex>
#include <cmath>
#include "iir.hpp"

int main()
{

    // test impulse response.
	const int Nsim = 1024;

	data_type x, y[Nsim];

	for (int i=0; i<Nsim; i++){
		if (4==i) x = 1.0; else x = 0.0;
		y[i] = iir(x);
	}

	std::cout << "writing y.dat\n";
	std::ofstream outf { "./y.dat" };
	for (int i=0; i<Nsim; i++) outf << y[i] << "\n";




    // test frequency response with linear fm signal.
    const int Nsim2 = 4*1024;
    const std::complex<double> j(0, 1);

    std::complex<data_type> x2, y2[Nsim2];
    std::complex<double> s;
    double freq, phase, rate;
    rate = 2.0*M_PI/Nsim2; freq = -M_PI; phase = 0.0;
	std::cout << "writing fm.dat\n";
	std::ofstream outf2 { "./fm.dat" };
	for (int i=0; i<Nsim2; i++){
        phase += freq;
        freq  += rate;
        s = exp(j*phase);
        outf2 << s.real() << "  " << s.imag() << "\n";
    }


	return(0);
}

