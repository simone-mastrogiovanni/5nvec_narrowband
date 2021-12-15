function [lfftout dtout]=bandrecos_check(dtout0,filein)
% BANDRECOS_CHECK  checks for the best parameters for pss_bandrecos
%
%   dtout0   output preferred sampling time
%   filein   reduced band sbl file

if ~exist('dtout0','var')
    dtout0=1;
end

if ~exist('filein','var')||isempty(filein)
    filein=selfile(' ');
end

sbl_=sbl_open(filein);
sfdb09_us=read_sfdb_userheader(sbl_);
fprintf('sfdb09_us.einstein = %g \n',sfdb09_us.einstein);
fprintf('sfdb09_us.detector = %d \n',sfdb09_us.detector);
fprintf('sfdb09_us.tsamplu = %15.12f \n',sfdb09_us.tsamplu);
fprintf('sfdb09_us.typ = %d \n',sfdb09_us.typ);
fprintf('sfdb09_us.wink = %d \n',sfdb09_us.wink);
fprintf('sfdb09_us.nsamples = %d \n',sfdb09_us.nsamples);
fprintf('sfdb09_us.tbase = %f \n',sfdb09_us.tbase);
fprintf('sfdb09_us.deltanu = %15.12f \n',sfdb09_us.deltanu);
fprintf('sfdb09_us.firstfrind = %d \n',sfdb09_us.firstfrind);
fprintf('sfdb09_us.frinit = %15.6f \n',sfdb09_us.frinit);
fprintf('sfdb09_us.normd = %f \n',sfdb09_us.normd);
fprintf('sfdb09_us.normw = %f \n',sfdb09_us.normw);
fprintf('sfdb09_us.red = %d \n\n',sfdb09_us.red);
dtfft=sbl_.dt; % normal time between 2 ffts
fprintf('dtfft = %f \n',dtfft);

dtin=sfdb09_us.tsamplu;
lfftin=sfdb09_us.nsamples*2;
lenx=sbl_.ch(1).lenx;
dfr=sbl_.ch(1).dx;
bandin=lenx*dfr;
if bandin > 1/dtout0
    dtout0=ceil(1/bandin);
    fprintf('Too small sampling time !, new dtout0 = %f',dtout0)
end
nn1=2^ceil(log2(lenx)+1);
nn2=2^ceil(log2(1/(dfr*dtout0)));
red0=dtout0/dtin;
lfftout=nn2;
subs=lfftin/lfftout;
dtout=subs*dtin;
bandout=1/dtout;

fr1=sbl_.ch(1).inix;
fr2=sbl_.ch(1).inix+(sbl_.ch(1).lenx-1)*sbl_.ch(1).dx;

flfr1=floor(fr1/bandout)*bandout;
flfr2=floor(fr2/bandout)*bandout;
flfr=min(flfr1,flfr2);

fprintf('\n\n Original sampling time :          %f \n',dtin)
fprintf(' Original sampling frequency :     %f \n',1/dtin)
fprintf(' Original FFT length :             %d \n',lfftin)
fprintf(' Band parameters (ini,dfr,n,end) : %f %f %d %f \n',fr1,...
    dfr,lenx,fr2)
fprintf(' Output sampling time :  %f  (requested %f)\n',dtout,dtout0)
fprintf(' Output FFT length :  %d  \n',lfftout)
fprintf(' Subsampling factor : %d \n',subs)
fprintf(' Output band : %f -> %f \n',flfr,flfr+dfr*lfftout);