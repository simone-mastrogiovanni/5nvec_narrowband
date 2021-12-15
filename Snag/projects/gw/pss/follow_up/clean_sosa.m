function cl_sosa=clean_sosa(sosa,thresh)

ysosa=y_gd(sosa);
x=(0:200)*thresh/200;
h=hist(abs(ysosa),x);
figure,stairs(x,h),grid on
jj=find(abs(ysosa)>thresh);
ysosa(jj)=0;
cl_sosa=edit_gd(sosa,'y',ysosa);
