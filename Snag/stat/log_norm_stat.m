function out=log_norm_stat(in,M)
% log-normal statistics
%
%   in   data
%   M    number of bins (def sqr(n))

% Snag Version 2.0 - April 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out.n0=length(in);
ii=find(in > 0);
in=in(ii);
N=length(in);
out.N=N;

IN=log10(in);
out.IN=IN;
if ~exist('M','var')
    M=floor(sqrt(N));
end

[his,bins]=hist(IN,M);

MEA=mean(IN);
SD=std(IN);

out.his=his;
out.bins=bins;
out.MEA=MEA;
out.SD=SD;
maxhis=max(his);
gaus=normpdf(bins,MEA,SD);
maxg=max(gaus);
out.gaus=gaus*maxhis/maxg;

figure,semilogy(bins,his),grid on
hold on,semilogy(bins,out.gaus,'r')