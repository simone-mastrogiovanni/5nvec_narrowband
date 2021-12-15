function out=mc_5vec(ant,sour,N,randph,icplot)
% montecarlo with 5-vect
%
%  ant    antenna (0             -> all parameters
%                  ant struct    -> fixed antenna)
%  sour   source  ([] or 0       -> all parameters
%                  [alpha,delta] -> fixed position
%                 sour struct    -> fixed source)
%  N      MC dimension
%  randph random phase (source RA: 0 or 1; def 0)

% Version 2.0 - August 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('randph','var')
    randph=0;
end
if ~exist('icplot','var')
    icplot=1;
end

kant=zeros(2,N);
if ~isstruct(ant)
    icant=1;
    coslat=2*rand(1,N)-1;
    kant(1,1:N)=acos(coslat)*180/pi;
    kant(2,1:N)=rand(1,N)*180;
    disp('random antenna')
    out.lat=kant(1,1:N);
    out.azim=kant(2,1:N);
else
    icant=0;
    kant(1,1:N)=ant.lat;
    kant(2,1:N)=ant.azim;
    disp('fixed antenna')
    out.lat=ant.lat;
    out.azim=ant.azim;
end

ksour=zeros(4,N);
if ~isstruct(sour) 
    cosiota=rand(1,N)*2-1;
    eta=-2*cosiota./(1+cosiota.^2);
    psi=rand(1,N)*90;
    if randph == 1
        ksour(4,1:N)=rand(1,N)*360;
    end
    if length(sour) == 2
        icsour=1;
        ksour(1,1:N)=sour(2);
        ksour(2,1:N)=eta;
        ksour(3,1:N)=psi;
        ksour(4,1:N)=sour(1);
        disp('fixed position source')
        out.alpha=sour(1);
        out.delta=sour(2);
        out.eta=eta;
        out.psi=psi;
    else
        icsour=2;
        cosdelta=rand(1,N)*2-1;
        ksour(1,1:N)=acos(cosdelta)*180/pi-90;
        ksour(2,1:N)=eta;
        ksour(3,1:N)=psi;
        disp('random source')
        out.alpha=0;
        out.delta=acos(cosdelta)*180/pi-90;
        out.eta=eta;
        out.psi=psi;
    end
else
    icsour=0;
    ksour(1,1:N)=sour.d;
    ksour(2,1:N)=sour.eta;
    ksour(3,1:N)=sour.psi;
    disp('fixed source')
    out.alpha=sour.a;
    out.delta=sour.d;
    out.eta=sour.eta;
    out.psi=sour.psi;
end

out.kant=kant;
out.ksour=ksour;

v=zeros(5,N);
ant=dummyant;
sour=pulsar_x;

for i = 1:N
    ant.lat=kant(1,i);
    ant.azim=kant(2,i);
    sour.d=ksour(1,i);
    sour.eta=ksour(2,i);
    sour.psi=ksour(3,i);
    sour.a=ksour(4,i);
    
    [~,~,~,~,v(:,i),~,~]=sour_ant_2_5vec(sour,ant,1);
end

out.v=v;

