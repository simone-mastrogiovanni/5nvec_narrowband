function F=gd_cbode(b,a,N,minfr,maxfr,icshow)
%GD_CBODE  frequency response of a continuos time filter
%
%   b,a       filter coefficients as 
%             y(n) = b(1)*x + b(2)*dx/dt + ... + b(nb+1)*d^nb x/dt^nb
%                    - a(2)*dy/dt - ... - a(na+1)*d^nb y/dt^nb
%
%   N         number of points
%   minfr     minimum frequency
%   maxfr     maximum frequency
%   icshow    >0 -> show plots; 1 log freq, 2 lin freq, 3 lin freq and gain

% Version 2.0 - August 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

df=(maxfr-minfr)/(N-1);

na=length(a)-1;
nb=length(b)-1;
    
fr=minfr+(0:N-1)*df;
s=j*fr*2*pi;

A=0*s+1;
for i = 1:na
    A=A+a(i+1).*s.^i;
end

B=0*s+b(1);
for i = 1:nb
    B=B+b(i+1).*s.^i;
end

F=B./A;

if icshow > 0
    conv=180/pi;
    figure
    
    switch icshow
        case 1
            loglog(fr(2:N),abs(F(2:N))); grid on, title('Gain')
            figure
            semilogx(fr(2:N),angle(F(2:N))*conv); grid on, title('Phase')
        case 2
            semilogy(fr,abs(F)); grid on, title('Gain')
            figure
            plot(fr,angle(F)*conv); grid on, title('Phase')
        case 3
            plot(fr,abs(F)); grid on, title('Gain')
            figure
            plot(fr,angle(F)*conv); grid on, title('Phase')
    end
end

F=gd(F);
F=edit_gd(F,'dx',df);