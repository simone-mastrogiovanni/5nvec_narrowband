function [autc tautc]=gd_nucrcor(gin1,gin2,tim,scale)
% gd_nucrcor  cross-correlation for non-uniformly sampled data
%               (for time sorted data)
%
%      autc=gd_nucrcor(gin1,gin2,N,dt,itv,scale)
%
%   gin1,gin2   input gds
%   tim         output time [min max dt]
%   scale       scale conversion for abscissa (e.g 86400 day -> s); def 1

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('scale','var')
    scale=1;
end

t1=x_gd(gin1)*scale;
y1=y_gd(gin1);
y1=(y1-mean(y1))/std(y1);
n1=n_gd(gin1);

t2=x_gd(gin2)*scale;
y2=y_gd(gin2);
y2=(y2-mean(y2))/std(y2);
n2=n_gd(gin2);

tin=tim(1);
tfi=tim(2);
dt=tim(3);
N=round((tfi-tin)/dt)+1;

autc=zeros(1,N);
ia=autc;
jj=1;

for i = 1:n1
    for j = jj:n2
        DT=t2(j)-t1(i);
        if DT < tin
            jj=j;
            continue
        end
        if DT > tfi
            break
        end
        iDT=round((DT-tin)/dt)+1;
        autc(iDT)=autc(iDT)+y1(i)*conj(y2(j));
        ia(iDT)=ia(iDT)+1;
    end
end

ii=find(ia);
autc(ii)=autc(ii)./ia(ii);

autc=gd(autc);
autc=edit_gd(autc,'ini',tin,'dx',dt,'capt',['Crosscorrelation of ' capt_gd(gin1) ' and ' capt_gd(gin2)]);

tautc=autc*0+ia';