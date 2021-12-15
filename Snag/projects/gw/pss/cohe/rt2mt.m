function mt=rt2mt(gm,rt,ic)
% RT2MT  real time to modified time
%
%      mt=rt2mt(gm,rt)
%
%  gm   modified time gd (with cont.time)
%  rt   real time (mjd or samples)
%  ic   = 0 -> mjd (default), otherwise samples

if ~exist('ic','var')
    ic=0;
end

dt=dx_gd(gm);
cont=cont_gd(gm);
t0=cont.t0;
t=round((cont.time(1,:)-t0)/dt)+1;
dmt=cont.time(2,:);
mt=rt*0;
ntab=length(t);

if ic == 0
    rt=round((rt-t0)/dt)+1;
end

jj=1;

for i = 1:length(rt)
    for j = jj:ntab
    if rt(i) < t(j)
        jj=j;
    else
        delt=dmt(j)/dt;
        mt(i)=round(rt(i)-delt);
        break
    end
    end
end
end
