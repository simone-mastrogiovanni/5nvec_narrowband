function f=detect_prob(fap,fap0,signal)
% DETECT_PROB  detection probability at fixed fap
%
%     f=detect_prob(fap,fap0,signal)
%
%   fap      f.a.p. gd
%   fap0     fixed f.a.p value
%   signal   array with the signals

% Version 2.0 - January 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

na=nargout;

n=n_gd(fap);
ini=ini_gd(fap);
dx=dx_gd(fap);
y=y_gd(fap);

ns0=length(signal);

i0=min(find(y<fap0));
if isempty(i0)
    i0=length(y);
    fap0=y(i0)
    disp(' *** fap0 substituted')
end
isig=round(signal/dx);
ii=i0-isig;
jj=find(ii>0);
ii=ii(jj);
signal=signal(jj);
f=y(ii);

if na == 0
    semilogy(signal,f),grid on
else
    f=gd(f);
    f=edit_gd(f,'x',signal,'capt','detection probabiity');
end
