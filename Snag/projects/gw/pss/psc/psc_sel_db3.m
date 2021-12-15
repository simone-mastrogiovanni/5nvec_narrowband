function cand=psc_sel_db3(fr,lam,bet,sd,cr,dirin)
% PSC_SEL_DB3  create a candidate selection from a psc db3
%             IN CONSTRUCTION - NOT YET READY
%       cand=psc_sel_db3(fr,lam,bet,sd,cr
%
%   fr       [frmin,frmax]; = 0 no selection
%   lam      [lammin,lammax]; = 0 no selection
%   bet      [betmin,betmax]; = 0 no selection
%   sd       [sdmin,sdmax]; = 0 no selection
%   cr       [crmin,crmax]; = 0 no selection
%   dirin    input folder (root)

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
N=100000;
ncand=0;

for i = infr1:infr2
    vdir1=floor((i-1)/10);
    vdir2=floor((i-vdir1*10-1));
    vdir3=floor(i-vdir1*10-vdir2-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
    
    file=sprintf('pss_cand_%04d',(i-1)*10);
    filtot=[dirin dir1 dirsep dir2 dirsep file '.cand'];

    fid=fopen(filtot,'r');
    if fid < 0
        disp(['no ' file]);
        continue;
    end
    head=psc_rheader(fid);
    
    eofstat=0;
    while eofstat == 0
        [vcand,nread,eofstat]=psc_readcand(fid,N);
        nn=length(vcand)/8;

        if nn > 0
            cand1=psc_vec2mat(vcand',head,nn);
        end

        cand1=psc_sel(cand1,fr,lam,bet,sd,cr);
        [n1,n2]=size(cand1);
        if n2 > 0
            cand(:,ncand+1:ncand+n2)=cand1;
        end
        ncand=ncand+n2;
    end
    
    fclose(fid);
end

disp(sprintf('ncand = %d  -  stop at %s',ncand,datestr(now)))

cand.cand=cand;
cand.epoch=head.initim;
