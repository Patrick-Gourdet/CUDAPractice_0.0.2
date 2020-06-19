#include <cuda_runtime_api.h>
#include <device_launch_parameters.h>
#include <iostream>
__global__ void cube(double* d_out, double* d_in)
{
	int idx = threadIdx.x;
	double f = d_in[idx];
	d_out[idx] = f*f*f;
	
}
int main()
{
	const uint64_t ARRAY_SIZE = 100;
	const uint64_t ARRAY_BYTES = ARRAY_SIZE * sizeof(double);

	double h_mult[ARRAY_SIZE];
	for(auto i{0};i < ARRAY_SIZE;i++)
	{
		h_mult[i] = double(i);
	}
	double h_mult_out[ARRAY_SIZE];

	double * d_in;
	double * d_out;

	cudaMalloc((void **) &d_in, ARRAY_BYTES);
	cudaMalloc((void **) &d_out, ARRAY_BYTES);

	cudaMemcpy(d_in, h_mult, ARRAY_BYTES, cudaMemcpyHostToDevice);
	cube<<<1, ARRAY_SIZE >>>(d_out,d_in);
	cudaMemcpy(h_mult_out,d_out,ARRAY_BYTES, cudaMemcpyDeviceToHost);
	for(auto i{0}; i < ARRAY_SIZE; i++)
	{
		std::cout << h_mult_out[i] << std::endl;
	}	
}
