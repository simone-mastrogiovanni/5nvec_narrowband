function [g vv pp tim par1 par2 par3]=pss_band_recos_strob3_nodop(source,filein,dtout,tref,gdname,tint)
% PSS_BAND_RECOS_STROB  band reconstruction from a reduced band sfdb file
%                         (stroboscopic method)
%
%        g=pss_band_recos_strob3_nodop(source,filein,dtout,tref,gdname,tint)
%
%    source    source structure
%              [f0 df0 ddf0] check mode
%    filein    input file
%    dtout     output sampling time 
%               - check the choice with bandrecos_check
%    tref      reference time (=0 takes the beginning of sbl data)
%               normally set at the beginning day of the run, hour 0:0
%    gdname    name of the saved gd (or nothing or 0)
%    tint      time interval [min max] in mjd; 0 all
%
%    g         output gd
%    vv        detector velocity (in the SSB, in c units)
%    pp        detector position (in the SSB, in light s)
%
%    cont.t0       time of the first time sample
%        .appf0    reference source frequency (f0 at t0)
%        .df0      1st spin-down parameter at t0
%        .alpha    right ascension at t0
%        .delta    declination at t0

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

global in

if ~exist('filein','var')||isempty(filein)
    filein=selfile(' ','*.sbl');
end
if ~exist('gdname','var') || ~ischar(gdname)
    gdname=0;
end
if ~exist('nn0','var')
    nn0=0;
end
if ~exist('tref','var')
    tref=0;
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

aa=check_sbl(1,filein);
maxt=aa.maxt;

fidlog=fopen(['band_recos_' tstr '.log'],'w');
fprintf(fidlog,'Stroboscopic operation on file %s at %s \n\n',filein,tstr);

if isstruct(source)
    r=astro2rect([source.a source.d],0);
    fprintf(fidlog,'  source alpha,delta,frequency: %f  %f  %20.14f \n',source.a,source.d,source.f0);
    fprintf(fidlog,'         v_a,v_d,df0,ddf0:  %f  %f  %20.12e  %20.12e \n\n',...
        source.v_a,source.v_d,source.df0,source.ddf0);
    icsource=1;
    pars.sour=source;
else
    disp(' *** "source" must be a source structure. Use other programs for less known sources !')
    disp(' *** Just to check')
    r=[0 0 0];
    icsource=0;
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
lfftout0=lfftin*sfdb09_us.tsamplu/dtout;
[d lfftout]=divisors(lfftin,lfftout0);
fprintf(fidlog,'lfftout = %f \n',lfftout);

ibias=1000;
lentot=ceil(min(maxt-sbl_.t0,tint(2)-tint(1))*86400+dtfft+2*ibias)/dtout
g=zeros(1,lentot);

in.chunk0=0;
in.chunk1=0;
in.lfftin=lfftin;
in.dtin=sfdb09_us.tsamplu;
in.dtout=dtout;
in.DT=dtfft;
in.p1=0;
in.p0=0;
in.v1=0;
in.v0=0;
in.op=1;

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
        t0=t1;                % time of the first sample of the file
        t00=floor(t1);        % 0 hour of the first sample of the file
        T0=(t0-t00)*86400;    % gd start time: first acquisition time sample in s of the day
        if tref == 0
            tref=t0;
        end
        in.tref=tref;
        
        dfr=sbl_.ch(1).dx;
        lenx=sbl_.ch(1).lenx;
        basefr=sbl_.ch(1).inix;
%         stin=1/(dfr*lenx*2);
%         nn1=2^ceil(log2(lenx)+1);
%         nn=lfftout;
%         if nn1 > nn
%             disp(sprintf(' *** Attention ! lfft too short !  lfft,nn1 ',nn,nn1))
%             disp('   Reduce the output sampling time')
%         end
%         n2=nn/2;
        dt=1/(lfftout*dfr);
        subsampfact=dt/sfdb09_us.tsamplu;
        fprintf(fidlog,'t0 = %f \n',t0);
        fprintf(fidlog,'tref = %f \n',tref);
        fprintf(fidlog,'t00 = %f \n',t00);
        fprintf(fidlog,'T0 = %f \n',T0);
        fprintf(fidlog,'basefr = %f \n',basefr);
        fprintf(fidlog,'dfr = %15.12f \n',dfr);
        fprintf(fidlog,'lenx = %d \n',lenx);
