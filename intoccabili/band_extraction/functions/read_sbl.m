function read_sbl(filein,tint,tref,tstr)
% filein: .sbl file
% tint: time interval. If 0 take all the times
% tref: reference time. If 0 takes initial time
% tstr: string to be used in the log file name

dtout=1;
aa=check_sbl(1,filein);
maxt=aa.maxt
len=aa.len
blen=aa.blen;
if length(tint) == 1
    tint=[0,1000000];
end

fidlog=fopen(['testlog' tstr '.log'],'w');
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
lfftin=sfdb09_us.nsamples*2
lfftout0=lfftin*sfdb09_us.tsamplu/dtout
lfftout=lfftout0;
fprintf(fidlog,'lfftout = %f \n',lfftout);

ibias=1000;
lentot=ceil((min(maxt-sbl_.t0,tint(2)-tint(1))*86400+dtfft+2*ibias)/dtout)
k=0;
while 1
%while k<1
    [M,t1]=sbl_read_block(sbl_,[1 2]); % il tempo ? dell'inizio 
 %t1=t1
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
        
        dfr=sbl_.ch(1).dx
        lenx=sbl_.ch(1).lenx;
        basefr=sbl_.ch(1).inix;
        endfr=sbl_.ch(1).iniy; % escamotage to pass fr1, fr2
        
        dt=1/(lfftout*dfr);
        subsampfact=dt/sfdb09_us.tsamplu;
        fprintf(fidlog,'t0 = %f \n',t0);
        fprintf(fidlog,'tref = %f \n',tref);
        fprintf(fidlog,'t00 = %f \n',t00);
        fprintf(fidlog,'T0 = %f \n',T0);
        fprintf(fidlog,'basefr = %f \n',basefr);
        fprintf(fidlog,'endfr = %f \n',endfr);
        fprintf(fidlog,'dfr = %15.12f \n',dfr);
        fprintf(fidlog,'lenx = %d \n',lenx);
%         fprintf(fidlog,'stin = %15.9f \n',stin);
        fprintf(fidlog,'lfftout = %d \n',lfftout);
        fprintf(fidlog,'dt = %15.9f \n',dt);
        fprintf(fidlog,'subsampfact = %f \n',subsampfact);
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
    nbin=length(in.sbl);
    freq=basefr+(0:nbin-1)*dfr;
    %fprintf(fidlog,'sbl = %g + j%g\n',[real(M{1}) imag(M{1})].');
    if (k == 200 || k == 1000 || k == 1600)
        fprintf('time: %f\n',t1);
        figure;plot(freq,real(in.sbl),'.');
        %hold on;plot(imag(in.sbl),'r');
    end
    vp=M{2};
    %fprintf(fidlog,'vp = %e \n',vp);
    %vp(1:6)=0;   %%usare questa se voglio togliere doppler
    vv(k,:)=vp(1:3);
    pp(k,:)=vp(4:6);
    tim(k)=t1+dtfft/86400;
    v=vp(1:3);
    p=vp(4:6);
    t2=t1;
end