function out=fd_delay(in,dt,delay,basefr)
%
%  in      input data
%  dt      sampling time
%  delay   delay
%  basefr  base frequency

if ~exist('basefr','var')
    basefr=0;
end

len=length(in);
fr=(0:len-1)/(len*dt)+basefr;
out=fft(in).*exp(-1i*fr*2*pi*delay);
out=ifft(out);
if isreal(in)
    out=real(out);
end

x=(0:len-1)*dt;
figure,plot(x,in),grid on,hold on,plot(x,out,'r')

