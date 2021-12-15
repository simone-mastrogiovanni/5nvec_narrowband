function segs=select_powsegs(gin,lseg,sel)
% SELECT_STATSEGS  selects segments on power basis
%
%   gin     input gd or arrays
%   lseg    segments length
%   sel     selection [min max]
%
%   segs    binary selection

% Version 2.0 - January 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~isnumeric(gin)
    gin=y_gd(gin);
end

N=length(gin);
n=floor(N/lseg);

pows=zeros(1,n);
ii=0;

for i = 1:lseg:N
    ii=ii+1;
    pows(ii)=sum(abs(gin(i:i+lseg-1)).^2)/lseg;
end

if ~exist('sel','var')
    i=find(pows);
    pows1=pows(i);

    pows1=log(pows1);

    msgbox('Select min and max value')
    pause(1)
    [h1,x1]=hist(pows1,200);
    figure,plot(exp(x1),h1),grid on
    [sel,y]=ginput(2);
end

sel
segs=gin*0;
ii=0;

for i = 1:lseg:N
    ii=ii+1;
    if pows(ii) > sel(1) && pows(ii) < sel(2)
        segs(i:i+lseg-1)=1;
    end
end

figure,plot(segs),grid on,ylim([0 1.1]);

