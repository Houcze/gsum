sum: sum.cu
	nvcc -O3 sum.cu -o sum.exe

sum2: sum2.cu
	nvcc -O3 sum2.cu -o sum2.exe

clean:
	rm -f *.exe

compare_sum: sum.exe sum2.exe
	time ./sum.exe
	time ./sum2.exe