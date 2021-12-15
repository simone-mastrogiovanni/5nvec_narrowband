function [t_1 a_1 t_2 a_2]=ar_coin(t1,a1,t2,a2,dt)
% AR_COIN array coincidence of events; ts should be in ascending order
%
%     [t_1 a_1 t_2 a_2]=ar_coin(t1,a1,t2,a2,dt)
%
%   t1,t2   times
%   a1,a2   amplitudes
%   dt      time window

% Version 2.0 - August 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n1=length(t1);
n2=length(t2);
n3=1;
ii=0;

for i = 1:n1
    for j = n3:n2
        if t1(i) < t2(j)-dt
            break
        end
        if t1(i) > t2(j)-dt & t1(i) < t2(j)+dt
            ii=ii+1;
            t_1(ii)=t1(i);
            a_1(ii)=a1(i);
            t_2(ii)=t2(j);
            a_2(ii)=a2(j);
            n3=j;
        end
    end
end