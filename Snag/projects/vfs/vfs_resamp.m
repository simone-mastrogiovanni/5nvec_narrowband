function gout=vfs_resamp(gin,pos)
%
%
% limit: only jumps of one sample

% Version 2.0 - July 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Ornella J. Piccinni, Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

dt=dx_gd(gin);
n=n_gd(gin);
yin=y_gd(gin);

ii=round(pos/dt);
ii0=ii(1);
ii=ii-ii0;
jj=diff(ii);

kk=find(jj);
nkk=length(kk);
dn=jj(n-1);
n1=n+dn;
y=zeros(n1,1);
i1=1;
j1=1;

for i = 1:nkk
    y(j1:kk(i))=yin(i1:kk(i));
    if jj(kk(i)) > 1
        i1=kk(i)-1;
        j1=kk(i);
    else
        i1=kk(i)+2;
        y(kk(i)+1)=y(kk(i));
        j1=kk(i)+2;
    end
end

gout=gd(y);
gout=edit_gd(gout,'dx',dt);



% 
% function [out iout]=strobo(x,tt,dtout,toff)
% 
% tt=tt/dtout;
% tt1=floor(tt);
% ii=find(diff(tt1));
% out=x(ii+1);
% iout=round(tt(ii(1))*dtout-toff);
% 