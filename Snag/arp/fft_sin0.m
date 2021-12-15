function out=fft_sin0(n,wind,dt,amp,freq,fi)
% FFT_SIN  creates a sum of sines by fft
%
%         Persistent version
%
%     out=fft_sin0(n,dt,amp,freq,fi)
%
%  n      length of out
%  wind   windows ('bartlett','hanning','flatcos','no')
%  dt     sampling time
%  amp
%  freq
%  fi     phase (degrees)

% Version 2.0 - August 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

persistent f1

N0=1024;
a16=16;
N1=N0*a16; 

if n == 0
    f1=[];
end

if isempty(f1)
    disp('Compute look-up table')
    dt0=1/N0;
    clear j

    fr0=N0/4;
    y1=zeros(1,N1);
    y1(1:N0)=exp(j*(0:N0-1)*dt0*2*pi*fr0).*pswindow(wind,N0); 
    f1=fft(y1);
    f1=f1(fr0*a16+1-10*a16:fr0*a16+1+10*a16)/sqrt(sum(abs(f1).^2)/a16);
    figure,semilogy(abs(f1)),grid on
    figure,plot(f1),grid on
else
    disp('Look-up table not computed')
end

out=zeros(1,n); %length(f1),% plot(fft(f1))

N=length(amp);

for i = 1:N
    in0=freq(i)*(dt*n);
    dfr=in0-round(in0);
    in0=round(in0);% in0,dfr,a16
    in1=round((dfr+10)*a16);
    in1a=in1-9*a16;
    in1b=in1+9*a16;% size(f1)
    f0=f1(in1a:a16:in1b); %size(f0),in0,figure,semilogy(abs(f0))
    fir=exp(j*fi(i)*pi/180);
    out(in0-9:in0+9)=out(in0-9:in0+9)+f0*n*amp(i)*fir;
end

out=ifft(out);