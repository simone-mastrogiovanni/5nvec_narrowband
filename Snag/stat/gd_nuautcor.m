function [autc tautc]=gd_nuautcor(gin,N,dt,itv,scale)
% gd_nuautcor  autocorrelation for non-uniformly sampled data
%               (for time sorted data)
%
%      autc=gd_nuautcor(gin,N,dt)
%
%   N       number of bins; if N=[N1 N2] range in dt (N1,N2 non negative)
%   dt      bin width
%   itv     time interval for a datum; or itv=[itv delay]; def 0
%   scale   scale for abscissa (e.g 86400 day -> s); def 1

if length(N) == 2
    N1=N(1);
    N2=N(2);
    N=N2-N1+1;
else
    N1=0;
    N2=N-1;
end

if ~exist('itv','var')
    itv=[0 0];
end

if length(itv) == 1
    itv=[itv 0];
end

if ~exist('scale','var')
    scale=1;
end

delay=itv(2);
itv=itv(1);

t=x_gd(gin)*scale;
y=y_gd(gin);
n=n_gd(gin);

autc=zeros(1,N);
ia=autc;

for i = 1:n
    for j = i:n
        DT=t(j)-t(i)+delay;
        iDT1=round(DT/dt);
        iDT2=round((DT+itv)/dt);
        if iDT2 > N2
            break
        end
        if iDT1 < N1
            continue
        end
        iDT=iDT1:iDT2;%iDT2-iDT1%iDT=iDT1;
        autc(iDT+1)=autc(iDT+1)+y(i)*conj(y(j));
        ia(iDT+1)=ia(iDT+1)+1;
    end
end

ii=find(ia);
autc(ii)=autc(ii)./ia(ii);

autc=gd(autc);
autc=edit_gd(autc,'ini',N1*dt,'dx',dt,'capt',['Autocorrelation of ' capt_gd(gin)]);

tautc=autc*0+ia';