function [wpm,wsp]=peakmap_wiener(pm,excl,typ)
% "wienerization" - substitution of amplitude with a wiener weight - of a peakmap
%
%  wpm=peakmap_wiener(pm,excl,typ)
%
%  pm      peakmap created by read_peakman 
%  excl    limit on the median value (if 0 -> 2/3)
%  typ     'noise' (default) or a source structure or a radiation pattern
%
%  for frequency corrected data, see peak_correction

% Version 2.0 - October 2013
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('excl','var')
    excl=2/3;
end
if excl == 0
    excl=2/3;
end
wpm=y_gd2(pm);
cont=cont_gd2(pm);
f1=x2_gd2(pm);
gsp=cont.gsp;
f2=x2_gd2(gsp);
sp=y_gd2(gsp);
[n1,n2]=size(sp);
m=median(sp);
w=sp*0;

for i = 1:n2
    sp1=sp(:,i);
    ii=find(sp1 < excl*m(i));
    sp1(ii)=0;
    ii=find(sp1);
    sp1=1./sp1(ii);
    w(ii,i)=sp1/mean(sp1);
end

for j = 1:length(f1)
    ii=find(wpm(:,j));
    [m,jj]=min(abs(f1(j)-f2));
    wpm(ii)=w(ii,jj);
end

wpm=edit_gd2(pm,'y',wpm);

wsp=gsp;
wsp=edit_gd2(wsp,'y',w);