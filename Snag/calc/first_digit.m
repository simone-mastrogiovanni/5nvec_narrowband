function fd=first_digit(n)

n=abs(n);
e10=10.^floor(log10(n));
fd=floor(n./e10);