function [pmf np1]=pmf_from_prep_1(np,sp,t,f,fr)
%
%    [pmf np1]=pmf_from_prep_1(np,sp,t,f,fr)
%
%   np,sp,t,f   data from pmf_prepare
%   fr          [minfr maxfr]
%
% Obtain input data from pmf_prep save files

% Version 2.0 - October 2012
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

minfr=fr(1);
maxfr=fr(2);
ini=find(f >= minfr,1,'first');
fin=find(f <= maxfr,1,'last');

[nt,nf]=size(np);
pmf=zeros(nt,1);
np1=pmf;

for i = 1:nt
    np1(i)=sum(np(i,ini:fin));
    if np1(i) > 0
        pmf(i)=sum(sp(i,ini:fin))/np1(i);
    end
end

ii=find(np1);
pmf=pmf(ii);
np1=np1(ii);
t=t(ii);

pmf=gd(pmf);
pmf=edit_gd(pmf,'x',t);