function f=logabs_pdf(z,amp,typ)
% LOGABS_PDF  distribution of the logarithm of the absolute value
%
%  z     abscissas
%  amp   sigma (gaussian) or mu (exponential)
%  typ   1 -> gaussian, 2 -> exponential

% Version 2.0 - June 2008
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

switch typ
    case 1
        f=sqrt(2/pi)*exp(z-log(amp)).*exp(-exp(2*(z-log(amp)))/2);
    case 2
        f=exp(z-log(amp)).*exp(-exp(z-log(amp)));
end