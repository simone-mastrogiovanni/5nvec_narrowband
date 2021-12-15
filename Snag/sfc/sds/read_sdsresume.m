function mp=read_sdsresume(filnam)
% READ_SDSRESUME  reads an sds resume (sds file produced by sds_resume)
%
%    filnam   the file (interactive search if absent)
%
%    mp       output mp

% Version 2.0 - October 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('filnam','var')
    filnam=selfile('');
end

sds_=sds_open(filnam);

len=sds_.len;
dt=sds_.dt;
t0=sds_.t0;
% [tinit cont]=check_mjd(t0,-1);
mp.n=len;
mp.dx=dt;
nm=round(60/dt);
minu=sprintf('%d',nm);

answ=inputdlg('Mean every ?','Number of samples to average',1,{minu});
nm=eval(answ{1});

A=fread(sds_.fid,[sds_.nch,sds_.len],'float');size(A)
newlen=floor(len/nm)
A=mean_every(A,2,nm);size(A)

fprintf(' %d samples; dt = %f \n',len,dt);
figure

for i = 1:sds_.nch
    if i > 1
        [tcol colstr]=rotcol(i-1);
        fprintf(' %10s ch %d  ->  %s \n',colstr,i-1,sds_.ch{i});
        mp.ch(i-1).name=sds_.ch{i};
        mp.ch(i-1).y=A(i,:);%size(mp.ch(i-1).y),size(mp.x)
        semilogy(mp.x,mp.ch(i-1).y,'.','color',tcol),hold on,semilogy(mp.x,mp.ch(i-1).y,'color',tcol)
    else
        mp.x=A(1,:);
        fprintf(' ch %d  ->  %s \n',i-1,sds_.ch{i});
    end
end

grid on