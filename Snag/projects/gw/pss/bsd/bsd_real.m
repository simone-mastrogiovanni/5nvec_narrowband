function out=bsd_real(in)
% conversion to real (doubling sampling frequency)
%
%     out=bsd_real(in)

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

y=y_gd(in);
dt=dx_gd(in);
n=n_gd(in);
cont=ccont_gd(in);

oper=struct();
oper.op='bsd_real';
if isfield(cont,'oper')
    oper.oper=cont.oper;
end

cont.oper=oper;

Y=fft(y);
Y(n+1:2*n)=0;
Y(n+2:2*n)=conj(Y(n:-1:2));
Y(1)=0;

y=ifft(Y)*2; % 2 resampling factor

out=edit_gd(in,'y',y,'dx',dt/2);