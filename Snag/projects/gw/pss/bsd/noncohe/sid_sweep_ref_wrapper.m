function sids=sid_sweep_ref_wrapper(addr,ant,runame,freq,direc,sband,nsid)
% to apply sid_sweep_ref to large bands in 1-Hz subbands
%
%   input like sid_sweep_ref
%   freq any frequency inside the 10 Hz band
%   iout is not used
%   frbase = 10 (Hz)
%   no flat

% Snag Version 2.0 - July 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

wband=1;
if ~exist('nsid','var')
    nsid=-48;
end
icsol=1;
if nsid < 0
    icsol=0;
end
twrap=tic;
tim=datetime;

sidpat_rand=ana_sidpat_rand(ant,direc,0,4);
weig=mean(abs(sidpat_rand.s(2:5,:)').^2);
weig=weig/mean(weig);

Band=floor(freq/10)*10+[0 10];

for k = 1:10
    freq=Band(1)+k-0.5;
    sidsref=sid_sweep_ref(addr,ant,runame,freq,direc,sband,0,nsid);
    if k == 1
        sids.ant=ant;
        sids.direc=sidsref.direc;
        sids.inifr=sidsref.inifr;
        sids.band=sids.inifr+[0 10];
        sids.weig=sidsref.weig;
        N0=sidsref.N;
        N=N0*10;
        DFR=10/N;
        sids.DFR=DFR;
        sids.N=N;
        sidsig=zeros(1,N);
        sidnois=sidsig;
        if icsol > 0
            solsig=sidsig;
            solnois=sidsig;
        end
        inifr=sidsref.inifr;
        dfr=sidsref.dfr;
        sids.fr=inifr+DFR*(0:N-1);
        i1=1;
        i2=N0;
    end
    sidsig(i1:i2)=sidsref.sidsig;
    sidnois(i1:i2)=sidsref.sidnois;
    if k > 1
        if sidsig(i1-1) == 0
            sidsig(i1-1)=(sidsig(i1-2)+sidsig(i1))/2;
            sidnois(i1-1)=(sidnois(i1-2)+sidnois(i1))/2;
        end
    end
    if icsol > 0
        solsig(i1:i2)=sidsref.solsig;
        solnois(i1:i2)=sidsref.solnois;
        if k > 1
            if solsig(i1-1) == 0
                solsig(i1-1)=(solsig(i1-2)+solsig(i1))/2;
                solnois(i1-1)=(solnois(i1-2)+solnois(i1))/2;
            end
        end
    end
    i1=i1+N0;
    i2=i2+N0;
end

sids.sidsig=sidsig;
sids.sidnois=sidnois;
if icsol > 0
    sids.solsig=solsig;
    sids.solnois=solnois;
end

sids.tim=tim;
sids.toc=toc(twrap)