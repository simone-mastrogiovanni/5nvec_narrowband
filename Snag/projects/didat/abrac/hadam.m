% hadam

n=5;

[pp w]=sb_t_stevol(n,0.5);

H=hadamard(2^n);
h=(w-mean(w))*H;
figure,plot(h),grid on,hold on,plot(h,'r.')
[hh ii]=sort(h,'descend');
figure,plot(hh),grid on
figure,plot(ii),hold on,plot(ii,'r.'),grid on
figure,plot(h,hh),hold on,plot(h,hh,'r.'),grid on
figure,plot(hh,w),hold on,plot(hh,w,'r.'),grid on