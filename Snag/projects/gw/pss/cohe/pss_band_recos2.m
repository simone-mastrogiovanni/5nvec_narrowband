function [g vv pp tim par1 par2 par3]=pss_band_recos2(source,filein,dtout0,gdname,tint)
% PSS_BAND_RECOS  band reconstruction from a reduced band sfdb file
%
%        g=pss_band_recos(source,filein,nn0,gdname,tint)
%
%    source    [frequency,alpha,delta] source (Hz,deg) easy source; 0 -> no correction
%              source structure: fine source
%    filein    input file
%    dtout0    output sampling time (proposed)
%               - check the choice with bandrecos_check
%    gdname    name of the saved gd (or nothing or 0)
%    tint      time interval [min max] in mjd; 0 all
%
%    g         output gd
%    vv        detector velocity (in the SSB, in c units)
%    pp        detector position (in the SSB, in light s)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('filein','var')||isempty(filein)
    filein=selfile(' ','*.sbl');
end
if ~exist('gdname','var') || ~ischar(gdname)
    gdname=0;
end
if ~exist('nn0','var')
    nn0=0;
end
if ~exist('tint','var')
    tint=[0 1e6];
end
if length(tint) == 1
    tint=[0 1e6];
end

[pathstr, fnamein, ext, versn] = fileparts(filein);
fnamein=text2var(fnamein);
tstr=snag_timestr(now);

fidlog=fopen(['band_recos_' tstr '.log'],'w');
fprintf(fidlog,'Operating on file %s at %s \n\n',filein,tstr);

icsource=0;
if isstruct(source)
    icsource=2;
    r=astro2rect([source.a source.d],0);
    fr0=source.f0;
else
    if length(source) < 3
        icsource=0;
    else
        icsource=1;
        r=astro2rect(source(2:3),0);
    end
end

switch icsource
    case 0
        fprintf(fidlog,'  NO SOURCE \n\n');
    case 1
        fprintf(fidlog,'  source alpha,delta,frequency: %f  %f  %f \n\n',source(2:3),source(1));
    case 2
        fprintf(fidlog,'  source alpha,delta,frequency: %f  %f  %20.14f \n',source.a,source.d,source.f0);
        fprintf(fidlog,'         v_a,v_d,df0,ddf0:  %f  %f  %20.12e  %20.12e \n\n',...
            source.v_a,source.v_d,source.df0,source.ddf0);
end
sbl_=sbl_open(filein);
sfdb09_us=read_sfdb_userheader(sbl_);
fprintf(fidlog,'sfdb09_us.einstein = %g \n',sfdb09_us.einstein);
fprintf(fidlog,'sfdb09_us.detector = %d \n',sfdb09_us.detector);
fprintf(fidlog,'sfdb09_us.tsamplu = %15.12f \n',sfdb09_us.tsamplu);
fprintf(fidlog,'sfdb09_us.typ = %d \n',sfdb09_us.typ);
fprintf(fidlog,'sfdb09_us.wink = %d \n',sfdb09_us.wink);
fprintf(fidlog,'sfdb09_us.nsamples = %d \n',sfdb09_us.nsamples);
fprintf(fidlog,'sfdb09_us.tbase = %f \n',sfdb09_us.tbase);
fprintf(fidlog,'sfdb09_us.deltanu = %15.12f \n',sfdb09_us.deltanu);
fprintf(fidlog,'sfdb09_us.firstfrind = %d \n',sfdb09_us.firstfrind);
fprintf(fidlog,'sfdb09_us.frinit = %15.6f \n',sfdb09_us.frinit);
fprintf(fidlog,'sfdb09_us.normd = %f \n',sfdb09_us.normd);
fprintf(fidlog,'sfdb09_us.normw = %f \n',sfdb09_us.normw);
fprintf(fidlog,'sfdb09_us.red = %d \n\n',sfdb09_us.red);
dtfft=sbl_.dt; % normal time between 2 ffts
fprintf(fidlog,'dtfft = %f \n',dtfft);
fprintf(fidlog,'   Time interval = %f -> %f \n',tint);
lfftin=sfdb09_us.nsamples*2;
lfftout0=lfftin*sfdb09_us.tsamplu/dtout0;
[d lfftout]=divisors(lfftin,lfftout0);
fprintf(fidlog,'lfftout = %f \n',lfftout);
k=0;
gap=0;
par1=[];
par2=[];
par3=[];
vv=zeros(3,3);
pp=zeros(3,3);
tim(1:3)=0;

