function gdout=gd_matfilt(gdin,shape,dt,init)
%GD_MATFILT  matched filter
%
%      gdout=gd_matfilt(gdin,shape,dt,init)
%
%   gdin     input GD; it is supposed that the data are already wiener-filtered
%   shape    waveform; it can be an array or a GD
%   dt       if the ahape is not a GD, dt is its sampling time
%   init     if the ahape is not a GD, init is the time of the first sample

% Version 2.0 - February 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if isobject(shape)
    dt=dx_gd(shape);
    init=ini_gd(shape);
    shape=y_gd(shape);
end

nin=n_gd(gdin);
dtin=dx_gd(gdin);

nd=round(init/dtin);

ls=length(shape);
t=(0:ls-1)*dt;
t1=0:dtin:(ls-1)*dt;
shape=spline(t,shape,t1);
ls=length(shape);
m=max(abs(shape));
shape=shape/m;

shape(ls+1:nin)=0;
shape=fft(shape);
shape=create_frfilt(conj(shape));
mm=sum(abs(shape).^2)/nin
shape=shape/mm; 

x=y_gd(gdin);
ini=ini_gd(gdin);
x=fft(x);
x=ifft(x.*shape.');
x(1:ls)=0;
x(nin-ls+1:nin)=0;
x=rota(x,nd);

gdout=edit_gd(gdin,'y',real(x),'capt','output of matched filter');
