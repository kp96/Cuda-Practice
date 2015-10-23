
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>

#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort = true)
{
	if (code != cudaSuccess)
	{
		fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
		if (abort) exit(code);
	}
}
__global__ void computeSquare(int *d_in, int *d_out) {
	int index = threadIdx.x;
	d_out[index] = d_in[index] * d_in[index];
 }
int main() {
	const int arr_size = 5;
	int h_in[arr_size] = { 1, 2, 3, 4, 5 };
	int h_out[arr_size];
	int arr_bytes = arr_size * sizeof(int);
	int *d_in, *d_out;
	cudaMalloc((void **)&d_in, arr_bytes);
	cudaMalloc((void **)&d_out, arr_bytes);
	cudaMemcpy(d_in, h_in, arr_bytes, cudaMemcpyHostToDevice);
	computeSquare <<<1, arr_size >>>(d_in, d_out);
	cudaMemcpy(h_out, d_out, arr_bytes, cudaMemcpyDeviceToHost);
	for (int i = 0; i < 5; i++) {
		printf("%d ", h_out[i]);
	}
	system("pause");
	return 0;
}