while 1
    [M,t1]=sbl_read_block(sbl_,[1 2]); % il tempo è dell'inizio 
    if t1 < tint(1)
        t2=t1;
        continue;
    end
    if t1 > tint(2)
        break;
    end
    
    k=k+1;
    if t1 == 0
        break
    end
    if k == 1
        t0=t1;                % tempo del primo campione del file
        t00=floor(t1);        % ore 0 del primo campione del file
        T0=(t0-t00)*86400;    % inizio del gd
        
        dfr=sbl_.ch(1).dx;
        lenx=sbl_.ch(1).lenx;
        basefr=sbl_.ch(1).inix;
        stin=1/(dfr*lenx*2);
        nn1=2^ceil(log2(lenx)+1);
        nn=lfftout;
        if nn1 > nn
            disp(sprintf(' *** Attention ! lfft too short !  lfft,nn1 ',nn,nn1))
            disp('   Reduce the output sampling time')
        end
        n4=nn/4;
        n2=nn/2;
        dt=1/(nn*dfr);
        subsampfact=dt/sfdb09_us.tsamplu;
        fprintf(fidlog,'t0 = %f \n',t0);
        fprintf(fidlog,'t00 = %f \n',t00);
        fprintf(fidlog,'T0 = %f \n',T0);
        fprintf(fidlog,'basefr = %f \n',basefr);
        fprintf(fidlog,'dfr = %15.12f \n',dfr);
        fprintf(fidlog,'lenx = %d \n',lenx);
        fprintf(fidlog,'stin = %15.9f \n',stin);
        fprintf(fidlog,'lfftout = %d \n',nn);
        fprintf(fidlog,'dt = %15.9f \n',dt);
        fprintf(fidlog,'subsampfact = %f \n',subsampfact);
        ii2=0;
        k1=basefr/dfr;
        k1r=round(k1);
        fprintf(fidlog,'k1 k1r = %15f  %d \n',k1,k1r);
        if (abs(k1-k1r)/k1) > 1.e-6
            disp(sprintf(' ***  error in nn length: nn = ',nn))
            return
        end
        ifr1=round(basefr/dfr)+1;
        ifr2=ifr1+lenx-1;
        kfr=mod(ifr1-1:ifr2-1,lfftout)+1;
%         yph=exp(1i*(0:nn-1)*2*pi*k1r/nn);
        alias0fr=floor(basefr/(nn*dfr))*(nn*dfr);
        aliasfinfr=floor((basefr+lenx*dfr)/(nn*dfr))*(nn*dfr);
        fprintf(fidlog,'alias0fr = %.9f \n',alias0fr);
        if aliasfinfr > alias0fr
            disp(' *** Attention !  broken band !')
            fprintf(fidlog,' *** Attention !  broken band ! aliasfinfr = %.9f \n',aliasfinfr);
        end
        if icsource == 2
            sour1=new_posfr(source,t1);
            deinst=rough_deinstein(t1);
            f0=sour1.f0*(1-deinst);
            df0=sour1.df0;
            ddf0=sour1.ddf0;
            fprintf(fidlog,' Apparent frequency :  %16.8f \n',f0);
            pars.appf0=f0;
            pars.df0=sour1.df0;
            pars.alpha=sour1.a;
            pars.delta=sour1.d;
        end
    else
        gap=(t1-t2)*86400-dtfft;
        if abs(gap) > 0.1
            disp(sprintf(' -> %d   %7d  %.9f  %f',k,round(gap),gap-round(gap),dtfft*2/gap)) 
        end
        
        if gap < -0.1 %-dtfft
            disp(sprintf(' *** Attention ! %f',gap));
        end
    end
    
    x=zeros(1,nn);
    x(kfr)=M{1};
    
    if icsource == 2
    end
    
    T1=(t1-t0)*86400;              % tempo del chunk rispetto al t0
    ii=round(T1/dt)+n4+1;          % i dati nel gd sono a partire dal t0
    terr=(T1/dt-round(T1/dt))*dt;  
