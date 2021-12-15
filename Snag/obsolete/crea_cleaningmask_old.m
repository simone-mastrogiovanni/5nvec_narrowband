function mask=crea_cleaningmask_old(peakfr,lwind,thresh)
% CREA_CLEANINGMASK  creates a cleaning mask for peakmaps on the basis of
%                    the peakfr histogram
%
%     crea_cleaningmask_old(peakfr,lwind,thresh1,thresh2)
%
%     peakfr    peakfr gd
%     lwind     half-length of the windows
%     thresh    threshold before filtering (if < 10, on normalized data - typically 1.6181)

pf=y_gd(peakfr);
mm=mean(pf);
if thresh <= 10
    pf=pf/mm;
end
n=length(pf);
x=x_gd(peakfr);

mask=pf>thresh;
mask=fft(mask);
wind=zeros(n,1);
wind(1:1+lwind)=1;
wind(n-wind+1:n)=1;
wind=fft(wind);
mask=mask.*wind;
mask=real(ifft(mask));
figure
plot(x,mask),grid on,hold on
mask=sparse(mask>0.5);
mask=full(mask);
plot(x,mask,'.r')
sss=sum(mask);
disp(sprintf(' Number of cancelled bins: %d/%d ; ratio %f',sss,n,sss/n));

figure
plot(x,pf),grid on,hold on
plot(x,pf.*(1-mask),'r')