function hbsd=bsd_resenh(in,enh)
% bsd or array resolution enhancement
%
%   in    input bsd or array
%   enh   (>1) resolution enhancement 

% Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S.Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if enh <= 1
    disp(' *** ERROR enhancement <= 1')
    return
end

if isnumeric(in)
    n=length(in);
    dt=1;
    y=in;
else
    n=n_gd(in);
    dt=dx_gd(in);
    cont=cont_gd(in);oper=struct();
    
    oper.op='bsd_resenh';
    if isfield(cont,'oper')
        oper.oper=cont.oper;
    end
    oper.enh=enh;

    cont.oper=oper;

    y=y_gd(in);
end

y=fft(y);

N=ceil(n*enh/4)*4;
ENH=N/n;
Y=zeros(1,N);
Y(1:n)=y;
Y=ifft(Y)*ENH;

if isnumeric(in)
    hbsd=Y;
else
    hbsd=edit_gd(in,'y',Y,'dx',dt/ENH);
end
