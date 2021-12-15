function lines=ligo_readlines(fil)
% reads lines ligo files (in csv format)
%
%    fil    lines Ligo file (in csv format)
%
%  typical file: O2H1lines.csv

% Column 1 - frequency spacing (Hz) of comb (or frequency of single line)
% Column 2 - comb type (0 - singlet, 1 - comb with fixed width, 2 - comb with scaling width)
% Column 3 - frequency offset of 1st visible harmonic (Hz)
% Column 4 - index of first visible harmonic
% Column 5 - index of last visible harmonic
% Column 6 - width of left band (Hz)
% Column 7 - width of right band (Hz)
%
% For fixed-width combs, veto the band:
% [offset+index*spacing-leftwidth, offset+index*spacing+rightwidth]
% For scaling-width combs, veto the band:
% [offset+index*spacing-index*leftwidth, offset+index*spacing+index*rightwidth]

% Snag Version 2.0 - November 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

LT=readtable(fil);

nams=LT.Properties.VariableNames;

LTfr0=nams{1};
LTtyp=nams{2};
LTharm1=nams{4};
LTharm2=nams{5};
LTdfr1=nams{6};
LTdfr2=nams{7};

eval(['fr0=LT.' LTfr0 ';'])
eval(['typ=LT.' LTtyp ';'])
eval(['harm1=LT.' LTharm1 ';'])
eval(['harm2=LT.' LTharm2 ';'])
eval(['dfr1=LT.' LTdfr1 ';'])
eval(['dfr2=LT.' LTdfr2 ';'])

ii=find(typ == 0);
n1=length(ii);

lines(2,:)=fr0(ii)+dfr2(ii);
lines(1,:)=fr0(ii)-dfr1(ii);

ii=find(typ == 2);
j=0;

for l=1:size(ii)
    for i = ii(l)
        kk=harm1(i):harm2(i);
        n2=length(kk);
        lines(2,n1+j+(1:n2))=kk*(fr0(i)+dfr2(i));
        lines(1,n1+j+(1:n2))=kk*(fr0(i)-dfr1(i));
        j=j+n2;
    end
end