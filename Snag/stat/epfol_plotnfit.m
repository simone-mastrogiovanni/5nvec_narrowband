function fit=epfol_plotnfit(gin,nh)
% epfol_plotnfit plot and fit for epoch folding 
%
%    gin   epoch folding gd or array
%    nh    number of harmonics (def 4)

if isnumeric(gin)
    dt=1;
    n=length(gin);
    y=gin;
    icgd=0;
else
    dt=dx_gd(gin);
    n=n_gd(gin);
    y=y_gd(gin);
    icgd=1;
end

per=n*dt;
x=0:dt:per;

f=fft(y);
f(nh+2:n)=0;
f(n:-1:n-nh+1)=conj(f(2:nh+1));
fit=ifft(f);
fit1=[fit; fit(1)];
y=[y; y(1)];

figure,plot(x,y),hold on,plot(x,fit1,'r'),grid on
xlim([0 per])