function [hmap,job_info,checkE]=bsd_hough(typ,peaks,proc_info,job_info)
% hough map creation
%
%   typ              1-> 1 allsky normal, 2 refinement (or multicell ??), 3 follow-up, 4 directed
%   peaks(5+,n)      peak table (rows with ...)
%   proc_info        epoch
%                    hm.oper ('adapt','noadapt','noiseadapt','onlysigadapt')
%                    hm.fr  (minfr dnat frenh maxfr)
%                    hm.sd  (minsd step nsteps)
%                    hm.fr  (minfr dnat frenh maxfr)
%                    Adimref=[nsd,nf] if present (refinement)
%   job_info         used for output
%                    
%  coreHoughDynLoop_mex(peaks,inifr,dfr,Day_inSeconds,deltaf2,ii0,ii,nbin_d,d,I500,nTimeSteps,nf);

% Snag Version 2.0 - January 2017
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni, S.D'Antonio and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if length(typ) < 2
    typ(2)=1;
end

errs=cell(10,1);
ierrs=0;

tic

checkE=struct();

job_info.proc.E_bsd_hough.vers='170230';
job_info.proc.E_bsd_hough.proc_info=proc_info;
job_info.proc.E_bsd_hough.tim=datestr(now);

job_info.error_hough=0;
[n1,n2]=size(peaks);

Day_inSeconds=86400;
moref=1000; % CONTROLLARNE LA NECESSITÀ

% oper='adaptive';

switch proc_info.hm.oper
    case 'noadapt'
        disp('noadapt')
        peaks(5,:)=ones(1,n2);
%         oper=' not adaptive';
    case 'noiseadapt'
        disp('noíseadapt')
%         oper=' noise-adaptive';
        peaks(5,:)=peaks(4,:)/mean(peaks(4,:));
    case 'onlysigadapt'
        disp('onlysigadapt')
        peaks(5,:)=peaks(5,:)./peaks(4,:);
        peaks(5,:)=peaks(5,:)/mean(peaks(5,:));
    otherwise
       disp('adapt') 
end

proc_info.hm.oper

epoch=proc_info.epoch; % Hough epoch (time barycenter) in mjd
Tmax=max(abs(diff_mjd(epoch,peaks(1,:))));
if isfield(proc_info,'Tmax_sd')
    if proc_info.Tmax_sd > 0
        Tmax=proc_info.Tmax_sd;
        disp(' --- External Tmax')
    end
else
    disp(' --- Internal Tmax')
end
Tmax
peaks(1,:)=diff_mjd(epoch,peaks(1,:))/Day_inSeconds; % from now on time is respect to epoch

fprintf(' ----> mean t = %f   epoch = %f \n',mean(peaks(1,:)),epoch)

minfr=proc_info.hm.fr(1);
frdnat=proc_info.hm.fr(2);
frenh=proc_info.hm.fr(3);
maxfr=proc_info.hm.fr(4);
dfr=frdnat/frenh;

minsd=proc_info.hm.sd(1);
deltasd=proc_info.hm.sd(2);
nsd=proc_info.hm.sd(3);
sdmax=minsd+deltasd*nsd;
sds=minsd+(0:nsd-1)*deltasd;

maxsd=max(abs(sds));
maxt=max(abs(peaks(1,:)));

% preparation

switch typ(1)
    case 1
        disp('allsky')
        nf0=ceil((maxfr-minfr)/dfr);
        nsd=proc_info.hm.sd(3);
        nfenh=ceil(Tmax*maxsd/dfr)+moref;
        nf=nf0+2*nfenh;
        Ainifr=minfr-nfenh*dfr; % ATTENZIONE !!!      
    case 2
        disp('refine')
        ncand=job_info.ncand;
        skylayer=job_info.proc.G_bsd_hspot.refpar.skylayers;
        kkkk=(skylayer*2+1)^2;
%         nsd=job_info.proc.G_bsd_hspot.nSD+2;
        nsd=job_info.proc.G_bsd_hspot.nSD;
        nf=job_info.proc.G_bsd_hspot.nDF*(kkkk*ncand*2+1); 
