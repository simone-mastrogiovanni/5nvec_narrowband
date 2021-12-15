function sds_simVirgo(inpfile,fftlen)
%SDS_SIMVIRGO  creates hrec data and a file collections 
%
%   inpfile   first input file (as a model)
%   fftlen    length of the ffts

% Version 2.0 - June 2003
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('inpfile')
    snag_local_symbols;
    inpfile=selfile(virgodata);
end

sds_=sds_open(inpfile);
tbd=sds_.len;
sdsout_=sds_;
sdsout_.nch=1;
sdsout_.capt=['Simulated hrec data from file ' sds_.filme];
sdsout_.ch{1}=[blank_trim(sds_.ch{1}) ' (hrec)'];
filout=modi_name(sds_.filme);
sdsout_.filme=filout;

sdsout_=sds_openw(filout,sdsout_);
fid=sdsout_.fid;

if ~exist('chn')
    chn=sds_selch(inpfile);
end

if ~exist('fftlen')
    answ=inputdlg({'Length of the ffts'}, ...
        'Filtering parameters',1,{'262144'});
    fftlen=eval(answ{1});
end

fr=50*(1:20);
am=zeros(1,20);
vsp=gd_drawspect(sds_.dt,fftlen,'virgo','slope',3.5,'lowfr',6,'addcomb',2,fr,am)
vsp1=y_gd(vsp);
vsp1=tdwin(vsp1,'sqrt','hhole','real');

d=ds(fftlen);
d=edit_ds(d,'dt',sds_.dt,'type',0);
r=zeros(1,3*(fftlen/2));

A=zeros(fftlen,1);
ps0=zeros(fftlen,1);
n0=0;

while tbd > 0
%    [d,sds_]=sds2ds(d,sds_,chn);
    [d,r]=noise_ds(d,r,'spect',vsp1);
    y=y_ds(d);
    A(:,1)=y;
    
    if tbd < fftlen
        B=A(1:tbd,1);
        fwrite(fid,B','float');
        fclose(fid);
        tbd=0;
        
        button = questdlg('Do you want to continue?',...
        'Continue Operation','Yes','No','No');
        if strcmp(button,'Yes')
            sdelay=sds_.len*sds_.dt;
            newname=new_file(sdsout_.filme,sdelay);
            disp(['Creating file ' newname])
            sdsout_.filme=newname;
            
            sdsout_.t0=sdsout_.t0+sdelay;
			sdsout_=sds_openw(newname,sdsout_);
			fid=sdsout_.fid;
            
            B=A(tbd+1:fftlen,1);
            fwrite(fid,B','float');
            tbd=sds_.len-(fftlen-tbd);
        end
    else
        fwrite(fid,A','float');
        tbd=tbd-fftlen;
    end
end

%---------------------------------------------------


function newname=modi_name(oldname)

newname=blank_trim(oldname);

o=double(newname);
in=double('hrec');
in2=double('SIM');
for i = 1:4
    o(20+i)=in(i);
end
for i = 1:3
    o(i)=in2(i);
end

newname=char(o)

%---------------------------------------------------


function newname=new_file(oldname,sdelay)

newname=blank_trim(oldname);

t(1:3)=sscanf(oldname(5:12),'%4d%2d%2d');
t(4:6)=sscanf(oldname(14:19),'%2d%2d%2d');

t=datenum(t(1:6))+sdelay/86400;
t1=datevec(t);
t=round(t1(1:6));

newname(5:19)=sprintf('%04d%02d%02d_%02d%02d%02d',t);
