function [sidpat,ftsp,v,parout]=sidpat_mode_study(sour,ant,par)
% sidereal power pattern and 5-vec for all eta and psi
%
%     [sidpat,ftsp,v]=sidpat_mode_study(sour,ant,par)
%
%  sour,ant   source and antenna structures
%  par        parameters structure
%   .nsid       number of points in the sidereal day (def 240, negative plots)
%   .deta       def = 0.01;
%   .dpsi       def = 1;
%   .etas       default 0:deta:1
%   .psis       default 0:dpsi:90
%   .culm       =1 culmination 5-vect (or basic 5-vect; def 1) 
%   .show       0 nothing (def)
%               1 5-vec
%               2 4-vec (sidpat components)
%               3 sidpat
%   .showsum    def 1
%   .order      1 psi first (def)
%               2 eta first
%               3 random
%   .rangeeta   [min eta max eta] for random
%   .rangepsi   [min psi max psi] for random
%   .nrandom    number of random data
%   .pause      pause dt (def 0.01)
%   .hold       =1 (persistence; default)
%   .symb       symbol (def '.' and 'x')

% Version 2.0 - June 2019
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('par','var')
    par=struct();
end
if ~isfield(par,'nsid')
    par.nsid=240;
end
nsid=par.nsid;
if ~isfield(par,'deta')
    par.deta=0.01;
end
deta=par.deta;
if ~isfield(par,'dpsi')
    par.dpsi=1;
end
dpsi=par.dpsi;
if ~isfield(par,'etas')
    par.etas=-1:deta:1;
end
etas=par.etas;
if ~isfield(par,'psis')
    par.psis=0:dpsi:90;
end
psis=par.psis;
if ~isfield(par,'culm')
    par.culm=1;
end
culm=par.culm;
if ~isfield(par,'show')
    par.show=0;
end
show=par.show;
icplot=0;
if show > 0
    icplot=1;
end
if ~isfield(par,'showsum')
    par.showsum=1;
end
showsum=par.showsum;
if ~isfield(par,'pause')
    par.pause=0.01;
end
dt=par.pause;
if ~isfield(par,'hold')
    par.hold=1;
end
icholdon=par.hold;
if ~isfield(par,'order')
    par.order=1;
end
icorder=par.order;

hour=(0:nsid-1)*24/nsid;
if icplot == 1
    figure
end

parout=par;

if icorder == 1
    for i = 1:length(etas)
        sour.eta=etas(i);
        for j = 1:length(psis)
            sour.psi=psis(j);

            [L0 L45 CL CR vv Hp Hc]=sour_ant_2_5vec(sour,ant,culm);
            v{i,j}=vv;

            st=(0:nsid-1)*2*pi/nsid;

            lf=0;
            for k = 1:5
                lf=lf+vv(k)*exp(1j*(k-3)*st);
            end

            sidpat{i,j}=abs(lf).^2;
            ftsp1=fft(sidpat{i,j});
            fnorm=sqrt(sum(abs(ftsp1).^2));
            ftsp{i,j}=ftsp1/fnorm;
            if show == 1
                if ~isfield(par,'symb')
                    par.symb='.';
                end
                plot(vv,par.symb),grid on,%xlim([-50 50]),ylim([-50 50])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                plot(sum(vv),'o')
                pause(dt)
                if icholdon
                    hold on
                end
            end
            if show == 2
                if ~isfield(par,'symb')
                    par.symb='x';
                end
                plot(ftsp1(2:5),par.symb),grid on,xlim([-50 50]),ylim([-50 50])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                plot(sum(ftsp1(2:5)),'o')
                pause(dt)
                if icholdon
                    hold on
                end
            end
            if show == 3
                plot(hour,sidpat{i,j}),grid on,xlim([0 24]),ylim([0 1])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                pause(dt)
            end
        end
    end
