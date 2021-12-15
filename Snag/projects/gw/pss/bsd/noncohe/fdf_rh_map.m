function [map,pars]=fdf_rh_map(tfmap,typ,thr,maxslope,epoch)
% fdf hough or radon map
%
%    tfmap     time-frequency gd2 map
%    typ       type of output map
%    thr       threshold (in fraction: 0 all 1 only the maximum)
%    maxslope  max slope (> 0 ; 0 -> defauult)
%    epoch     any value, 0 beginning, 1 end

% Snag Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

init=ini_gd2(tfmap);
inif=ini2_gd2(tfmap);
if init < 66000 && init > 50000
    dt=dx_gd2(tfmap)*86400;
else
    dt=dx_gd2(tfmap);
end
df=dx2_gd2(tfmap);
n=n_gd2(tfmap);
nf=m_gd2(tfmap);
nt=n/nf;
DT=nt*dt;
DF=nf*df;
pars.DT=DT;
pars.DF=DF;
dtepoch=epoch*DT;

% tfmap=edit_gd2(tfmap,'ini',0,'dx',dt,'ini2',0);
tfmap=edit_gd2(tfmap,'ini',0,'dx',dt,'ini2',0);

y=y_gd2(tfmap);
thr1=prctile(y(:),thr(1)*100);

np=500;
slope=maxslope;
if slope == 0
    slope=3*DF/DT;
end
inip=-slope;
dp=-2*inip/(np-1);
nq=500;
iniq=-DF;
dq=2*DF/nq;
switch typ
    case 0
        radlev=[0 thr1];
    case 1
        radlev=[1 thr1];
    case 2
        d=thr(2);
        s=thr(3);
        radlev=[2 d s];
end
pars.mappars=[np,nq,inip,dp,iniq,dq,radlev];
[map,par]=radon_hough(tfmap,np,nq,inip,dp,iniq,dq,radlev);
map=edit_gd2(map,'ini2',iniq+inif);
map=map.';

y=y_gd2(map);
[row,col]=find(y == max(y(:)));
x=x_gd2(map);
f0=x(row);
x2=x2_gd2(map);
sd=x2(col);
f=f0+sd*dtepoch;size(f),size(sd),size(y(row,col))
% fprintf('  f = %f  sd = %e  peak = %f \n',f,sd,y(row,col));

pars.par=par;
pars.dtepoch=dtepoch;
pars.f=f;
pars.sd=sd;
pars.peak=y(row,col);