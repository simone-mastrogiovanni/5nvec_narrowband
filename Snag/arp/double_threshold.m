function out=double_threshold(in,th1,th2,amp)
% double threshold function
%
%   out=double_threshold(in,th1,th2,amp)
%
%   in     input array or gd or gd2
%   th1    exclusion threshold
%   th2    saturation threshold
%   amp    max amplitude (def 1)

% Version 2.0 - February 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('amp','var')
    amp=1/th2;
else
    amp=amp/th2;
end
icgd=0;
if isa(in,'gd')
    in1=in;
    in=y_gd(in);
    icgd=2;
end
if isa(in,'gd2')
    in1=in;
    in=y_gd(in);
    icgd=1;
end

ii1=find(in < th1);
ii2=find(in > th2);
in(ii1)=0;
in(ii2)=th2;
out=in.*amp;

if icgd == 1
    out=edit_gd(in1,'y',out);
end
if icgd == 2
    out=edit_gd2(in1,'y',out);
end