if icplot > 0
    [h1,x1]=hist(abs(v(1,:)),50);
    [h2,x2]=hist(abs(v(2,:)),50);
    [h3,x3]=hist(abs(v(3,:)),50);
    [h4,x4]=hist(abs(v(4,:)),50);
    [h5,x5]=hist(abs(v(5,:)),50);

    figure,stairs(x1,h1,'r'),hold on,stairs(x2,h2,'b'),stairs(x3,h3,'k')
    stairs(x4,h4,'c'),stairs(x5,h5,'m'),grid on,title('5 lines distribution')

    av=sqrt(sum(abs(v).^2));
    out.av=av;
    [h0,x0]=hist(av,50);
    figure,stairs(x0,h0),grid on,title('5-vect amplitudes')

    % figure,plot(abs(v(1,:)),abs(v(5,:)),'.'),hold on,title('2 vs -2'),grid on
    % figure,plot(abs(v(1,:)),abs(v(2,:)),'.'),hold on,title('1 vs -2'),grid on
    % figure,plot(abs(v(1,:)),abs(v(3,:)),'.'),hold on,title('0 vs -2'),grid on

    figure,plot(abs(v(1,:)),abs(v(5,:)),'r.'),hold on,title('0,1,2 vs -2'),grid on
    plot(abs(v(1,:)),abs(v(4,:)),'b.'),plot(abs(v(1,:)),abs(v(3,:)),'g.')

    figure,plot(abs(v(2,:)),abs(v(5,:)),'r.'),hold on,title('0,1,2 vs -1'),grid on
    plot(abs(v(2,:)),abs(v(4,:)),'b.'),plot(abs(v(2,:)),abs(v(3,:)),'g.')

    ang=angle(v)*180/pi;
    out.ang=ang;
    figure,plot(ang(1,:),ang(5,:),'.'),hold on,grid on
    plot(ang(1,:),ang(4,:),'r.'),plot(ang(1,:),ang(3,:),'g.'),title('angle 2,1,0 vs -2')

    figure,plot(ang(2,:),ang(5,:),'.'),hold on,grid on
    plot(ang(2,:),ang(4,:),'r.'),plot(ang(2,:),ang(3,:),'g.'),title('angle 2,1,0 vs -1')

    figure,plot(mod(ang(1,:)-ang(3,:),360),mod(ang(5,:)-ang(3,:),360),'r.'),hold on,grid on
    plot(mod(ang(2,:)-ang(3,:),360),mod(ang(4,:)-ang(3,:),360),'.'),title('angle 2 - 0 vs -2 - 0 and 1 - 0 vs -1 - 0')

    if icsour > 0
        figure,plot(ksour(2,:),abs(v(1,:)),'r.'),hold on,title('-2,-1,0,1,2 vs eta'),grid on
        plot(ksour(2,:),abs(v(2,:)),'b.'),plot(ksour(2,:),abs(v(3,:)),'g.')
        plot(ksour(2,:),abs(v(4,:)),'c.'),plot(ksour(2,:),abs(v(5,:)),'m.')
        xlabel('eta')

        figure,plot(ksour(3,:),abs(v(1,:)),'r.'),hold on,title('-2,-1,0,1,2 vs psi'),grid on
        plot(ksour(3,:),abs(v(2,:)),'b.'),plot(ksour(3,:),abs(v(3,:)),'g.')
        plot(ksour(3,:),abs(v(4,:)),'c.'),plot(ksour(3,:),abs(v(5,:)),'m.')
        xlabel('psi')
    end

    if icsour > 1
        figure,plot(ksour(1,:),abs(v(1,:)),'r.'),hold on,title('-2,-1,0,1,2 vs delta'),grid on
        plot(ksour(1,:),abs(v(2,:)),'b.'),plot(ksour(1,:),abs(v(3,:)),'g.')
        plot(ksour(1,:),abs(v(4,:)),'c.'),plot(ksour(1,:),abs(v(5,:)),'m.')
        xlabel('delta')
    end

    if randph == 1
        figure,plot(ksour(4,:),mod(ang(1,:)-ang(5,:),360),'r.'),hold on,grid on,title('angle difference vs alpha')
        plot(ksour(4,:),mod(ang(2,:)-ang(4,:),360),'b.'),plot(ksour(4,:),mod(ang(3,:),360),'g.')
    end

    figure,plot(av,abs(v(1,:)),'r.'),hold on,grid on,plot(av,abs(v(2,:)),'b.'),title('lines vs av')
    plot(av,abs(v(3,:)),'g.'),plot(av,abs(v(4,:)),'c.'),plot(av,abs(v(5,:)),'m.')

    if icsour == 2
        figure,plot(ksour(1,:),av,'r.'),hold on,grid on,title('av vs delta')
    end
end