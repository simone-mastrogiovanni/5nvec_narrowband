function stat_logfev(t,f,d,a,cr,frmin,frmax,dfr)
%STAT_LOGFEV statistical analysis of the frequency lines of the sfdb log files
%
%    stat_logfev(t,f,d,a,cr,frmin,frmax,dfr)
%
%    t,f,d,a,cr        time, frequency, length, amplitude and CR of the peaks
%                       (d=0 for steps)
%    frmin,frmax,dfr   frequency histogram parameters
%
%  To read the logfiles, >> [t f d a cr out]=read_logfev;

[i1 j1]=find(d == 0);

disp(sprintf(' %d steps and %d peaks ',length(j1),length(t)-length(j1)));

t1=t(j1);
f1=f(j1);
a1=a(j1);
cr1=cr(j1);

[i1 j1]=find(d > 0);

t=t(j1);
f=f(j1);
a=a(j1);
cr=cr(j1);

x=frmin:dfr:frmax;

h=hist(f,x);
figure
plot(x,h),grid on
gh=gd(h);
gh=edit_gd(gh,'dx',0.1);
hi=gd_histoint(gh,1000,'log');
[xout,b]=hist_sort(x,h,1000);
i=1:length(b);
A=[i' xout' b'];
par.fil='peaktable.dat';
snag_table(A,par);

h=hist(f1,x);
figure
plot(x,h),grid on
gh=gd(h);
gh=edit_gd(gh,'dx',0.1);
hi=gd_histoint(gh,1000,'log');
[xout,b]=hist_sort(x,h,1000);
i=1:length(b);
A=[i' xout' b'];
par.fil='steptable.dat';
snag_table(A,par);