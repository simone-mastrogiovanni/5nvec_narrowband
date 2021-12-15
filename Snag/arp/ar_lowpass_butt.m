function ya=ar_lowpass_butt(in,fr,norm)
% AR_LOWPASS  low-pass of input, various normalizations with Butterwortg
%             8-order filter
%
%    ya=ar_lowpass_cheb(in,tau,norm)
%
%   in      input data (array or gd)
%   fr      cut frequency
%   norm    normalization type (0 -> no, 1 -> on s.d,, 2 -> on mean

% Version 2.0 - January 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

icobj=0;
if isobject(in)
    dt=dx_gd(in);
    ya=y_gd(in);
    icobj=1;
else
    dt=1;
    ya=in;
end
ya=ya(:);
if ~exist('norm','var')
    norm=2;
end

W=fr*dt;
N=length(ya);

[b,a]=butter(8,W);

ya=filter(b,a,ya);
ya0=filter(b,a,ones(N,1));

if norm == 1
    ya=ya./sqrt(ya0/2);
elseif norm == 2
    ya=ya./ya0;
end
        
if icobj == 1
    ya=edit_gd(in,'y',ya,'capt',['low-pass of ' capt_gd(in)]);
end