%         minfr=2*dfr;
%         moref=0;
        Ainifr=0;
        deltasd=proc_info.hm.sd(2)/job_info.proc.G_bsd_hspot.refpar.sd.enh;
%         minsd=job_info.proc.G_bsd_hspot.refpar.sd.min*deltasd-deltasd;
%         maxsd=job_info.proc.G_bsd_hspot.refpar.sd.max*deltasd+deltasd;
        minsd=job_info.proc.G_bsd_hspot.refpar.sd.min*deltasd; 
        sds=minsd+(0:nsd-1)*deltasd;
    case 3 % ??
        disp('follow-up')
        ncand=1;
%         nf0=ceil((maxfr-minfr)/dfr);
%         nsd=proc_info.hm.sd(3);
%         nfenh=ceil(Tmax*maxsd/dfr)+moref;
%         nf=nf0+2*nfenh;
%         Ainifr=minfr-nfenh*dfr; % ATTENZIONE !!!
        nf=job_info.proc.G_bsd_hspot.nf;
        nsd=job_info.proc.G_bsd_hspot.nsd;
        nsd1=(nsd-1)/2;
        Ainifr=0;
        dfr=job_info.proc.G_bsd_hspot.dfr;
        deltasd=job_info.proc.G_bsd_hspot.dsd;
        minsd=-nsd1*deltasd; 
        sds=minsd+(0:nsd-1)*deltasd;
    case 4
        disp('directed')
        nf0=ceil((maxfr-minfr)/dfr);
        nsd=proc_info.hm.sd(3);
        nfenh=ceil(Tmax*maxsd/dfr)+moref;
        nf=nf0+2*nfenh;nf,nf0,maxfr,minfr,moref,Tmax,maxsd,dfr
        Ainifr=minfr-nfenh*dfr; % ATTENZIONE !!! 
end

A=zeros(nsd,nf); [nA1,nA2]=size(A)

n_of_peaks=length(peaks);
ii=find(diff(peaks(1,:)));    % find the different times
ii=[ii n_of_peaks]; 
nTimeSteps=length(ii);        % number of times of the peakmap

deltaf2=round(frenh/2+0.001); % semi-width of the strip (in dfr)

comp=proc_info.comp; nTimeSteps

switch comp
    case 'normal'
        disp('normal matlab')
        ii0=1;
        for it = 1:nTimeSteps
            kf=(peaks(2,ii0:ii(it))-Ainifr)/dfr;  % normalized frequencies
            w=peaks(5,ii0:ii(it));                % wiener weights
            t=peaks(1,ii0)*Day_inSeconds; % time conversion days to s
            tdfr=t/dfr;
            f0_a=kf-deltaf2; 

            for id = 1:nsd   % loop for the creation of half-differential map
                td=sds(id)*tdfr;
                a=1+round(f0_a-td); 
%                 if max(a)>nA2,length(kf),max(round(f0_a-td)),max(f0_a),it,id,td,nA1,nA2,...
                if max(a)>nA2;iii=find(a>nA2);a(iii)=nA2;...
                ierrs=ierrs+1;errs{ierrs}=[it,id,length(iii)];end
%                 if min(a) <= 0,a,td;end
                A(id,a)=A(id,a)+w; % left edge of the strips
            end
            ii0=ii(it)+1;
        end
        
        A(:,deltaf2*2+1:nf)=...
            A(:,deltaf2*2+1:nf)-A(:,1:nf-deltaf2*2); % half to full diff. map - Carl Sabottke idea
        A=cumsum(A,2);   % creation of the Hough map
    case 'mex'
        disp('mex file')
    case 'parallel'
        disp('parallel')
end


% output

checkE.A=A;
checkE.errs=errs;
hmap=gd2(A.');
hmap=edit_gd2(hmap,'dx',dfr,'ini',Ainifr,'dx2',deltasd,'ini2',minsd,'capt','Histogram of spin-f0');

job_info.proc_info=proc_info;

