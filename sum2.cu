#include <cuda_runtime.h>
#include <iostream>
#include <cmath>

__global__ void l_trans(double *arr, double *result, int length, int i)
{
    int idx = threadIdx.x;
    if (idx < length - i)
    {
        result[idx] = arr[idx + i];
    }
}

__global__ void sum(double *a, double *b, int length)
{
    int idx = threadIdx.x;
    if (idx < length)
    {
        a[idx] = a[idx] + b[idx];
    }
}

double sum(double *h_a, int n)
{
    double *h_b;
    double *d_a;
    double *d_b;
    h_b = (double *)malloc(sizeof(double) * n);
    memset(h_b, sizeof(double) * n, 0);

    cudaMalloc(&d_a, sizeof(double) * n);
    cudaMalloc(&d_b, sizeof(double) * n);
    cudaMemcpy(d_a, h_a, sizeof(double) * n, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, sizeof(double) * n, cudaMemcpyHostToDevice);

    double *d_tmp;
    cudaMalloc(&d_tmp, sizeof(double) * n);

    for (int i = 0; i < n; i++)
    {
        cudaMemset(d_tmp, sizeof(double) * n, 0);
        l_trans<<<ceil(n / 128), 128>>>(d_a, d_tmp, n, i);
        sum<<<ceil(n / 128), 128>>>(d_b, d_tmp, n);
    }
    cudaMemcpy(h_b, d_b, sizeof(double), cudaMemcpyDeviceToHost);
    // std::cout << h_b[0] << std::endl;
    double result = h_b[0];
    free(h_b);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_tmp);
    return result;    
}

int main(void)
{
    double *h_a;
    int n = 50000;
    h_a = (double *)malloc(sizeof(double) * n);
    for (int i = 0; i < n; i++)
    {
        h_a[i] = i + 1;
    }

    std::cout << sum(h_a, n) << std::endl;

}