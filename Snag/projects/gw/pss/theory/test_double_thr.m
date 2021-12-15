function out=test_double_thr(N,sig,th1,th2,icvar)
% tests the hough with the double_threshold hough
%
%    N        num. of samples
%    sig      linear signal amplitude
%    th1,th2  2 thresholds
%    icvar    signal time variation (0 n0, 1 sin, 2 2+sin)

if ~exist('icvar','var')
    icvar=0;
end
x=(randn(1,N)+1j*randn(1,N))/sqrt(2);
switch icvar
    case 0
        xs=x+sig;
    case 1
        xs=x+sig*sin(0.2341*pi*(1:N));
    case 2
        xs=x+sig*(sin(0.2341*pi*(1:N))+1);
end

z=abs(x).^2;
zs=abs(xs).^2;
n1=rota(z,1);
n2=rota(z,2);
iiz=find(z > n1 & z > n2);
iizs=find(zs > n1 & zs > n2);

Z=double_threshold(z,th1,th2);
ZS=double_threshold(zs,th1,th2);
iiZ=find(Z > 0);
iiZS=find(ZS > 0);

th=2.5;
Y=double_threshold(z,th,th);
YS=double_threshold(zs,th,th);
iiY=find(Y > 0);
iiYS=find(YS > 0);

out.th1=th1;
out.th2=th2;
out.th=th;
out.N=N;

out.n_z=length(iiz);  % noise spectral peaks
out.m_z=mean(z(iiz));
out.s_z=std(z(iiz));
out.p_z=out.n_z/N;
out.n_zs=length(iizs);  % spectral peaks with signal
out.m_zs=mean(zs(iizs));
out.s_zs=std(zs(iizs));
out.p_zs=out.n_zs/N;
out.cr_z=sqrt(N)*(out.p_zs-out.p_z)/sqrt(out.p_z*(1-out.p_z));
out.n_Z=length(iiZ);   % noise spectral peaks that pass th1
out.m_Z=mean(Z(iiZ));
out.s_Z=std(Z(iiZ));
out.p_Z=out.n_Z/N;
out.n_ZS=length(iiZS);   % noise spectral peaks with signal that pass th1
out.m_ZS=mean(ZS(iiZS));
out.s_ZS=std(ZS(iiZS));
out.p_ZS=out.n_ZS/N;
out.cr_Z=sqrt(N)*(out.p_ZS-out.p_Z)/sqrt(out.p_Z*(1-out.p_Z));
out.n_Y=length(iiY);  % noise spectral peaks that pass th = 2.5 (single threshold)
out.m_Y=mean(Y(iiY));
out.s_Y=std(Y(iiY));
out.p_Y=out.n_Y/N;
out.n_YS=length(iiYS);
out.m_YS=mean(YS(iiYS));
out.s_YS=std(YS(iiYS));
out.p_YS=out.n_YS/N;
out.cr_Y=sqrt(N)*(out.p_YS-out.p_Y)/sqrt(out.p_Y*(1-out.p_Y));

out.gain_cr=out.cr_Z/out.cr_Y;
out.loss_n=out.n_Z/out.n_Y;