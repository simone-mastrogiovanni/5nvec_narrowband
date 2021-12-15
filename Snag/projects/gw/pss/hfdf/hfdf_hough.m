function [hfdf,job_info,peaks,checkE]=hfdf_hough(peaks,basic_info,job_info,hm_job,isecbelterr)
%HFDF_HOUGH  creates a f/df Hough map (based on 2011 version)
%
%     [hfdf,job_info,peaks,checkE]=hfdf_hough(peaks,basic_info,job_info,hm_job)
%
%
%    peaks(5,n)      peaks of the peakmap as [t,fr,amp,wnoise,wien] (corrected for the Doppler effect)
%                      time is MJD, sd in Hz/s
%    basic_info
%    job_info
%    hm_job          hough map structure 
%        .oper       'adapt' (def), 'noiseadapt' or 'noadapt'
%        .fr         sel  mode : [minf df enh maxf] min fr, enhanced frequency step, maxfr
%                    full mode or enhanced full mode: doesn't exist
%        .sd         sel mode or enhanced full mode: [minsd dsd nsd] min sd, step, number of sd
%                    full mode : doesn't exist
%        .mimaf      used for refined, otherwise nat_range is used
%        .mimaf0       "         "        
%
%    hfdf            hough map (gd2)
%    job_info        job info structure
%    checkE          service structure for test and debug

% Version 2.0 - October 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

tic

checkE=struct();

job_info.proc.E_hfdf_hough.vers='140904';
job_info.proc.E_hfdf_hough.hm_job=hm_job;
job_info.proc.E_hfdf_hough.tim=datestr(now);

job_info.error_hough=0;
[n1,n2]=size(peaks);

I1000=4000;  % security belt (even)
if exist('isecbelterr','var')
    I1000=I1000*isecbelterr;
end
I500=I1000/2;
Day_inSeconds=86400;

% oper=' adaptive';

switch hm_job.oper
    case 'noadapt'
        peaks(5,:)=ones(1,n2);
%         oper=' not adaptive';
    case 'noiseadapt'
%         oper=' noise-adaptive';
        peaks(5,:)=peaks(4,:)/mean(peaks(4,:));
    case 'onlysigadapt'
        peaks(5,:)=peaks(5,:)./peaks(4,:);
        peaks(5,:)=peaks(5,:)/mean(peaks(5,:));
end

epoch=basic_info.epoch; % Hough epoch (time barycenter) in mjd
peaks(1,:)=peaks(1,:)-epoch;

if isfield(hm_job,'mimaf0')   % choice of min,max f0
    mimaf0=hm_job.mimaf0;
else
    [mimaf,mimaf0]=nat_range(peaks,hm_job.sd);
end

mind1=hm_job.sd(1);

if ~isfield(hm_job,'fr')
    hm_job.fr(1)=mimaf0(1);
    hm_job.fr(2)=basic_info.run.fr.dnat;
    hm_job.fr(3)=basic_info.mode.hm_job.frenh;
    hm_job.fr(4)=mimaf0(2);
end

minf0=hm_job.fr(1);
maxf0=hm_job.fr(4);
df=hm_job.fr(2);   % raw frequency resolution
enh=hm_job.fr(3);  % frequency enhancement factor (typically 10)
df2=df/2;
ddf=df/enh;  % refined frequency step
inifr=minf0-df2-ddf;
finfr=maxf0+df2+ddf;
nbin_f0=ceil((finfr-inifr)/ddf)+I1000;
deltaf2=round(enh/2+0.001); % semi-width of the strip (in ddf)

n_of_peaks=length(peaks);
ii=find(diff(peaks(1,:)));  % find the different times
ii=[ii n_of_peaks]; 
nTimeSteps=length(ii); % number of times of the peakmap

dmin1=hm_job.sd(1);   % spin-down initial value
deltad=hm_job.sd(2);  % spin-down step
nbin_d=hm_job.sd(3);  % spin-down number of steps
d=dmin1+(0:nbin_d-1)*deltad;  
ii0=1; %nbin_d,nbin_f0

binh_df0=zeros(nbin_d,nbin_f0);  %  HM matrix container

for it = 1:nTimeSteps
    kf=(peaks(2,ii0:ii(it))-inifr)/ddf;  % normalized frequencies
    w=peaks(5,ii0:ii(it));               % wiener weights
    t=peaks(1,ii0)*Day_inSeconds; % time conversion days to s
    tddf=t/ddf;
    f0_a=kf-deltaf2; 
    
    for id = 1:nbin_d   % loop for the creation of half-differential map
        td=d(id)*tddf;
        a=1+round(f0_a-td+I500); 

%         id34=find(a<=0);  % Index check
%         if ~isempty(id34) % very rare case
%             job_info.error_hough=job_info.error_hough+1;
%             for jjj = 1:length(id34)
%                 jd34=id34(jjj); 
%                 % memory dump
%                 fprintf(' %d %d %d %d %f %f %f %f \n',it,id,jd34,a(jd34),kf(jd34),peaks(2,ii0-1+jd34),inifr,td)
%             end
%             a(id34)=1;
%         end

        binh_df0(id,a)=binh_df0(id,a)+w; % left edge of the strips
    end
    ii0=ii(it)+1;
end

binh_df0(:,deltaf2*2+1:nbin_f0)=...
    binh_df0(:,deltaf2*2+1:nbin_f0)-binh_df0(:,1:nbin_f0-deltaf2*2); % half to full diff. map - Carl Sabottke idea
binh_df0=cumsum(binh_df0,2);   % creation of the Hough map
    
hfdf=gd2(binh_df0.');
hfdf=edit_gd2(hfdf,'dx',ddf,'ini',inifr-I500*ddf,'dx2',deltad,'ini2',dmin1,'capt','Histogram of spin-f0');

job_info.hm_job=hm_job;
job_info.hm_job.fr(1)=inifr;
job_info.hm_job.fr(4)=finfr;

job_info.proc.E_hfdf_hough.duration=toc;


function [mimaf,mimaf0]=nat_range(peaks,sdvec)   % Natural frequency f0 range of the Hough map
           % given the requested frequency f0 and the spin-down, compute
           % the frequency limit of the Hough map
mind1=sdvec(1)-sdvec(2);
maxd1=mind1+sdvec(2)*sdvec(3);

t=peaks(1,:)*86400;
f=peaks(2,:);

maxt1=max(t)-min(t);

minf1=min(f);
maxf1=max(f);
mimaf=[minf1 maxf1];

sdabsmax=max(abs(mind1),abs(maxd1));
tabsmax=maxt1;
DF=sdabsmax*tabsmax; 
minf0=minf1-DF;
maxf0=maxf1+DF;

mimaf0=[minf0 maxf0];
