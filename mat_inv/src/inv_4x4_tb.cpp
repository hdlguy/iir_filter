#include <iostream>
#include <fstream>
#include <string>
//#include <random>
using namespace std;

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "inv_4x4.hpp" 

int main()
{
	CF mat_out[4][4], mat_test[4][4], mat_in[4][4];
	const int num_tests = 10000;
	const CF_base error_tolerance = 5e-3;

	CF max_max_error = (CF_base(0.0),CF_base(0.0));
	srand(1);
    //std::uniform_real_distribution<CF_base> unif(-1.0, +1.0);
    //std::default_random_engine re;

	for(int test=0;test<num_tests;test++){

        // create a matrix of random numbers.
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
					mat_in[i][j] = CF((CF_base(rand())/RAND_MAX)*CF_base(2.0)-CF_base(1.0), (CF_base(rand())/RAND_MAX)*CF_base(2.0)-CF_base(1.0));
					//mat_in[i][j] = CF(unif(re), unif(re));
			}
		}

		// Call the matrix inverter function.
		inv_4x4(mat_in, mat_out);

		// Now let's multiply the matrix by it's inverse to check the results.
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				mat_test[i][j] = (CF_base(0.0),CF_base(0.0));
				for(int k=0;k<4;k++){
					mat_test[i][j] += mat_in[i][k]*mat_out[k][j];
				}
			}
		}

		// Now check the resulting identity matrix to verify inversion.
		CF error, max_error = (CF_base(0.0),CF_base(0.0));
		for(int i=0;i<4;i++){
			for(int j=0;j<4;j++){
				if (i==j){
					error = abs(mat_test[i][j]-CF(CF_base(1.0),CF_base(0.0)));
				} else{
					error = abs(CF(mat_test[i][j])-CF(CF_base(0.0),CF_base(0.0)));
				}
				if ( abs(error) > abs(max_error) ) max_error = error;
			}
		}

		//if (abs(max_error)>error_tolerance) printf("Test FAILED: max_error = %3.10e\n", max_error);
		if (abs(max_error)>error_tolerance)
			cout << "Test FAILED: max_error = " << max_error << "\n";
		if (abs(max_error)>abs(max_max_error)) 
			max_max_error = max_error;
	}

	cout << "\nmax_max_error = " << abs(max_max_error) << "\n\n";

	// Print out the last identity matrix for reference.
	for(int i=0;i<4;i++){
		for(int j=0;j<4;j++){
            cout << mat_test[i][j] << "  ";
		}
		printf("\n");
	}
	printf("\n");

	return(0);

}
