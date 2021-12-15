function out=sim_tfdens(g2in,simstr)
% sim_tfdens  simulation of time-frequency gd2
%
%    g2in        model gd2 (or structure)
%    simstr      simulation structure
%          .ant  antenna structure
%          .sid
%           .phase  phase (HOURS), [time phase] or phase diagram with t starting at t0
%           .amp    amplitude or [time amplitude] with t starting at t0 or amp sample by sample
%          .sol
%           .phase  phase (HOURS), [time phase] or phase diagram with t starting at t0
%           .amp    amplitude or [time amplitude]
%          .ann
%           .phase  phase (DAYS)
%           .amp    amplitude or [time amplitude]
%          .othfr(n) array of structures
%           .freq   frequency
%                   if freq(1,n) polynomial coefficients
%                      freq(1)*t^n+freq(2)*t^(n-1)+...+freq(n+1) with t starting at t0
%                   if freq(2,n) data are [time frequency]
%           .phase  phase (HOURS) NOT IMPLEMENTED !
%                   if phase(1,n) data are phase diagram
%                   if amp(2,n) data are [time phase]
%           .amp    amplitude
%                   if amp(1,n) polynomial coefficients
%                      amp(1)*t^n+amp(2)*t^(n-1)+...+amp(n+1) with t starting at t0
%                   if amp(2,n) data are [time amplitude]
%          .noise   
%           .const  noise constant amplitude 
%           .var    noise variable amplitude
%          .noise   'real' real noise
%             "     'exp' exponential distributed
%             "     'gauss' normal distributed
%          .holes   0 -> no, 1 -> yes (def) (only for "secondary" holes)

% Version 2.0 - December 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

out=g2in;
t=x_gd2(g2in);
t0=floor(t(1));
M=y_gd2(g2in);
[n1 n2]=size(M); % (time,frequency)
varnois=zeros(n1,1);
nois=1;
icrealnois=0;

ant=simstr.ant;

if isfield(simstr,'noise')
    if ischar(simstr.noise)
        if strcmp(simstr.noise,'real')
            icrealnois=1;
            nois=0;
            disp('Real noise !')
        end
        if strcmp(simstr.noise,'exp')
            icrealnois=2;
            nois=0;
            disp('Exponential noise !')
        end
        if strcmp(simstr.noise,'gauss')
            icrealnois=3;
            nois=0;
            disp('Gaussian noise !')
        end
    else
        if isfield(simstr.noise,'var')
            varnois=randn(n1,1)*simstr.noise.var;
        end
        nois=simstr.noise.const;
    end
end

if ~isfield(simstr,'holes')
    simstr.holes=1;
end
        
if isfield(simstr,'sid')
    ts=gmst(t)+ant.long/15;
    
    amp=simstr.sid.amp;
    [na1 na2]=size(amp);
    ampl=ts*0;
    
    if na1*na2 == 1
        ampl=amp;
    else
        if na1 == 2
            for i = 1:na2
                iii=find(t-t0 > amp(1,i));
                ampl(iii)=amp(2,i);
            end
%             figure,plot(t-t0,ampl,'.'),grid on
        else
            ampl=polyval(amp,t-t0);
        end
    end

    phas=simstr.sid.phase;
    [np1 np2]=size(phas);
    icsin=1;
    
    if np1*np2 == 1
        ts=ts-phas;
        ph=t*0+phas;
    else
        if np1 == 2
            ph=t*0;
            for i = 1:np2
                iii=find(t-t0 > phas(1,i));
                ph(iii)=phas(2,i);
            end
            ts=ts-ph; 
%             figure,plot(t-t0,ph,'.'),grid on
        else
            shape=phas;
            sh=ts*0;
            icsin=0;
            nsh=length(shape);
            for i = 1:n1
                ii=floor(ts(i)*nsh/24)+1;
                if ii > nsh
                    ii=ii-nsh;
                end
                sh(i)=shape(ii);
            end
        end
    end
    
    figure
    
    if icsin == 1
        subplot(2,1,1),plot(t-t0,ampl);title('Sidereal periodicity amplitude'),xlabel('time (day)'),grid on
        subplot(2,1,2),plot(t-t0,ph);title('Sidereal periodicity phase'),xlabel('time (day)'),ylabel('hours'),ylim([0 24]),grid on
        y=ampl.*cos(2*pi*ts/24);
    else
        subplot(2,1,1),plot(t-t0,ampl);title('Sidereal periodicity amplitude'),xlabel('time (day)'),grid on
        subplot(2,1,2),plot((0:nsh-1)*24/nsh,shape);title('Sidereal periodicity epoch folding'),xlabel('hours'),xlabel('hours'),xlim([0 24]),grid on
        y=ampl.*sh;
    end
end
            
if isfield(simstr,'ann')
    v=mjd2v(t(1));
    ta0=v2mjd([v(1) 1 simstr.ann.phase 0 0 0]);
    ta=t-ta0+ant.long/(15*365.2445);
    ta=ta/365.2445;
    
    amp=simstr.ann.amp;
    [na1 na2]=size(amp);
%     ampl=ts*0;
    icsin=1; % ?
    
    if na1*na2 == 1
        ampl=amp;
    else
        if na1 == 2
            for i = 1:na2
                iii=find(t-t0 > amp(1,i));
                ampl(iii)=amp(2,i);
            end
%             figure,plot(t-t0,ampl,'.'),grid on
        else
            ampl=polyval(amp,t-t0);
        end
    end