% se terr è positivo, bisogna anticipare il segnale 

    if abs(terr) > 0.001*dt
        fprintf(' terr : %f at %f (%s) \n',terr,t1-t0,mjd2s(t1))
        x=x.*exp((0:lenx-1)*2*pi*terr*dfr);  %  controllare !
    end
    y=2*ifft(x)/subsampfact; % factor 2 for analytical signal
%     y=y.*yph;
    y=y(n4+1:n4+n2);
    
    g(ii:ii+n2-1)=y; 
    
    if icsource ~= 0
        if icsource == 2
            teph=t1+dtfft/86400;
            deinst=rough_deinstein(teph);
            sour1=new_posfr(source,teph);
            r=astro2rect([sour1.a sour1.d],0);
            fr0=sour1.f0*(1-deinst);
            dfr0=sour1.df0*dt;
        else
            fr0=source(1);
            dfr0=0;
        end
        y=g(ii-n4:ii+n4-1);
        vp=M{2};
        vv(k,:)=vp(1:3);
        pp(k,:)=vp(4:6);
        tim(k)=t1+dtfft/86400;
        v=vp(1:3);
        p=vp(4:6);
        
        pos1=p(1)+v(1)*dt*((0:n2-1)-n2/2);
        pos2=p(2)+v(2)*dt*((0:n2-1)-n2/2);
        pos3=p(3)+v(3)*dt*((0:n2-1)-n2/2);
        pos=pos1*r(1)+pos2*r(2)+pos3*r(3);
        
        tt=T1+dt*((0:n2-1)+n2/2);%disp(sprintf('%f %f',T1,dt))
        ph1=(df0*(tt.^2)/2+ddf0*(tt.^3)/6)*2*pi;
        ph2=fr0*pos*2*pi;
        phi=ph1+ph2;
        par1=[par1 ph1];
        par2=[par2 ph2];
        par3=[par3 pos];
    
        y=y.*exp(-1i*mod(phi,2*pi));
        
        g(ii-n4+1:ii+n4)=y; % sistemare per i gap e finale !
    end
    
    if icsource == 0
        fprintf(fidlog,'%5d : t1,T1,ii,ii-ii2,terr,gap,dphi = %f %15f %7d %5d %10f  %f \n',...
            k,t1,T1,ii,ii-ii2,terr,gap);
    else
%         fprintf(fidlog,'%5d : t1,T1,ii,ii-ii2,terr,gap,dphi0,dphi = %f %15f %7d %5d %10f %12f %13.9f  %f \n',...
%             k,t1,T1,ii,ii-ii2,terr,gap,dphi0(k),dphi(k));
    end
    t2=t1;
    ii2=ii;
end

out=check_nan(g,1);
g(out)=0;
g=gd(g);
pars.t0=t0;
g=edit_gd(g,'ini',T0,'dx',dt,'cont',pars);

fprintf(fidlog,'length of gd = %d \n',n_gd(g));
fprintf(fidlog,'ini of gd = %d \n',ini_gd(g));
fprintf(fidlog,'dx of gd = %d \n',dx_gd(g));
fprintf(fidlog,'final t1,T1 = %f %f \n',t1,T1);

fprintf(fidlog,'T1/dt+3*n4 = %f \n',T1/dt+3*n4);
fclose(fidlog);
fclose(sbl_.fid);

if ischar(gdname)
    fnamein=gdname;
end

eval([fnamein '=g;'])
eval(['save ' 'gd_' fnamein '_' tstr ' ' fnamein])
