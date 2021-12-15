function wide_pss_band_recos_strob8ph_part1_nodop(path,name,ant_sour,ext1,sourcestr, filein,dtout,tref,ioutin,gdname,tint)
% PSS_BAND_RECOS_STROB4PH_PART1  band reconstruction from a reduced band sfdb file
%                         (stroboscopic method) for narrow-band searches
%                         does not correct the doppler
%                         effect, see Sabrina's correction LINE 312
%                           
%    INPUT PARAMETERS:
%
%    path      The path where the files are saved
%    name	   Addon on the name of output
%              [f0 df0 ddf0] check mode
%    ant_sour  File .mat containing antenna and source, must contain the
%               variables "source" and "ant"
%    ext1      Band exctracted from row data *in string form
%    sourcestr string with pulsar name 
%    filein    input file
%    dtout     output sampling time 
%               - check the choice with bandrecos_check
%    tref      reference time (=0 takes the beginning of sbl data)
%               normally set at the beginning day of the run, hour 0:0
%    gdname    name of the saved gd (or nothing or 0)
%    tint      time interval [min max] in mjd; 0 all
%
%   OUTPUT PARAMETERS:
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

% Version 3.0 - February 2011
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universit? "Sapienza" - Rome
%
% bugs removed by Sabrina D Antonio & Cristiano Palomba
% 
% Apr, 2011: added further frequency derivative terms (up to 7th, to be
% compliant with new_posfr) (CP)
%
% 2013: adaptation to narrow-band search (Roberto Serafinelli)
% 2015: adaption to very Narrow-band search (Simone Mastrogiovanni)
% Corrected the opreation of cut and paste in g and gtime (SM)

speedc=1;%$ IN USO PER IL CEEL ARRAY

%$ BLOCCHETTO PER PRENDERE TUTTE LE VAR DELLA COMPILAZIONE %$$$$$
ext1=str2num(ext1)
dtout=str2num(dtout);
load(ant_sour); %$ Load antenna & source
%$$$$$$$$$

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

% flag for TT->TDB or TCB conversion
if ~isfield(source,'kt')
    kt=0;
else
    kt=1;
end

% read ephemeris file (if it is present in the source structure)
[tephem f0ephem df0ephem ephyes]=read_ephem_file(source);

[pathstr, fnamein, ext] = fileparts(filein);
fnamein=text2var(fnamein);
tstr=snag_timestr(now);

aa=check_sbl(1,filein);
maxt=aa.maxt;





fidlog=fopen(['band_recos_' tstr '.log'],'w');
fprintf(fidlog,'Stroboscopic operation on file %s at %s \n\n',filein,tstr);

if isstruct(source)
    r=astro2rect([source.a source.d],0);
    fprintf(fidlog,'  source alpha,del120000ta,frequency: %f  %f  %20.14f \n',source.a,source.d,source.f0);
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

%%%%%%%%%%%%%%%%%%% ADDED RESPECT TO TARGETED SEARCH %%%%%%%%%%%%
% block added to compute Tobs - to be used in pss_fd_resamp
t1=0;
while 1
    t2=t1;
    [M,t1]=sbl_read_block(sbl_,[1 2]); % t1 is the initial time (mjd) of each FFT in the .sbl file 
    if t1>1e6
        break;
    end
    if t1 == 0
        break
    end
end
Tobs=(t2-sbl_.t0)*86400+sbl_.dt;
fclose(sbl_.fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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
lfftin=sfdb09_us.nsamples*2
lfftout0=lfftin*sfdb09_us.tsamplu/dtout
[d lfftout]=divisors_snag(lfftin,lfftout0);
fprintf(fidlog,'lfftout = %f \n',lfftout);

ibias=0;
lentot=ceil(min(maxt-sbl_.t0,tint(2)-tint(1))*86400+dtfft+2*ibias)/dtout
g=zeros(lentot,1);
gtime=zeros(lentot,1);

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
    [M,t1]=sbl_read_block(sbl_,[1 2]); 
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
            % update rotational parameters
%            sour1=new_posfr(source,tref); 
            sour1=use_ephem_file(ephyes,tref,source,tephem,f0ephem,df0ephem);
            f0=sour1.f0;
            df0=sour1.df0;
            ddf0=sour1.ddf0;
            d3f0=sour1.d3f0;
            d4f0=sour1.d4f0;
            d5f0=sour1.d5f0;
            d6f0=sour1.d6f0;
            d7f0=sour1.d7f0;
            pars.appf0=sour1.f0;
            pars.df0=sour1.df0;

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
        in.d3f0=d3f0;
        in.d4f0=d4f0;
        in.d5f0=d5f0;
        in.d6f0=d6f0;
        in.d7f0=d7f0;
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
        % update rotational parameters
        sour1=use_ephem_file(ephyes,teph,source,tephem,f0ephem,df0ephem);
        if ephyes == 1
            in.f0=sour1.f0;
            in.df0=sour1.df0;
        end
%        sour1=new_posfr(source,teph);
        r=astro2rect([sour1.a sour1.d],0);
    end

    vp=M{2};
    vp(1:6)=0;   %%usare questa se voglio togliere doppler SABRINA OCCCHIIIOOOOOOOOOOOOOOOOOOO
    vv(k,:)=vp(1:3);
    pp(k,:)=vp(4:6);
    tim(k)=t1+dtfft/86400;
    v=vp(1:3);
    p=vp(4:6);
    
    in.p1=dot(p,r);
    in.v1=dot(v,r);
    
    if in.tref ~= 0
        in.empdelay=(in.tref-in.t0)*86400;
    else
        in.empdelay=0;
    end
    
    %The function applies Doppler correction to time series,using the
    %global variable "in" .Then it down-samples the time series and the
    % time vector associated
   
  
    
    [out outime iout ii tchsupp p]=pss_fd_resamp8ph_nb(t1,kt);
    
    
    
    
    
    sii{speedc}=ii;
    stch{speedc}=tchsupp;
    siout{speedc}=iout;
    
    pars.time(2,in.count)=in.time(2);
    pars.time(1,in.count)=in.time(1);
    
    if k == 1
        fprintf(fidlog,'lfftout = %f \n',in.lfftout);
        fprintf(fidlog,'totout = %f \n',in.totout);
        ioutout=iout;
    end
    
   P=out;
   Ptime=outime;
   ioutb=floor(round(1.0/dtout)*iout)+1+round(1.0/dtout)*ibias; %$ Correction for any sampling freq
   g(ioutb:ioutb+length(P)-1)=P;
   gtime(ioutb:ioutb+length(P)-1)=Ptime;
   
   t2=t1;
   
   speedc=speedc+1; %$ INCREMENTO
end



fclose(fidlog);
fclose(sbl_.fid);

massivename=strcat(name,'massive_','.mat');
massivenametime=strcat(name,'time_massive_','.mat');

save(massivename,'g');
save(massivenametime,'gtime');

% Append the matrix g in the same file of g.
load(massivenametime);
VVVVtime=gtime(:);
clear gtime
gtime=VVVVtime;
clear VVVVtime

save([path,name,sourcestr,'_timevar','.mat'],'sii','stch','siout','gtime');


clear sii;
clear stch;
clear siout;
clear gtime;

load(massivename);
VVVV=g(:);
clear g
g=VVVV;
clear VVVV

filename=strcat(path,name,sourcestr,'data_part1','.mat')

save(filename);

delete (massivename)
delete (massivenametime)


