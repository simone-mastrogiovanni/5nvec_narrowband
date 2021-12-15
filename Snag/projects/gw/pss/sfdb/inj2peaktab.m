function [peakinj,basic_info]=inj2peaktab(basic_info,injpeaks)
% inserts injections
%
%   A             peak table as created by HFDF_PREPJOB
%   basic_info    as created by HFDF_PREPJOB
%   injpeaks      (4,:) as created by Sabrina

% Version 2.0 - January 2014
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

[n1,n2]=size(injpeaks);
[t1 iat ict]=unique(injpeaks(1,:));
t1=t1+4096/86400;
iat=[iat; n2+1];

tim=basic_info.tim;
ntim=length(tim);
figure,plot(tim,tim,'rx'),hold on,plot(t1,t1,'.')
peakinj=zeros(5,n2+ntim);
frin=basic_info.frin;
index=zeros(1,ntim+1);
app=zeros(5,1);
app(2)=frin;

injt=1;
iii=0;
index(1)=1;

for i = 1:ntim
    t=tim(i);
    app(1)=t;
    if abs(t-t1(injt)) < 1.e-4
        nfr=iat(injt+1)-iat(injt);
        peakinj(1:4,iii+1:iii+nfr)=injpeaks(1:4,iat(injt):iat(injt+1)-1);
        injt=injt+1;
        iii=iii+nfr;
    else
        peakinj(1:5,iii+1)=app;
        iii=iii+1;
    end
    index(i+1)=iii+1;
end

injt,iii
peakinj=peakinj(:,1:iii);

basic_info.npeaks=iii;
% basic_info.NPeak(3)=n;
% basic_info.NPeak(4)=nii;
% basic_info.Dt=(max(peaks(1,:))-min(peaks(1,:)))*86400;
% basic_info.Df_sd=basic_info.Dt*max(abs(basic_info.run.sd.min),abs(basic_info.run.sd.max));
basic_info.index=index;
% basic_info.frs=fr;