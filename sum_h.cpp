#include <iostream>

double sum(double* a, int n)
{
    double result = 0;
    for(int i=0; i < n; i++)
    {
        result += a[i];
    }
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