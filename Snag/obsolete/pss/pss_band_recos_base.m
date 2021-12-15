function [g in terr tall T2]=pss_band_recos_base(filein,nn0)
% PSS_BAND_RECOS  band reconstruction from a reduced band sfdb file
%
%        g=pss_band_recos_base(filein,nn0)
%
%    filein    input file
%
%    g         output gd
%    nn0       imposed reconstruction length (normally a power of 2)

% Version 2.0 - February 2009
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('filein','var')||isempty(filein)
    filein=selfile(' ');
end
if ~exist('nn0','var')
    nn0=0;
end

[pathstr, fnamein, ext, versn] = fileparts(filein);
fnamein=text2var(fnamein);
tstr=snag_timestr(now);

fidlog=fopen(['band_recos_' tstr '.log'],'w');
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
fprintf(fidlog,'sfdb09_us.deltanu = %16.12f \n',sfdb09_us.deltanu);
fprintf(fidlog,'sfdb09_us.firstfrind = %d \n',sfdb09_us.firstfrind);
fprintf(fidlog,'sfdb09_us.frinit = %15.9f \n',sfdb09_us.frinit);
fprintf(fidlog,'sfdb09_us.normd = %f \n',sfdb09_us.normd);
fprintf(fidlog,'sfdb09_us.normw = %f \n',sfdb09_us.normw);
fprintf(fidlog,'sfdb09_us.red = %d \n\n',sfdb09_us.red);
dtfft=sbl_.dt; % normal time between 2 ffts
fprintf(fidlog,'dtfft = %f \n',dtfft);
k=0;
gap=0;
gap1=0;
dphi=0;
dphi0=0;
ph=0;
vv=zeros(3,3);
pp=zeros(3,3);

while 1
    k=k+1;
    [M,t1]=sbl_read_block(sbl_,[1 2]); % il tempo è dell'inizio 
    if t1 == 0
        break
    end
    if k == 1
        t0=t1;                % tempo del primo campione del file
        t0=sbl_.t0;t1-t0
        t00=floor(t0);        % ore 0 del primo campione del file
        T0=(t0-t00)*86400;    % inizio del gd
        
        dfr=sbl_.ch(1).dx;
        lenx=sbl_.ch(1).lenx;
        basefr=sbl_.ch(1).inix;
        stin=1/(dfr*lenx*2);
%         if floor(lenx/2)*2 < lenx
%             disp(' *** odd data length')
%             return
%         end
%         nn=2*(lenx+odd)+4;
        nn=2*lenx;
        if nn0 > 0
            nn=nn0;
        end
        n4=nn/4;
        n2=nn/2;
        dt=1/(nn*dfr)
        subsampfact=dt/sfdb09_us.tsamplu;
        fprintf(fidlog,'t0 = %f \n',t0);
        fprintf(fidlog,'t00 = %f \n',t00);
        fprintf(fidlog,'T0 = %f \n',T0);
        fprintf(fidlog,'basefr = %15.9f \n',basefr);
        fprintf(fidlog,'dfr = %16.12f \n',dfr);
        fprintf(fidlog,'lenx = %d \n',lenx);
        fprintf(fidlog,'stin (not used) = %16.12f \n',stin);
        fprintf(fidlog,'nn = %d \n',nn);
        fprintf(fidlog,'dt = %16.12f \n',dt);
        fprintf(fidlog,'subsampfact = %f \n',subsampfact);
        ii2=0;
        k1=basefr/dfr;
        k1r=round(k1);
        fprintf(fidlog,'k1 k1r = %15f  %d \n',k1,k1r);
        yph=exp(1i*(0:nn-1)*2*pi*k1r/nn);
    else
        gap=(t1-t2)*86400-dtfft;
        gap1=gap1+gap;
        if abs(gap) > 0.1
            disp(sprintf(' k gap t1 : %d  %.3f  %15f',k,gap,t1)) % ?
        end
        
        if gap < -0.1 %-dtfft
            disp(sprintf(' *** Attention ! %f',gap));
        end
    end
    
    x=M{1}; %x=rota(x,-1);
    in(k,:)=x;
    
    if length(x) ~= lenx
        disp('*** error in the read data') 
    end
    
    T1=(t1-t0)*86400;             % tempo del chunk rispetto al t0
%     ii=round(T1/dt)+n4+1;         % i dati nel gd sono a partire dal t0
    ii=round(T1/dt)+1;         % i dati nel gd sono a partire dal t0
    T2(k)=(ii-1)*dt;
%     terr(k)=(T1/dt-round(T1/dt))*dt; 
    terr(k)=T1-T2(k);
% se terr è positivo, bisogna anticipare il segnale 
    tall(k)=(t1-t0)*86400;

%     fr=(0:lenx-1)*dfr+basefr; 
%     fr=(0:lenx-1)*dfr;
%     phcorr=mod(fr*2*pi*terr(k),2*pi);
% %     phcorr=mod(fr*2*pi*T2(k),2*pi);
%     x=x.*exp(1i*phcorr);%x101(k)=x(101);corr101(k)=exp(1i*phcorr(101));
   
    x(1)=0;
    x(lenx+1:nn)=0;       %!!!
    y=ifft(x)/subsampfact;
    y=y.*yph;
    y=y(n4+1:n4+n2);%k,check_nan(y)
    
    g(ii:ii+n2-1)=y; 
    
    
    fprintf(fidlog,'%5d : t1,T1,ii,ii-ii2,terr,gap, = %f %15f %7d %5d %10f  %f \n',...
        k,t1,T1,ii,ii-ii2,terr(k),gap);
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
