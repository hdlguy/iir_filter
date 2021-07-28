#include <fstream>
#include <iostream>
#include "iir.hpp"

int main()
{
	const int Nsim = 1024;

	data_type x, y[Nsim];

	for (int i=0; i<Nsim; i++){
		if (4==i) x = 1.0; else x = 0.0;
		y[i] = iir(x);
	}

	std::cout << "writing y.dat\n";
	std::ofstream outf { "../../../y.dat" };
	for (int i=0; i<Nsim; i++){
		outf << y[i] << "\n";
	}

	return(0);
}