%         fprintf(fidlog,'stin = %15.9f \n',stin);
        fprintf(fidlog,'lfftout = %d \n',lfftout);
        fprintf(fidlog,'dt = %15.9f \n',dt);
        fprintf(fidlog,'subsampfact = %f \n',subsampfact);
        
        k1=basefr/dfr;
        k1r=round(k1);
        fprintf(fidlog,'k1 k1r = %15f  %d \n',k1,k1r);
        if (abs(k1-k1r)/k1) > 1.e-6
            disp(sprintf(' ***  error in lfftout length: lfftout = %d',lfftout))
            return
        end
        in.ifr1=round(basefr/dfr)+1;
        in.ifr2=in.ifr1+lenx-1;
        
        if icsource == 1
            sour1=new_posfr(source,tref);
%             deinst=rough_deinstein(tref);
%             f0=sour1.f0*(1-deinst); 
            f0=sour1.f0;
            df0=sour1.df0;
            ddf0=sour1.ddf0;
            pars.appf0=sour1.f0;
            pars.df0=sour1.df0;
%             pars.alpha=sour1.a;
%             pars.delta=sour1.d;
            fprintf(fidlog,'  tref, t0 :  %12.6f, %12.6f',tref,t0);
            fprintf(fidlog,'  new frequency, spin down at tref: %20.14f %e \n',sour1.f0,sour1.df0);
            if isfield(source,'dfrsim')
                soursim=source;
                soursim.f0=source.f0+source.dfrsim;
                soursim=new_posfr(soursim,tref);
                f0sim=soursim.f0;
                pars.f0sim=f0sim; % soursim
            end
        else
            f0=source(1);
            df0=source(2);
            ddf0=source(3);
            pars.appf0=f0;
            pars.df0=sour1.df0;
        end
        
        fprintf(fidlog,' Apparent frequency :  %16.8f \n',f0);
        if exist('f0sim','var')
            fprintf(fidlog,' Apparent simulation frequency :  %16.8f \n',f0sim);
        end
        in.t0=t0;
        in.f0=f0;
        in.df0=df0;
        in.ddf0=ddf0;
%         t2=t1;
    else
        gap=(t1-t2)*86400-dtfft;
        if abs(gap) > 0.1
            disp(sprintf(' -> %d   %7d  %.9f  %f',k,round(gap),gap-round(gap),dtfft*2/gap)) 
            in.op=3;
        end
        
        if gap < -0.1 %-dtfft
            disp(sprintf(' *** Attention ! %f',gap));
        end
    end

    in.sbl=M{1};
    
    teph=t1+dtfft/86400;
    if icsource == 1
        sour1=new_posfr(source,teph);
        r=astro2rect([sour1.a sour1.d],0);
    end

    vp=M{2}*0; % NO DOPPLER !!!
    vv(k,:)=vp(1:3);
    pp(k,:)=vp(4:6);
    tim(k)=t1+dtfft/86400;
    v=vp(1:3);
    p=vp(4:6);
    
    in.p1=dot(p,r);
    in.v1=dot(v,r);
    
    [out iout p]=pss_fd_resamp3(t1);
    
    fprintf(' %d  %d  %d %15.6f %f \n',in.count,iout,length(out),t1,in.tout)
    pars.time(2,in.count)=in.time(2);
    pars.time(1,in.count)=in.time(1);
    
    if k == 1
        fprintf(fidlog,'lfftout = %f \n',in.lfftout);
        fprintf(fidlog,'totout = %f \n',in.totout);
    end
    
%     par1=[par1 in.Dtsd];
%     par2=[par2 in.dDtsd];
%     par3=[par3 p]; 
    
    ioutb=iout+ibias;
    g(ioutb:ioutb+length(out)-1)=out;
 
    t2=t1; 

%     if in.count == 100
%         break
%     end
end

iii=check_nan(g,1);
g(iii)=0;
g=gd(g);
pars.t0=t0;
g=edit_gd(g,'ini',T0,'dx',dt,'cont',pars);

fprintf(fidlog,'length of gd = %d \n',n_gd(g));
fprintf(fidlog,'ini of gd = %d \n',ini_gd(g));
fprintf(fidlog,'dx of gd = %d \n',dx_gd(g));
% fprintf(fidlog,'final t1,T1 = %f %f \n',t1,T1);

% fprintf(fidlog,'T1/dt+3*n4 = %f \n',T1/dt+3*n4);
fclose(fidlog);
fclose(sbl_.fid);

if ischar(gdname)
    fnamein=gdname;
end

eval([fnamein '=g;'])
eval(['save ' 'gd_' fnamein '_' tstr ' ' fnamein])
