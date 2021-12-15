function dy=fpu1(t,y);
N=32;alpha=0.25;
D(N+1)=y(2) -2*y(1)+alpha*((y(2)-y(1))^2-y(1)^2);D(1)=y(N+1);
D(2*N)=y(N-1)-2*y(N)+alpha*(y(N)^2-(y(N)-y(N-1))^2);D(N)=y(2*N);
for I=2:N-1,
D(N+I)=y(I+1)+y(I-1)-2*y(I)+alpha*((y(I+1)-y(I))^2-(y(I)-y(I-1))^2);
D(I)=y(N+I);
end
dy=D';