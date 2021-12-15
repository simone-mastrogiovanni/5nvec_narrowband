function gdcell=multi_extr(gin,fr,ic)
% MULTI_EXTR  extraction of data bands
%
%       gdcell=multi_extr(gin,fr,ic)
%
%    gin   input data (gd or array)
%    fr    (n,2) [frin1 frfin1; frin2 frfin2; ...]; frin possibly negative in the complex case
%    ic    possible control variable

% Version 2.0 - August 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('ic','var')
    ic=0;
end

if isa(gin,'gd')
    dt=dx_gd(gin);
    y=y_gd(gin);
    icgd=1;
else
    dt=1;
    y=gin;
    icgd=0;
end

y=y(:);
n=length(y);
DT=n*dt;
dfr=1/DT;
ii=find(y==0);

if ~isreal(y)
    iccompl=1;
else
    iccompl=0;
    if floor(n/2)*2 ~= n
        n=n-1;
        y=y(1:n);
        disp('Odd data, one cut')
    end
end

y=fft(y);
[nband i]=size(fr);
nw=5;

for i = 1:nband
    n1=round(fr(i,1)/dfr)+1;
    n2=round(fr(i,2)/dfr)+1;
    n10=max(1,n1-nw);
    nw1=n1-n10;
    n20=min(n,n2+nw);
    nw2=n20-n2;
    y1=y*0;
    if fr(i,1) >= 0
        y1(n1:n2)=y(n1:n2);
        y1(n10:n1-1)=y(n10:n1-1).*(1:nw1)'/(nw1+1);
        y1(n2+1:n20)=y(n2+1:n20).*(nw2:-1:1)'/(nw2+1);
        if iccompl == 0
            y1(n:-1:n/2+2)=conj(y1(2:n/2));
        end
    else
        y1(n1:n)=y(n1:n);
        y1(1:n2)=y(1:n2);
        y1(n10:n1-1)=y(n10:n1-1).*(1:nw)'/(nw+1);
        y1(n2+1:n2+nw)=y(n2+1:n2+nw).*(nw:-1:1)'/(nw+1);
    end
    y1=ifft(y1);
    y1(ii)=0;
    if icgd == 1
        y1=edit_gd(gin,'y',y1);
    end
    gdcell{i}=y1;
end