elseif icorder == 2
    for j = 1:length(psis)
        sour.psi=psis(j);
        for i = 1:length(etas)
            sour.eta=etas(i);

            [L0 L45 CL, CR vv Hp Hc]=sour_ant_2_5vec(sour,ant,culm);
            v{i,j}=vv;

            st=(0:nsid-1)*2*pi/nsid;

            lf=0;
            for k = 1:5
                lf=lf+vv(k)*exp(1j*(k-3)*st);
            end

            sidpat{i,j}=abs(lf).^2;
            ftsp1=fft(sidpat{i,j});
            fnorm=sqrt(sum(abs(ftsp1).^2));
            ftsp{i,j}=ftsp1/fnorm;
            if show == 1
                if ~isfield(par,'symb')
                    par.symb='.';
                end
                plot(vv,par.symb),grid on,%xlim([-50 50]),ylim([-50 50])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                plot(sum(vv),'o')
                pause(dt)
                if icholdon
                    hold on
                end
            end
            if show == 2
                if ~isfield(par,'symb')
                    par.symb='x';
                end
                plot(ftsp1(2:5),par.symb),grid on,xlim([-50 50]),ylim([-50 50])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                plot(sum(ftsp1(2:5)),'o')
                pause(dt)
                if icholdon
                    hold on
                end
            end
            if show == 3
                plot(hour,sidpat{i,j}),grid on,xlim([0 24]),ylim([0 1])
                title(sprintf('eta = %f,  psi = %f',etas(i),psis(j)))
                pause(dt)
            end
        end
    end
else   
    if ~isfield(par,'nrandom')
        par.nrandom=1000;
    end
    nrandom=par.nrandom; 
    if ~isfield(par,'rangeeta')
        par.rangeeta=[-1 1];
    end
    rangeeta=par.rangeeta; 
    if ~isfield(par,'rangepsi')
        par.rangepsi=[0 90];
    end
    rangepsi=par.rangepsi;
    r1=rand(1,nrandom);
    r2=rand(1,nrandom);
    
    psis=rangepsi(1)+(rangepsi(2)-rangepsi(1))*rand(1,nrandom);
    if rangeeta(1) == -1 && rangeeta(2) == 1 
        cosiota=rand(1,nrandom)*2-1;
        etas=-2*cosiota./(1+cosiota.^2);
    else
        etas=rangeeta(1)+(rangeeta(2)-rangeeta(1))*rand(1,nrandom);
    end
    
    for i = 1:nrandom
        sour.eta=etas(i);
        sour.psi=psis(i);

        [L0 L45 CL CR vv Hp Hc]=sour_ant_2_5vec(sour,ant,culm);
        v{i}=vv;

        st=(0:nsid-1)*2*pi/nsid;

        lf=0;
        for k = 1:5
            lf=lf+vv(k)*exp(1j*(k-3)*st);
        end

        sidpat{i}=abs(lf).^2;
        ftsp1=fft(sidpat{i});
        fnorm=sqrt(sum(abs(ftsp1).^2));
        ftsp{i}=ftsp1/fnorm;
        if show == 1
            if ~isfield(par,'symb')
                par.symb='.';
            end
            plot(vv,par.symb),grid on,%xlim([-50 50]),ylim([-50 50])
            title(sprintf(' i = %d',i))
            if showsum > 0
                plot(sum(vv),'o')
            end
            pause(dt)
            if icholdon
                hold on
            end
        end
        if show == 2
            if ~isfield(par,'symb')
                par.symb='x';
            end
            plot(ftsp1(2:5),par.symb),grid on,xlim([-50 50]),ylim([-50 50])
            title(sprintf(' i = %d',i))
            if showsum > 0
                plot(sum(ftsp1(2:5)),'o')
            end
            pause(dt)
            if icholdon
                hold on
            end
        end
        if show == 3
            plot(hour,sidpat{i}),grid on,xlim([0 24]),ylim([0 1])
            title(sprintf(' i = %d',i))
            pause(dt)
        end
    end  
end