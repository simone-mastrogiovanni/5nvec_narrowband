function [out deld]=rough_clean(in,miny,maxy,nw)
% ROUGH_CLEAN rough cleaning of array or gd
%
%    [out deld]=rough_clean(in,miny,maxy,Dt)
%
%   in           input array or gd
%   miny,maxy    permitted interval
%   nw           window (in samples; def 4), negative no plot
%
%   out          cleaned gd
%   deld         mask (1 keep, 0 nullify)

% Version 2.0 - December 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=in;
icgd=0;
if isa(in,'gd')
    icgd=1;
    in=y_gd(in);
end
if ~exist('nw','var')
    nw=4;
end
if nw < 0
    nw=-nw;
    icpl=0;
else
    icpl=1;
    figure,plot(real(in),'r'),hold on,grid on
end

n=length(in);
deld=zeros(1,n);
i= real(in) > maxy | real(in) < miny | imag(in) > maxy | imag(in) < miny;
deld(i)=1;
b=cos((0:nw)*pi/(2*(nw+1)));
deld=filtfilt(b,1,deld)/3;
i=deld>1;
deld(i)=1;
deld=1-deld;
in=in.*deld';
if icgd == 1
    out=edit_gd(out,'y',in,'capt',['cleaned ' capt_gd(out)]);
else
    out=in;
end

if icpl > 0
    plot(real(out));
    title('Data selection')
end