%     phas=simstr.ann.phase;
%     [np1 np2]=size(phas);
%     icsin=1;
%     
%     if np1*np2 == 1
%         ts=ts-phas;
%         ph=t*0+phas;
%     else
%         if np1 == 2
%             ph=t*0;
%             for i = 1:np2
%                 iii=find(t-t0 > phas(1,i));
%                 ph(iii)=phas(2,i);
%             end
%             ts=ts-ph; 
% %             figure,plot(t-t0,ph,'.'),grid on
%         else
%             shape=phas;
%             sh=ts*0;
%             icsin=0;
%             nsh=length(shape);
%             for i = 1:n1
%                 ii=floor(ts(i)*nsh/24)+1;
%                 if ii > nsh
%                     ii=ii-nsh;
%                 end
%                 sh(i)=shape(ii);
%             end
%         end
%     end
    
    figure
    
    if icsin == 1
%         subplot(2,1,1),plot(t-t0,ampl);title('Annual periodicity amplitude'),xlabel('time (day)'),grid on
%         subplot(2,1,2),plot(t-t0,ph);title('Annual periodicity phase'),xlabel('time (day)'),ylabel('hours'),ylim([0 24]),grid on
        plot(t-t0,ampl);title('Annual periodicity amplitude'),xlabel('time (day)'),grid on
        y=ampl.*cos(2*pi*ta);
    else
%         subplot(2,1,1),plot(t-t0,ampl);title('Annual periodicity amplitude'),xlabel('time (day)'),grid on
%         subplot(2,1,2),plot((0:nsh-1)*24/nsh,shape);title('Annual periodicity epoch folding'),xlabel('hours'),xlabel('hours'),xlim([0 24]),grid on
        plot(t-t0,ampl);title('Annual periodicity amplitude'),xlabel('time (day)'),grid on
        y=ampl.*sh;
    end
end
       
if isfield(simstr,'sol')
    t1=mod(t-t0,1);
    
    amp=simstr.sol.amp;
    [na1 na2]=size(amp);
    ampl=t1*0;
    
    if na1*na2 == 1
        ampl=amp;
    else
        if na1 == 2
            for i = 1:na2
                iii=find(t-t0 > amp(1,i));
                ampl(iii)=amp(2,i);
            end
%             figure,plot(t-t0,ampl,'.'),grid on
        else
            ampl=polyval(amp,t-t0);
        end
    end
    
    phas=simstr.sol.phase;
    [np1 np2]=size(phas);
    icsin=1;
    
    if np1*np2 == 1
        t1=t1-phas/24;
        ph=t*0+phas;
    else
        if np1 == 2
            ph=t*0;
            for i = 1:np2
                iii=find(t-t0 > phas(1,i));
                ph(iii)=phas(2,i);
            end
            t1=t1-ph/24; 
%             figure,plot(t-t0,ph,'.'),grid on
        else
            shape=phas;
            sh=t1*0;
            icsin=0;
            nsh=length(shape);
            for i = 1:n1
                ii=floor(t1(i)*nsh)+1;
                if ii > nsh
                    ii=ii-nsh;
                end
                sh(i)=shape(ii);
            end
        end
    end
    
    figure
    
    if icsin == 1
        subplot(2,1,1),plot(t-t0,ampl);title('Daily periodicity amplitude'),xlabel('time (day)'),grid on
        subplot(2,1,2),plot(t-t0,ph);title('Daily periodicity phase'),xlabel('time (day)'),ylabel('hours'),ylim([0 24]),grid on
        y=ampl.*cos(2*pi*t1);
    else
        subplot(2,1,1),plot(t-t0,ampl);title('Daily periodicity amplitude'),xlabel('time (day)'),grid on
        subplot(2,1,2),plot((0:nsh-1)*24/nsh,shape);title('Daily periodicity epoch folding'),xlabel('hours'),xlabel('hours'),xlim([0 24]),grid on
        y=ampl.*sh;
    end
end
       
if isfield(simstr,'othfr')
    nfr=length(simstr.othfr);
    t=t-t0;
    y=t*0;
    
    for ifr = 1:nfr
        freq=simstr.othfr(ifr).freq;
        [nf1 nf2]=size(freq); % DA FARE !!!

        if nf1 == 1
            fr=polyval(freq,t);
        else
            for i = 1:nf2
                iii=find(t-t0 > freq(1,i));
                fr(iii)=freq(2,i);
            end
        end

        ph=t*0;

        for i = 2:n1
            ph(i)=ph(i-1)+2*pi*(t(i)-t(i-1))*(fr(i)+fr(i-1))/2;
        end

        amp=simstr.othfr(ifr).amp;
        [na1 na2]=size(amp); % DA FARE !!!

        if na1 == 1
            ampl=polyval(amp,t);
        else
            for i = 1:na2
                iii=find(t-t0 > amp(1,i));
                ampl(iii)=amp(2,i);
            end
        end   

        y=y+ampl.*cos(ph);
    end
end

for i = 1:n2
    obswind=ones(n1,1);
    if simstr.holes == 1
        dat=M(:,i);
        ii=find(dat==0);
        obswind(ii)=0;
    end
        
    switch icrealnois
        case 0
            M(:,i)=(y+varnois+nois).*obswind;
        case 1
%             dat=M(:,i);
%             ii=find(dat);
%             meno=mean(dat(ii));
            M(:,i)=M(:,i).*(1+y).*obswind;
        case 2
            M(:,i)=exprnd(1,n1,1).*(1+y).*obswind;
        case 3
            M(:,i)=(1+0.1*randn(n1,1)).*(1+y).*obswind;
    end
end

out=edit_gd2(out,'y',M);