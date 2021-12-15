function [out,st,band,pars]=bsd_reshape(in,tab,bandin,t00)
% reshapes a bsd in order to concatenate sub-bands
%    corrects starting sample and starting frequency and length
%
%     [out,band]=bsd_reshape(in,bandin,t00)
%
%   in      input bsd
%   tab     table of the bsds to be concatenated
%   bandin  requested band [frin frfin]
%   t00     requested basic time (optional - def 0 hour of run starting day)
%
%   out     reshaped bsd
%   dfr     frequency quantum
%   band    true band

% Snag Version 2.0 - November 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if isempty(tab)
    out=in;
    dfr=0;
    band=bandin;
    return
end
cont=cont_gd(in);
y=y_gd(in);
nori=n_gd(in);
dtori=dx_gd(in);

st0=1/(bandin(2)-bandin(1));
[st,mult]=int_mult(st0,dtori); % output sampling time
pars.nori=nori;
pars.dtori=dtori;
pars.st0=st0;
pars.st=st;
pars.mult=mult;

% correcting sampling time and starting frequency

if isstruct(tab)
    n=length(tab);

    for i = 1:n
        t_ini(i)=tab(i).t_ini;
        t_fin(i)=tab(i).t_fin;
    end
else
    t_ini=tab.t_ini;
    t_fin=tab.t_fin;
end

nfil=round(diff_mjd(t_ini,t_fin)/dtori);
nnn=max(nfil)+mult-1;

dfr0=1/(dtori*nnn);
% dfr=rat_num(dfr0,1);
N=ceil(nnn/mult)*mult;
dfr=1/(N*dtori);
band(1)=floor(bandin(1)/dfr)*dfr+dfr;
band(2)=band(1)+1/st; 
pars.nnn=nnn;
pars.N=N;
pars.dfr0=dfr0;
pars.dfr=dfr;

fprintf(' %d added, %e approx  dfr = %e \n',N-nnn,N-1/(dfr*dtori),dfr)
cont.dfr=dfr;

y1(1:N)=0;

% correcting starting sample

eval(['runstr=' cont.run ';'])
t0ori=cont.t0;
cont.t0_ori=t0ori;

if ~exist('t00','var')
    inirun0=floor(runstr.ini);
else
    inirun0=t00;
end
sec0ori=diff_mjd(inirun0,t0ori); sec0ori
if sec0ori < 0
    error(' *** inirun0 > t0ori  %f %f ',inirun0,t0ori)
end
% t0=adds2mjd(inirun0,floor(sec0ori/st)*st); % ATTENZIONE
t0=adds2mjd(inirun0,floor(sec0ori/st)*st); % ATTENZIONE
cont.t0=t0;
nadd=round(diff_mjd(t0,t0ori)/dtori);inirun0,t0,(t0ori-t0)*86400,nadd,nori,N
y(nori+1:N)=0;
y1(nadd+1:N)=y(1:N-nadd);
y1(1:nadd)=0;

out=edit_gd(in,'y',y1,'cont',cont);
