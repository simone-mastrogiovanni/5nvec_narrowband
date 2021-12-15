function [val coh out his xh]=matfilt_5comp(data,signal,noplot)
% MATFILT_5COMP  computes the matched filter in the 5 components framework
%                and simulates 10000 different realizations from input data
%
%    [val coh his xh]=matfilt_5comp(data,signal)
%
%    data     5 components
%    signal   5 components

% Version 2.0 - May 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('noplot','var')
    noplot=0;
end
data=data(:);
signal=signal(:);
mf=conj(signal)./sum(abs(signal).^2);

out=sum(data.*mf);
val=abs(out).^2
coh=sum(abs(out*signal).^2)./sum(abs(data).^2)

if noplot == 0
    N=10000;
    a=rand(5,N)*2*pi;
    b=zeros(1,N);

    for i = 1:N
        aa=exp(1j*a(:,i));
        d=data.*aa;
        b(i)=abs(sum(d.*mf)).^2;
    end

    [his xh]=hist(b,round(sqrt(N)));

    figure,plot(xh,his),grid on
end