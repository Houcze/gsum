#include <cuda_runtime.h>
#include <iostream>


__global__ void sum(double *d_a, double *d_b, int n)
{
    int idx = threadIdx.x;
    int i = 2, j = 1;
    do {
        if (idx % i == 0)
        {
            d_a[idx] += d_a[idx + j];
        }
        i *= 2;
        j *= 2;
    } while (n /= 2);
    d_b[0] = d_a[0];
}


int main(void)
{
    int n{5000};
    double *h_a = (double *) malloc(sizeof(double) * n);
    double *h_b = (double *) malloc(sizeof(double));
    double *d_a;
    double *d_b;
    cudaMalloc(&d_a, sizeof(double) * n);
    cudaMalloc(&d_b, sizeof(double));

    for(int i=0; i < n; i++)
    {
        h_a[i] = i + 1;
    }
    h_b[0] = 0;
    cudaMemcpy(d_a, h_a, sizeof(double) * n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, sizeof(double), cudaMemcpyHostToDevice);
    sum<<<1, n>>>(d_a, d_b, n);
    cudaMemcpy(h_b, d_b, sizeof(double), cudaMemcpyDeviceToHost);
    std::cout << "The result is " << h_b[0] << std::endl;
    free(h_a);
    free(h_b);
    cudaFree(d_a);
    cudaFree(d_b);

}
