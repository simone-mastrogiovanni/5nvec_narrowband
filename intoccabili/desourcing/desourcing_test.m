[function out_cell=desourcing_test(ggnames,name_H,name_L,ant_H,ant_L,sour,alfa_des,delta_des,width_alfa,width_delta,sky_res)

% ggnames: Name of the BSD that contains the outliers
% name_H: Name of the of the gd in BSD file for the I IFO CLEANED
% name_L: Name of the of the gd in BSD for the II IFO CLEANED
% ant_H: First IFO
% ant_L: Second IFO
% sour: Source structure containing the candidate
% alfa_des: central point in R.A. for the desourcing
% beta_des: central point in dec. for the desourcing
% width_alfa: Window in deg on R.A. for the desourcing
% width_delta: Window in deg on dec. for the desourcing
% sky_bin: Resolution of the desourcing

%%%%% Compute the grid in the sky where to calculate the desourcing
alpha=alfa_des;
delta=delta_des;
alpha=alfa_des+(-round(width_alfa/sky_res):1:round(width_alfa/sky_res));
delta=delta_des+(-round(width_delta/sky_res):1:round(width_delta/sky_res));
[alpha,delta]=meshgrid(alpha,delta);
ss=size(alpha);
alpha=reshape(alpha,ss(1)*ss(2),1);
delta=reshape(delta,ss(1)*ss(2),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

S_vec=ones(1,length(alpha));
Hp_vec=ones(1,length(alpha));
Hc_vec=ones(1,length(alpha));
h0_vec=ones(1,length(alpha));
eta_vec=ones(1,length(alpha));
psi_vec=ones(1,length(alpha));
phi0_vec=ones(1,length(alpha));

load(ggnames) % Read the gd or the BSD without Doppler corrections

gdin=eval(name_H);
cont=cont_gd(gdin);
t0=cont.t0;
sournew=new_posfr(sour,t0); % Shift the source parameters to the gd ref time
fr=[sournew.f0,sournew.df0,sournew.ddf0]; % fr0,dfr0,ddfr0 for the source
VPstr=extr_velpos_gd(gdin);

p0=interp_VP(VPstr,sour);


%Romer corrections for the first gd
eval(['[' name_H ',corr]=vfs_subhet_pos(gdin,fr,p0);'])
N=n_gd(gdin);
dt=dx_gd(gdin);
gdpar=[dt,N];
sdpar=fr(2:length(fr));

%Spin-down corrections for the second gd
eval('sd=vfs_spindown(gdpar,sdpar,1);')
eval(['[' name_H '_sd, corr]=vfs_subhet(' name_H ',sd);'])

gdin=eval(name_L);
cont=cont_gd(gdin);
t0=cont.t0;
sournew=new_posfr(sour,t0);
fr=sournew.f0;
fr=[sournew.f0,sournew.df0,sournew.ddf0];
VPstr=extr_velpos_gd(gdin);
p0=interp_VP(VPstr,sour);


%Doppler correction for the second IFO
eval(['[' name_L ',corr]=vfs_subhet_pos(gdin,fr,p0);'])
N=n_gd(gdin);
dt=dx_gd(gdin);
gdpar=[dt,N];
sdpar=fr(2:length(fr));

%Spindown correction for the second IFO
eval('sd=vfs_spindown(gdpar,sdpar,1);')
eval(['[' name_L '_sd, corr]=vfs_subhet(' name_L ',sd);'])


ggH=eval([name_H,'_sd']);
ggL=eval([name_L,'_sd']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Block for softweare injenction (tests)
%     yh=y_gd(ggH);
%     yl=y_gd(ggL);
%     yh=randn(size(yh))+1j*rand(size(yh));
%     yl=randn(size(yl))+1j*rand(size(yl));
%     ggH=edit_gd(ggH,'y',yh);
%     ggL=edit_gd(ggL,'y',yl);
%     yh=y_gd(ggH);
%     iih=find(yh~=0); % find science mode
%     Th=length(iih)*dt; % Actual observation time
%     sig2h=var(yh(iih)); % Sigma of non-science mode
%     yl=y_gd(ggL);
%     iil=find(yl~=0);
%     Tl=length(iil)*dt;
%     sig2l=var(yl);
%     sig2h=((1/sig2h)+(1/sig2l))^-1;
%     Th=Th+Tl;
%     ah=8*sqrt(sig2h/(Th)); % Qui va il rapporto segnale rumore
%     psi=(rand*90-45)*pi/180;
%     eta=rand*2-1;
%     ggH=gen_sig_BSD(ggH,ah,eta,psi,sournew,ligoh,0,0); % This function inject a signal in a BSD
%     ggL=gen_sig_BSD(ggL,ah,eta,psi,sournew,ligol,0,0); % This function inject a signal in a BSD
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars -except ggH ant_H sour sournew name_H name_L ggL ant_L S Hp Hc h0 eta psi phi0 ggnames alpha delta

[S,Hp,Hc,h0,eta,psi,phi0,Ap_5vec,Ac_5vec,Ap_5vec_2,Ac_5vec_2]=compute_DS_from_BSD_gd(ggH,ant_H,sournew,round((dx_gd(ggH))^-1),ggL,ant_L);

S_open_box=S;
Hp_open_box=Hp;
Hc_open_box=Hc;
h0_open_box=h0;
eta_open_box=eta;
psi_open_box=psi;
phi0_open_box=phi0;
vec_open_box=[S_open_box, Hp_open_box, Hc_open_box,h0_open_box,eta_open_box,psi_open_box,phi0_open_box];
clearvars -except vec_open_box Ap_5vec Ac_5vec Ap_5vec_2 Ac_5vec_2 ggnames ant_H ant_L sour name_H name_L fr alpha delta S_vec Hp_vec Hc_vec h0_vec eta_vec psi_vec phi0_vec
close all


load(ggnames) % Read the gd or the BSD without Doppler corrections
    gdin_oH=eval(name_H);
        gdin_oL=eval(name_L);


for i=1:1:length(alpha)
    tic
    sour.a=alpha(i); % New R.A. for the desourcing
    sour.d=delta(i); % New decl for the desourcing
    cont=cont_gd(gdin_oH);
    t0=cont.t0;
    sournew=new_posfr(sour,t0); % Shift the source parameters to the gd ref time
    fr=[sournew.f0,sournew.df0,sournew.ddf0]; % fr0,dfr0,ddfr0 for the source
    VPstr=extr_velpos_gd(gdin_oH);
    p0=interp_VP(VPstr,sour);
    
    
    %Romer corrections for the first gd
    eval(['[' name_H ',corr]=vfs_subhet_pos(gdin_oH,fr,p0);'])
    N=n_gd(gdin_oH);
    dt=dx_gd(gdin_oH);
    gdpar=[dt,N];
    sdpar=fr(2:length(fr));
    
    %Spin-down corrections for the second gd
    eval('sd=vfs_spindown(gdpar,sdpar,1);')
    eval(['[' name_H '_sd, corr]=vfs_subhet(' name_H ',sd);'])
    
    sour.a=alpha(i); % New R.A. for the desourcing
    sour.d=delta(i); % New decl for the desourcing
    cont=cont_gd(gdin_oL);
    t0=cont.t0;
    sournew=new_posfr(sour,t0);
    fr=sournew.f0;
    fr=[sournew.f0,sournew.df0,sournew.ddf0];
    VPstr=extr_velpos_gd(gdin_oL);
    p0=interp_VP(VPstr,sour);
    
    
    %Doppler correction for the second IFO
    eval(['[' name_L ',corr]=vfs_subhet_pos(gdin_oL,fr,p0);'])
    N=n_gd(gdin_oL);
    dt=dx_gd(gdin_oL);
    gdpar=[dt,N];
    sdpar=fr(2:length(fr));
    
    %Spindown correction for the second IFO
    eval('sd=vfs_spindown(gdpar,sdpar,1);')
    eval(['[' name_L '_sd, corr]=vfs_subhet(' name_L ',sd);'])
    
    
    ggH=eval([name_H,'_sd']);
    ggL=eval([name_L,'_sd']);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Block for softweare injenction (tests)
%     yh=y_gd(ggH);
%     yl=y_gd(ggL);
%     yh=randn(size(yh))+1j*rand(size(yh));
%     yl=randn(size(yl))+1j*rand(size(yl));
%     ggH=edit_gd(ggH,'y',yh);
%     ggL=edit_gd(ggL,'y',yl);
%     yh=y_gd(ggH);
%     iih=find(yh~=0); % find science mode
%     Th=length(iih)*dt; % Actual observation time
%     sig2h=var(yh(iih)); % Sigma of non-science mode
%     yl=y_gd(ggL);
%     iil=find(yl~=0);
%     Tl=length(iil)*dt;
%     sig2l=var(yl);
%     sig2h=((1/sig2h)+(1/sig2l))^-1;
%     Th=Th+Tl;
%     ah=8*sqrt(sig2h/(Th)); % Qui va il rapporto segnale rumore
%     psi=(rand*90-45)*pi/180;
%     eta=rand*2-1;
%     ggH=gen_sig_BSD(ggH,ah,eta,psi,sournew,ligoh,0,0); % This function inject a signal in a BSD
%     ggL=gen_sig_BSD(ggL,ah,eta,psi,sournew,ligol,0,0); % This function inject a signal in a BSD
%     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    clearvars -except i vec_open_box sournew sour alpha delta ggH ggL gdin_oL gdin_oH Ap_5vec Ac_5vec Ap_5vec_2 Ac_5vec_2 ggnames ant_H ant_L sour name_H name_L fr alpha delta S_vec Hp_vec Hc_vec h0_vec eta_vec psi_vec phi0_vec
    
    [S,Hp,Hc,h0,eta,psi,phi0]=compute_DS_for_desourcing(ggH,ant_H,sournew,round((dx_gd(ggH))^-1),Ap_5vec,Ac_5vec,ggL,ant_L,Ap_5vec_2,Ac_5vec_2);
    
    S_vec(i)=S;
    Hp_vec(i)=Hp;
    Hc_vec(i)=Hc;
    h0_vec(i)=h0;
    eta_vec(i)=eta;
    psi_vec(i)=psi;
    phi0_vec(i)=phi0;
    
    clearvars -except i vec_open_box sour  gdin_oL gdin_oH Ap_5vec Ac_5vec Ap_5vec_2 Ac_5vec_2 ggnames ant_H ant_L sour name_H name_L fr alpha delta S_vec Hp_vec Hc_vec h0_vec eta_vec psi_vec phi0_vec
    close all
    toc
    
end

out_cell{1}=vec_open_box;
out_cell{2}=S_vec;
out_cell{3}=Hp_vec;
out_cell{4}=Hc_vec;
out_cell{5}=h0_vec;
out_cell{6}=eta_vec;
out_cell{7}=psi_vec;
out_cell{8}=phi0_vec;



end
