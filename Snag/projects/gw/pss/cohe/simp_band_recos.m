function [g vv pp tim par1 par2 par3]=simp_band_recos(filein,dtout,tint)
% SIMP_BAND_RECOS  simplified band reconstruction from a reduced band sfdb file
%
%        g=simp_band_recos(source,filein,nn0,gdname,tint)
%
%    filein    input file
%    dtout     imposed reduced fft length (a sub-multiple of original fft length)
%               - check the choice with bandrecos_check
%    tint      time interval [min max] in mjd; 0 all
%
%    g         output gd
%    vv        detector velocity (in the SSB, in c units)
%    pp        detector position (in the SSB, in light s)
%    tim       times of the vv and pp

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit� "Sapienza" - Rome

if ~exist('filein','var')||isempty(filein)
    filein=selfile(' ');
end
if ~exist('dtout','var')
    dtout=1;
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

fidlog=fopen(['simp_band_recos_' tstr '.log'],'w');
fprintf(fidlog,'Operating on file %s at %s \n\n',filein,tstr);

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
k=0;
gap=0;
par1=[];
par2=[];
par3=[];
vv=zeros(3,3);
pp=zeros(3,3);

while 1
    [M,t1]=sbl_read_block(sbl_,[1 2]); % il tempo � dell'inizio 
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
        nn1=2^ceil(log2(lenx)+1)
        if nn0 == 0
            nn=nn1;
        else
            nn=nn0;
            if nn1 > nn
                disp(sprintf(' *** Attention ! nn too short !  nn,nn1 ',nn,nn1))
            end
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
        yph=exp(1i*(0:nn-1)*2*pi*k1r/nn);
        alias0fr=floor(basefr/(nn*dfr))*(nn*dfr);
        aliasfinfr=floor((basefr+lenx*dfr)/(nn*dfr))*(nn*dfr);
        fprintf(fidlog,'alias0fr = %.9f \n',alias0fr);
        if aliasfinfr > alias0fr
            disp(' *** Attention !  broken band !')
            fprintf(fidlog,' *** Attention !  broken band ! aliasfinfr = %.9f \n',aliasfinfr);
        end
        if icsource == 2
            sour1=new_posfr(source,t1);
            f0=sour1.f0;
            df0=sour1.df0;
            ddf0=sour1.ddf0;
            fprintf(fidlog,' Apparent frequency :  %16.8f \n',f0);
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
    
    x=M{1};
    
    if length(x) ~= lenx
        disp('*** error in the read data') 
    end
    
    if icsource == 2
    end
    
    T1=(t1-t0)*86400;              % tempo del chunk rispetto al t0
    ii=round(T1/dt)+n4+1;          % i dati nel gd sono a partire dal t0
    terr=(T1/dt-round(T1/dt))*dt;  
% se terr � positivo, bisogna anticipare il segnale 

    if abs(terr) > 0.001*dt
        fprintf(' terr : %f at %f (%s) \n',terr,t1-t0,mjd2s(t1))
        x=x.*exp((0:lenx-1)*2*pi*terr*dfr);  %  controllare !
    end
    x(lenx+1:nn)=0;
    y=2*ifft(x)/subsampfact; % factor 2 for analytical signal
%     y=y.*yph.*yphl_i;
    y=y.*yph;
    y=y(n4+1:n4+n2);
    
    g(ii:ii+n2-1)=y; 
    
    
    
    fprintf(fidlog,'%5d : t1,T1,ii,ii-ii2,terr,gap,dphi = %f %15f %7d %5d %10f  %f \n',...
        k,t1,T1,ii,ii-ii2,terr,gap);
    t2=t1;
    ii2=ii;
end

out=check_nan(g,1);
g(out)=0;
g=gd(g);
g=edit_gd(g,'ini',T0,'dx',dt,'cont',t0);

fprintf(fidlog,'length of gd = %d \n',n_gd(g));
fprintf(fidlog,'ini of gd = %d \n',ini_gd(g));
fprintf(fidlog,'dx of gd = %d \n',dx_gd(g));
fprintf(fidlog,'final t1,T1 = %f %f \n',t1,T1);

fprintf(fidlog,'T1/dt+3*n4 = %f \n',T1/dt+3*n4);
fclose(fidlog)
fclose(sbl_.fid)