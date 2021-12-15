function a=ar_lowpass(in,tau,norm)
% AR_LOWPASS  low-pass of input, various normalizations
%
%    a=ar_lowpass(in,tau,norm)
%
%   in      input data (array or gd)
%   tau     tau
%   norm    normalization type (0 -> no, 1 -> on s.d,, 2 -> on mean

% Version 2.0 - December 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

dt=1;
icobj=0;
if isobject(in)
    dt=dx_gd(in);
    a=y_gd(in);
    icobj=1;
else
    dt=1;
    a=in;
end
a=a(:);
if ~exist('norm','var')
    norm=2;
end

w=exp(-dt/tau);
N=length(a);

a=filter(1,[1 -w],a);
a0=filter(1,[1 -w],ones(N,1));

if norm == 1
    a=a./sqrt(a0/2);
elseif norm == 2
    a=a./a0;
end
        
if icobj == 1
    a=edit_gd(in,'y',a,'capt',['low-pass of ' capt_gd(in)]);
end



