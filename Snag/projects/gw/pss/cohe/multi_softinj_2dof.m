function stat=multi_softinj_2dof(fr0,band,gdat,sour,sig0,sig45,Nmax,wien)
% MULTI_SOFTINJ_2DOF  many software injection analysis
%
%     stat=multi_softinj_2dof(dat,sour)
%
%    fr0         (corrected) frequency; if fr0(1)=0 uses the data in the cont structure
%    band        band for analysis around ([frmin frmax] of output frequency);
%                if only one number, half-bandwidth around f0; 0 -> default (f0+-0.05 Hz)
%    gdata       gd with the time domain data (created by a pss_recos)
%    sour        source; if the sigs are present, only the 4 pol/amp parameters are used
%    sig0        gd with the simulation of signal of lin pol psi=0 (by sfdb09_band2sbl); or source
%    sig45       gd with the simulation of signal of lin pol psi=45; or antenna
%    N           maximim number of values
%    wien        Wiener filter

% Version 2.0 - April 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

ST=86164.09053083288;

pars=cont_gd(gdat);
fr0a=fr0;
if fr0 == 0
    fr0a=pars.appf0;
end
fr0=mod(fr0a,1/dx_gd(gdat));

if length(band) == 1
    if band <= 0
        band=0.05;
    end
    band=[fr0-band fr0+band];
end

disp(sprintf(' fr0_input = %f, fr0_subsamp = %f  band = [%f,%f]',fr0a,fr0,band))

if isa(sig0,'gd')
    v5sig0=compute_5comp(sig0,fr0,wien);
    v5sig45=compute_5comp(sig45,fr0,wien);
elseif isstruct(sig0)
elseif isnumeric(sig0)
    v5sig0=sig0;
    v5sig45=sig45;
else
end

[Hp Hc]=etapsi2ab(sour.eta,sour.psi);
v5sig=sour.h*(Hp*v5sig0+Hc*v5sig45)*1e20;
% v5s(1,:)=sour.h0*(Hp*v5sig0)*1e20;
% v5s(2,:)=sour.h0*(Hc*v5sig45)*1e20;

y=y_gd(gdat);
dt=dx_gd(gdat);
n=length(y);
k4=4;

N=round(ceil(k4*n*dt/ST)*ST/dt);
y(n:N)=0;

DF=1/(N*dt);
dn=round(1/(DF*ST));
y=fft(y);
k1=round(band(1)/DF)+1;
k2=round(band(2)/DF);
inif=(k1-1)*DF;
y=y(k1:k2)*dt;
n=length(y);

n4=round(n-4*dn);
n2=round(n4*0.975/2);
fprintf('dn,n4,n2 = %d  %d  %d \n',dn,n4,n2)

outn=zeros(2,n-4*dn);
outs=outn;
out2n=zeros(1,n-4*dn);
out2s=out2n;
sig(1,:)=v5sig0;
sig(2,:)=v5sig45;
mf=sig*0;

% for i = 1:2
%     mf(i,:)=conj(sig(i,:))/sum(abs(sig(i,:)).^2);
%     outn(i,:)=mf(i,1)*y(1:n-4*dn)+mf(i,2)*y(1+dn:n-3*dn)+...
%         mf(i,3)*y(1+2*dn:n-2*dn)+mf(i,4)*y(1+3*dn:n-dn)+mf(i,5)*y(1+4*dn:n);
%     outs(i,:)=mf(i,1)*(y(1:n-4*dn)+v5s(i,1))+mf(i,2)*(y(1+dn:n-3*dn)+v5s(i,2))+...
%         mf(i,3)*(y(1+2*dn:n-2*dn)+v5s(i,3))+mf(i,4)*(y(1+3*dn:n-dn)+v5s(i,4))+...
%         mf(i,5)*(y(1+4*dn:n)+v5s(i,5));
% end

for i = 1:k4:n-4*dn
    v5n=[y(i) y(i+dn) y(i+2*dn) y(i+3*dn) y(i+4*dn)];
    v5s=v5n+v5sig;
    [h0(i) eta(i) psi(i) cohe(i)]=simp_estimate_psour(v5s,v5sig0,v5sig45);
%     if floor(i/10)*10 == i
%         disp(i)
%     end
%     fprintf('%d %d \n',N,i)
    if Nmax > 0
        if i > Nmax
            break
        end
    end
end

stat.h0=h0;
stat.eta=eta;
stat.psi=psi;
stat.cohe=cohe;