function par=bsd_par(in,parin)  %% CHECK !!
% parameters for BSDs
%
%   in            input bsd
%   parin         (if present) input parameter structure
%       .enh      enhancement factor (important for corrected bsd)
%       .direct   (if present) sky direction structure
%       .candstr  (if present) candidate structure for follow-up

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

typ=0;
c=299792458; % light
R0orb=149597870700; % UA
Om0orb=2*pi/(365.256363051*86400); % 1/year
vc=R0orb*Om0orb/c;
R0=5.5e6; % rotational radius at Livingston (lower latitude)
Om0=2*pi/86400; % 1/day

deg2rad=pi/180;

cont=cont_gd(in);

if exist('parin','var')
    par=parin;
else
    par.enh=1;
end

if ~isfield(par,'enh')
    par.enh=1;
end
if isfield(par,'direct')
    typ=1;
end
if isfield(par,'candstr')
    typ=2;
end

dt=dx_gd(in);
n=n_gd(in);
T0=n*dt;
inifr=cont.inifr;
bandw=cont.bandw;
frmax=inifr+bandw;
par.frmax=frmax;

tfft0=sqrt(c/(2*frmax*R0))/Om0;
lfft0=floor(tfft0/(4*dt))*4;

tfft=tfft0*par.enh;
lfft=round(lfft0*par.enh);

par.tfft0=tfft0;
par.lfft0=lfft0;
par.tfft=tfft;
par.lfft=lfft;

dfr0=1/tfft;
Ndop=ceil(2*1.06e-4*frmax/dfr0); % NOTA: forse 1e-4
par.dfr0=dfr0;
par.Ndop=Ndop;

par.Nfr=lfft;
Ndb=round(frmax*vc/dfr0);
par.Ndb=Ndb;
par.dsd0=1/(2*T0*tfft);
par.Nsky=round(4*pi*Ndb^2);

switch typ
    case 0  % normal
        [x,b,index,nlon]=pss_optmap(Ndop);
        nskypoint=length(x);
        nbeta=length(b);
        x2=diff(sort(x(:,2)));
        ii=find(abs(x2)>1.e-8);
        x2=x2(ii);
        maxbeta=max(x2);
        minbeta=min(x2);
        sky.x=x;
        sky.b=b;
        sky.lam=x(:,1);
        sky.bet=x(:,2);
        sky.ulam=x(:,3)/2;
        sky.ubet=abs(x(:,4)-x(:,5))/4;
        sky.index=index;
        sky.nlon=nlon;
        sky.nskypoint=nskypoint;
        sky.nbeta=nbeta;
        sky.x2=x2;
        sky.maxbeta=maxbeta;
        sky.minbeta=minbeta;

        par.sky=sky;
    case 1  % direct
        dopp_res=dopp_corr_residual(parin.direct,in,0);
        par.dopp_res=dopp_res;
        [lam,bet]=astro_coord('equ','ecl',parin.direct.a,parin.direct.d);
        par.lam=lam;
        par.bet=bet;
        par.ulam=(1/abs(Ndop*cos(bet*deg2rad)*deg2rad))/2;
        par.ubet=(1/abs(Ndop*sin(bet*deg2rad)*deg2rad))/2;
        par.max_var_lam=dopp_res.maxvardevdop_l_1deg*par.ulam;
        par.max_var_bet=dopp_res.maxvardevdop_b_1deg*par.ubet;
        par.tfft_fu=min(dopp_res.maxvardvdop/par.max_var_lam,dopp_res.maxvardvdop/par.max_var_bet)*par.tfft0;
        par.tfft_gain=par.tfft_fu/par.tfft0;
    case 2  % followup
        targ=cand2sour(parin.candstr.cand,parin.candstr.epoch);
        dopp_res=dopp_corr_residual(targ,in,0);
        par.dopp_res=dopp_res;
        par.lam=targ.lam;
        par.bet=targ.bet;
        par.ulam=targ.ulam;
        par.ubet=targ.ubet;
        par.max_var_lam=dopp_res.maxvardevdop_l_1deg*par.ulam; 
        par.max_var_bet=dopp_res.maxvardevdop_b_1deg*par.ubet;
        par.tfft_fu=min(dopp_res.maxvardvdop/par.max_var_lam,dopp_res.maxvardvdop/par.max_var_bet)*par.tfft0;
        par.tfft_gain=par.tfft_fu/par.tfft0;
end

k=1;

% while 