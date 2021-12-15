function F=gd_bode(b,a,N,dt,icshow)
%GD_BODE  frequency response of a filter
%
%   b,a       filter coefficients as (Matlab standard, but a(1)=1)
%             y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                    - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
%
%   N         number of points
%   dt        sampling time
%   icshow    >0 -> show plots; 1 log freq, 2 lin freq, 3 lin freq and gain
%             -1 full band 

% Version 2.0 - August 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fr=1/dt;
if isreal(b) & isreal(a)
    fr=fr*N/(2*(N-1));
end

df=fr/N;

if icshow < 0
    df=1/(N*dt);
end

na=length(a)-1;
nb=length(b)-1;
    
OM=(0:N-1)*df*dt*2*pi;
z=exp(j*OM);

A=0*z+1;
for i = 1:na
    A=A+a(i+1).*z.^(-i);
end

B=0*z+b(1);
for i = 1:nb
    B=B+b(i+1).*z.^(-i);
end

F=B./A;

if icshow > 0 
    fr=OM/(2*pi*dt);
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