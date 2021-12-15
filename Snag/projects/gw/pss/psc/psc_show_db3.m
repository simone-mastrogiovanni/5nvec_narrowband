function [pars hfr hsky hsd]=psc_show_db3(fr,lam,bet,sd,cr,nsd,dirin)
%PSC_SHOW_DB3  create a candidate selection from a psc db3
%            IN CONSTRUCTION - NOT YET READY
%       [pars hfr hsky hsd]=psc_show_db3(fr,lam,bet,sd,cr,nsd,dirin)
%
%   fr           [frmin,frmax]; = 0 no selection
%   lam          [lammin,lammax]; = 0 no selection
%   bet          [betmin,betmax]; = 0 no selection
%   sd           [sdmin,sdmax]; = 0 no selection
%   cr           [crmin,crmax]; = 0 no selection
%   nsd          number of sd par (for output) 
%   dirin        input folder (root)
%
%   pars[n,7,3]  candidate parameters min,max,dx   

% Version 2.0 - November 2006
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('dirin')
    dirin=selfolder;
    dirin=[dirin dirsep];
end
icfr=1;
iclam=1;
icbet=1;
icsd=1;
iccr=1;

if length(fr) == 1
    icfr=0;
    infr1=1;
    infr2=200;
else
    infr1=floor(fr(1)/10+0.001)+1;
    infr2=ceil(fr(2)/10-0.001);
end
if length(lam) == 1
    iclam=0;
end
if length(bet) == 1
    icbet=0;
end
if length(sd) == 1
    icsd=0;
end
if length(cr) == 1
    iccr=0;
end


disp(['start at ' datestr(now)])
N=2000000;
ncand=0;
nfr=infr2-infr1+1;
hfr=zeros(1,infr2*100);
hsky=zeros(360*180,1);
hsd=zeros(nsd,infr2*100);
hx=(1:infr2*100)*0.1;
pars=zeros(infr2,7,3);
pars(:,:,1)=1.e34;
pars(:,:,2)=-1.e34;
ii=0;

for i = infr1:infr2
    ii=i;
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    file=sprintf('pss_cand_%04d',(i-1)*10);
    filtot=[dirin dir1 dirsep dir2 dirsep file '.cand'];
    disp(sprintf(' --> %s    %s',filtot,datestr(now)))
 
    fid=fopen(filtot,'r');
    if fid < 0
        disp(['no ' file]);
        continue;
    end
    head=psc_rheader(fid);
    pars(ii,1,3)=0.000001;
    pars(ii,2,3)=head.dlam;
    pars(ii,3,3)=head.dbet;
    pars(ii,4,3)=head.dsd1;
    pars(ii,5,3)=head.dcr;
    pars(ii,6,3)=head.dmh;
    pars(ii,7,3)=head.dh;
    dsd1=head.dsd1;
    
    eofstat=0;
    while eofstat == 0
        [vcand,nread,eofstat]=psc_readcand(fid,N);
        nn=length(vcand)/8;

        if nn > 0
            cand1=psc_vec2mat(vcand',head,nn);
  
            cand1=psc_sel(cand1,fr,lam,bet,sd,cr);
            [n1,n2]=size(cand1); % disp([min(cand1(1,:)),max(cand1(1,:))])
            if n2 > 0        
                pars(ii,1,1)=min(pars(ii,1,1),min(cand1(1,:)));
                pars(ii,2,1)=min(pars(ii,2,1),min(cand1(2,:)));
                pars(ii,3,1)=min(pars(ii,3,1),min(cand1(3,:)));
                pars(ii,4,1)=min(pars(ii,4,1),min(cand1(4,:)));
                pars(ii,5,1)=min(pars(ii,5,1),min(cand1(5,:)));
                pars(ii,6,1)=min(pars(ii,6,1),min(cand1(6,:)));
                pars(ii,7,1)=min(pars(ii,7,1),min(cand1(7,:)));        
                pars(ii,1,2)=max(pars(ii,1,2),max(cand1(1,:)));
                pars(ii,2,2)=max(pars(ii,2,2),max(cand1(2,:)));
                pars(ii,3,2)=max(pars(ii,3,2),max(cand1(3,:)));
                pars(ii,4,2)=max(pars(ii,4,2),max(cand1(4,:)));
                pars(ii,5,2)=max(pars(ii,5,2),max(cand1(5,:)));
                pars(ii,6,2)=max(pars(ii,6,2),max(cand1(6,:)));
                pars(ii,7,2)=max(pars(ii,7,2),max(cand1(7,:)));
                hfr=hfr+hist(cand1(1,:),hx);
                for j = 1:nsd
                    jj=find(round(cand1(4,:)/dsd1)==j-1);
                    hsd(j,:)=hsd(j,:)+hist(cand1(1,jj),hx);
                end
                i1=floor(cand1(2,:))+1;
                i2=floor(cand1(3,:))+91;
                i3=i1+i2*360;
                hsky=hsky+hist(i3,1:360*180)';
            end
            ncand=ncand+n2;
        end
    end
    fclose(fid);
end

ind=find(pars==1.e34);
pars(ind)=0;
ind=find(pars==-1.e34);
pars(ind)=0;

disp(sprintf('ncand = %d  -  stop at %s',ncand,datestr(now)))

 hsky=reshape(hsky,360,180);
 hsky=hsky';
