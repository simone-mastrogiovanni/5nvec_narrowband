function [alpha delta]=deg2hour(alph1,delt1)
% converts decimal deg in standard h m s and deg m s format
%
%     [alpha delta]=deg2hour(alph1,delt1)
%
%  alph1,delt1   values in deg
%
%  alpha(3)      h m s
%  delta(3)      d m s (if exist)

if alph1 < 0
    alph1=alph1+360;
end
h=abs(alph1/15);
a1=floor(h);
a2=floor((h-a1)*60);
a3=(h-a1-a2/60)*3600;
alpha=[a1 a2 a3];

if exist('delt1','var')
    d0=sign(delt1);
    d1=floor(abs(delt1));
    d2=floor((abs(delt1)-d1)*60);
    d3=(abs(delt1)-d1-d2/60)*3600;
    d1=d0*d1;
    delta=[d1 d2 d3];
end
    