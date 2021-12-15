function [gin geq Xtot A0tot A45tot]=multi_detector(sour, varargin)
% MULTI_DETECTOR   function to perform parameter estimation, coherence and
% snr computation using 5(n)-vectors

% Input:
%   sour:       source structure
%   varargin:   cell array with variable number of components (depending on
%               the number of datasets to be analyzed)
%               For each dataset the cell array components are:
%                - input data gd (down-sampled data after Doppler, spin-down etc
%                corrections);
%                - antenna structure;
%                - threshold for final removal of outliers.
%               
% Output:   
%   gin:            cleaned input gd
%   geq:            folded and equalized input gd
%   Xtot:           data 5n-vector
%   A0tot,A45tot:   signal templates 5n-vectors
%
% References:
% ref.1: CQG 27 194016 (2010)
% ref.2: ApJ 737 93 (2011)
% ref.3: JPCS 363 012038 (2012)
%
% C. Palomba (INFN Roma) and Roma CW group (March 2012)
%
% Updated 1 August 2012: added computation of snr using "equivalent signal" 

C=299792.458; 
SD=86164.09053083288;

nsid=10000;

var0n=0;
var0d=0;
var45n=0;
var45d=0;
var0n_eq=0;
var0d_eq=0;
var45n_eq=0;
var45d_eq=0;

res=fopen('pe_results.txt','w');
fprintf(res,'Parameter estimation results - %s\n \n',datestr(clock));
fprintf('Number of datasets: %d\n',nargin);
ndataset=numel(varargin{:})/3;
A0=zeros(ndataset,5);
A45=A0;
X=A0;

for i=1:ndataset
    gin=varargin{1}{i+2*(i-1)}
    ant=varargin{1}{i+2*(i-1)+1}
    thr=varargin{1}{i+2*(i-1)+2}
    
    fprintf(res,'Dataset %d\n',i);
    %vname=@(x) inputname(1);
    %s1=vname(varargin{1}{i+2*(i-1)});
    %s2=vname(varargin{1}{i+2*(i-1)+1});
    fprintf(res,'threshold= %f\n \n',thr);
    dt=dx_gd(gin); % input data sampling time
    N=n_gd(gin);   % input data number of samples  
    cont=cont_gd(gin); % input data cont structure
    t0=cont.t0; % reference time
    fr=cont.appf0; % reference search frequency
    fr0=fr-floor(fr*dt)/dt; % fractional part of the signal frequency
    
    if i==1
        tref=t0;
    end
    
    gin=rough_clean(gin,-thr,thr,60); % removal of outliers using threshold thr
    y=y_gd(gin);
    %%%%%%%%%%%%%
    % limit data to an integer number of sidereal day
    % In fact this has no effect on the parameter estimation so by default
    % we do not use it (was not used in the single detector analysis).
    % t1=length(y)*dt;
    % n1=round(floor(t1/SD)*SD/dt);
    % y=y(1:n1);
    % gin=edit_gd(gin,'y',y);
    % N=n_gd(gin);
    %%%%%%%%%%%%%%%
    
    obs=check_nonzero(gin,1); % array of 1s (when data sample is non-zero) and zeros 
    X(i,:)=compute_5comp_num(gin,fr0); % compute data 5-vector
    
    % generate signal templates and compute corresponding 5-vects
    if i==1
        ph0=mod(fr0*dt*(0:N-1),1)*2*pi; % template phase
    else
        ph0=mod(fr0*dt*(0:N-1)+fr0*(t0-tref)*86400,1)*2*pi;
    end
    stsub=gmst(t0)+dt*(0:N-1)*(86400/SD)/3600; % running Greenwich mean sidereal time 
    isub=mod(round(stsub*(nsid-1)/24),nsid-1)+1; % time indexes at which the sidereal response is computed
    [~, ~ , ~, ~, sid1 sid2]=check_ps_lf(sour,ant,nsid); % computation of the sidereal response
    gl0=sid1(isub).*exp(1j*ph0); % + signal template
    gl0=edit_gd(gin,'y',gl0.*obs');
    gl45=sid2(isub).*exp(1j*ph0); % x signal template
    gl45=edit_gd(gin,'y',gl45.*obs');
    A0(i,:)=compute_5comp_num(gl0,fr0); % compute 5-vector for + signal template
    A45(i,:)=compute_5comp_num(gl45,fr0); % compute 5-vector for x signal template
    
    [h0 eta psi cohe phi0]=estipar(X(i,:),A0(i,:),A45(i,:)); % parameter and coherence estimation
    fprintf('dataset %d --- h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',i,h0,eta,psi,cohe,phi0)
    fprintf(res,'h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0,eta,psi,cohe,phi0);
    
    % snr computations
    Hp=sqrt(1/(1+eta^2))*(cos(2*psi)-1j*eta*sin(2*psi)); % estimated + complex amplitude (Eq.2 of ref.1)
    Hc=sqrt(1/(1+eta^2))*(sin(2*psi)+1j*eta*cos(2*psi)); % estimated x complex amplitude (Eq.3 of ref.1)
    hoft=Hp*y_gd(gl0)+Hc*y_gd(gl45); % estimated full time domain signal (unit amplitude)
    yy=y(y~=0);
    snr_standard=h0*sqrt(sum(abs(hoft).^2)*dt)/std(yy); % "standard" snr 
    
    y=y_gd(gin);
    ynz=length(find(y));
    sigmaX=std(y)*sqrt(ynz*dt); % standard deviation of each component of data 5-vector (Sec. 2.1 of ref.3)
    snr_5vect=h0*norm(A0(i,:))*norm(A45(i,:))/(sigmaX*sqrt(norm(A0(i,:)).^2+norm(A45(i,:)).^2)); % 5-vector based snr 
    % (Eq. 14 of ref.3)
    fprintf('snr_standard=%f snr_5vect=%f\n',snr_standard,snr_5vect);
    fprintf(res,'snr_standard=%f snr_5vect=%f\n \n',snr_standard,snr_5vect);
    
    % terms to be used for (the wrong) 5-vector based snr computation in the multi-datasets
    % case, see later
    var0n=var0n+sigmaX^2*norm(A0(i,:)).^2;
    var0d=var0d+norm(A0(i,:)).^2;
    var45n=var45n+sigmaX^2*norm(A45(i,:)).^2;
    var45d=var45d+norm(A45(i,:)).^2;
    
    % create 5n-vectors (definition Eq.15 of ref.3)
    if i==1
        A0tot=A0(i,:);
        A45tot=A45(i,:);
        Xtot=X(i,:);
        A0norm2=norm(A0(i,:)).^2;
        A45norm2=norm(A45(i,:)).^2;
    else
        A0tot=[A0tot A0(i,:)];
        A45tot=[A45tot A45(i,:)];
        Xtot=[Xtot X(i,:)];
        A0norm2=A0norm2+norm(A0(i,:)).^2;
        A45norm2=A45norm2+norm(A45(i,:)).^2;
    end
    
    % Now let us make the analysis using folded and equalized data
    
    [geq weq]=tsid_equaliz(gin,1,ant); % data folding 
    [gl0_eq weq0]=tsid_equaliz(gl0,1,ant); % signal + template folding
    [gl45_eq weq45]=tsid_equaliz(gl45,1,ant); % signal x template folding
    
    % equalize 
    geq=geq./weq;
    gl0_eq=gl0_eq./weq0;
    gl45_eq=gl45_eq./weq45;
    
    
    % compute 5-vectors for equalized data and templates 
    Xeq(i,:)=compute_5comp_num(geq,0);
    A0_eq(i,:)=compute_5comp_num(gl0_eq,0);
    A45_eq(i,:)=compute_5comp_num(gl45_eq,0);
    
    %  parameter estimation using equalized 5-vectors
    [h0_eq eta_eq psi_eq cohe_eq phi0_eq]=estipar(Xeq(i,:),A0_eq(i,:),A45_eq(i,:));
    fprintf('dataset %d equalized --- h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',i,h0_eq,eta_eq,psi_eq,cohe_eq,phi0_eq);
    fprintf(res,'Equalized data\n');
    fprintf(res,'h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0_eq,eta_eq,psi_eq,cohe_eq,phi0_eq);
    
    % "standard" snr computation
    y_eq=y_gd(geq);
    hoft_eq=Hp*y_gd(gl0_eq)+Hc*y_gd(gl45_eq);
    snr_standard_eq=h0_eq*sqrt(sum(abs(hoft_eq).^2)*dt)/std(y_eq);
    
    % 5-vector based snr computation
    ynz_eq=length(find(y_eq));
    sigmaX_eq=std(y_eq)*sqrt(ynz_eq*dt);
    snr_eq_5vect=h0_eq*norm(A0_eq(i,:))*norm(A45_eq(i,:))/(sigmaX_eq*sqrt(norm(A0_eq(i,:)).^2+norm(A45_eq(i,:)).^2));
    fprintf('snr_standard=%f snr_5vect=%f\n',snr_standard_eq,snr_eq_5vect);
    fprintf(res,'snr_standard=%f snr_5vect=%f\n \n \n',snr_standard_eq,snr_eq_5vect);
    
    % terms to be used for (the wrong) 5-vector based snr computation in the multi-datasets
    % case, see later
    var0n_eq=var0n_eq+sigmaX_eq^2*norm(A0_eq(i,:)).^2;
    var0d_eq=var0d_eq+norm(A0_eq(i,:)).^2;
    var45n_eq=var45n_eq+sigmaX_eq^2*norm(A45_eq(i,:)).^2;
    var45d_eq=var45d_eq+norm(A45_eq(i,:)).^2;
    
    % create 5n-vectors from equalized 5-vectors
    if i==1
        A0_eqtot=A0_eq(i,:);
        A45_eqtot=A45_eq(i,:);
        Xeqtot=Xeq(i,:);
        A0norm2_eq=norm(A0_eq(i,:)).^2;
        A45norm2_eq=norm(A45_eq(i,:)).^2;
    else
        A0_eqtot=[A0_eqtot A0_eq(i,:)];
        A45_eqtot=[A45_eqtot A45_eq(i,:)];
        Xeqtot=[Xeqtot Xeq(i,:)];
        A0norm2_eq=A0norm2_eq+norm(A0_eq(i,:)).^2;
        A45norm2_eq=A45norm2_eq+norm(A45_eq(i,:)).^2;
    end
    
% cell array containing data and signal templates (to be used for the "equivalent" signal)     
cont_gin{i}=gin;
cont_gl0{i}=gl0;
cont_gl45{i}=gl45;
cont_hoft{i}=Hp*gl0+Hc*gl45;

cont_geq{i}=geq;
cont_gl0_eq{i}=gl0_eq;
cont_gl45_eq{i}=gl45_eq;
cont_hoft_eq{i}=Hp*gl0_eq+Hc*gl45_eq;
end
   
[h0 eta psi cohe phi0]=estipar(Xtot,A0tot,A45tot); % parameter and coherence estimation with 5n-vectors
fprintf('combination --- h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0,eta,psi,cohe,phi0);
fprintf(res,'Coherent combination (5n-vectors)\n');
fprintf(res,'h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0,eta,psi,cohe,phi0);

% (wrong) 5n-vector based snr computation
varh=var0n/var0d^2+var45n/var45d^2;
snr_5nvect=h0/sqrt(varh);
fprintf('snr_5nvect=%f\n',snr_5nvect);
fprintf(res,'snr_5nvect=%f\n \n',snr_5nvect);

[h0_eq eta_eq psi_eq cohe_eq phi0_eq]=estipar(Xeqtot,A0_eqtot,A45_eqtot); % parameter and coherence estimation with 5n-vectors (equalized data)
fprintf('combination equalized--- h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0_eq,eta_eq,psi_eq,cohe_eq,phi0_eq);
fprintf(res,'Coherent combination equalized\n');
fprintf(res,'h0=%e  eta=%f  psi=%f  cohe=%f phi0=%f\n',h0_eq,eta_eq,psi_eq,cohe_eq,phi0_eq);

% (wrong) 5n-vector based snr computation (equalized data)
varh_eq=var0n_eq/var0d_eq^2+var45n_eq/var45d_eq^2;
snr_eq_5nvect=h0_eq/sqrt(varh_eq);
fprintf('snr_5nvect=%f\n',snr_eq_5nvect);
fprintf(res,'snr_5nvect=%f\n \n',snr_eq_5nvect);

% Here we introduce the "equivalent" signal and use it to compute the snr.
% We also use it to estimate parameters and check if, as expected, they are equal to
% those computed using 5n-vectors.

snr_equiv=0;
Hp_equiv=0;
Hc_equiv=0;
Hp_eq_equiv=0;
Hc_eq_equiv=0;
snr_equiv_eq=0;

% compute the "equivalent" signal (first using normal data and then using
% equalized and folded data). See mainly slide 6 of document
% snr_summary.pdf discussed in 9th review telecon.
Xequiv_plus=zeros(ndataset,5);
Xequiv_cross=Xequiv_plus;
Xeq_equiv_plus=Xequiv_plus;
Xeq_equiv_cross=Xequiv_plus;
for i=1:ndataset
    gd_equiv_plus{i}=(norm(A0(i,:)).^2/A0norm2)*cont_gin{i}; % + component of the "equivalent" signal
    gd_equiv_cross{i}=(norm(A45(i,:)).^2/A45norm2)*cont_gin{i}; % x component of the "equivalent" signal
    Xequiv_plus(i,:)=compute_5comp_num(gd_equiv_plus{i},fr0); % 5-vector for the + component of the "equivalent" signal
    Xequiv_cross(i,:)=compute_5comp_num(gd_equiv_cross{i},fr0); % 5-vector for the x component of the "equivalent" signal
    mf0=conj(A0(i,:))./norm(A0(i,:)).^2; % matched filter for + component
    mf45=conj(A45(i,:))./norm(A45(i,:)).^2; % matched filter for x component
    Hp_equiv=Hp_equiv+sum(Xequiv_plus(i,:).*mf0); % + amplitude estimator 
    Hc_equiv=Hc_equiv+sum(Xequiv_cross(i,:).*mf45); % x amplitude estimator
    
    % snr computation using the "equivalent" signal (see last equation in
    % slide 6 of snr_summary.pdf document)
    yplus_hoft=Hp*y_gd(cont_gl0{i});
    ycross_hoft=Hc*y_gd(cont_gl45{i});
    yplus_equiv=y_gd(gd_equiv_plus{i});
    yplus_equiv=yplus_equiv(yplus_equiv~=0);
    ycross_equiv=y_gd(gd_equiv_cross{i});
    ycross_equiv=ycross_equiv(ycross_equiv~=0);
    
    hoft_plus_equiv=yplus_hoft*norm(A0(i,:)).^2/A0norm2;
    hoft_cross_equiv=ycross_hoft*norm(A45(i,:)).^2/A45norm2;
    snr_equiv=snr_equiv+norm(hoft_plus_equiv).^2*dt/var(yplus_equiv)+norm(hoft_cross_equiv).^2*dt/var(ycross_equiv);
    
    % Now let us use equalization
    geq_equiv_plus{i}=(norm(A0_eq(i,:)).^2/A0norm2_eq)*cont_geq{i};
    geq_equiv_cross{i}=(norm(A45_eq(i,:)).^2/A45norm2_eq)*cont_geq{i};
    Xeq_equiv_plus(i,:)=compute_5comp_num(geq_equiv_plus{i},0);
    Xeq_equiv_cross(i,:)=compute_5comp_num(geq_equiv_cross{i},0);
    mf0_eq=conj(A0_eq(i,:))./norm(A0_eq(i,:)).^2;
    mf45_eq=conj(A45_eq(i,:))./norm(A45_eq(i,:)).^2;
    Hp_eq_equiv=Hp_eq_equiv+sum(Xeq_equiv_plus(i,:).*mf0_eq);
    Hc_eq_equiv=Hc_eq_equiv+sum(Xeq_equiv_cross(i,:).*mf45_eq);
    
    % snr computation using the equalized "equivalent" signal
    yplus_hoft_eq=Hp*y_gd(cont_gl0_eq{i});
    ycross_hoft_eq=Hc*y_gd(cont_gl45_eq{i});
    yplus_equiv_eq=y_gd(geq_equiv_plus{i});
    yplus_equiv_eq=yplus_equiv_eq(yplus_equiv_eq~=0);
    ycross_equiv_eq=y_gd(geq_equiv_cross{i});
    ycross_equiv_eq=ycross_equiv_eq(ycross_equiv_eq~=0);
    
    hoft_plus_equiv_eq=yplus_hoft_eq*norm(A0(i,:)).^2/A0norm2;
    hoft_cross_equiv_eq=ycross_hoft_eq*norm(A45(i,:)).^2/A45norm2;
    snr_equiv_eq=snr_equiv_eq+norm(hoft_plus_equiv_eq).^2*dt/var(yplus_equiv_eq)+norm(hoft_cross_equiv_eq).^2*dt/var(ycross_equiv_eq);
    
end

% estimate parameters
[h0_equiv eta_equiv psi_equiv phi0_equiv]=estipar_equiv(Hp_equiv,Hc_equiv);
fprintf('equivalent--- h0=%e  eta=%f  psi=%f  snr_standard=%f phi0=%f\n',h0_equiv,eta_equiv,psi_equiv,h0_equiv*sqrt(snr_equiv),phi0_equiv);
fprintf(res,'Equivalent signal\n');
fprintf(res,'h0=%e  eta=%f  psi=%f  snr_standard=%f phi0=%f\n \n',h0_equiv,eta_equiv,psi_equiv,h0_equiv*sqrt(snr_equiv),phi0_equiv);

[h0_eq_equiv eta_eq_equiv psi_eq_equiv phi0_eq_equiv]=estipar_equiv(Hp_eq_equiv,Hc_eq_equiv);
fprintf('equivalent equalized--- h0=%e  eta=%f  psi=%f  snr_standard=%f phi0=%f\n',h0_eq_equiv,eta_eq_equiv,psi_eq_equiv,h0_eq_equiv*sqrt(snr_equiv_eq),phi0_eq_equiv);
fprintf(res,'Equivalent signal equalized\n');
fprintf(res,'h0=%e  eta=%f  psi=%f  snr_standard=%f phi0=%f\n',h0_eq_equiv,eta_eq_equiv,psi_eq_equiv,h0_eq_equiv*sqrt(snr_equiv_eq),phi0_eq_equiv);

fclose(res);

function [A fr]=compute_5comp_num(gin,fr0,mask)
% This function makes the numerical computation of 5-vectors
%
% Input:
%   gin:    data
%   fr0:    reference frequency (starting from 0Hz)
%   ant:    antenna structure
%   mask:   mask 
%
% Output:
%   A:      5-vector
%   fr:     5 frequencies

cont=cont_gd(gin);
%t0=cont.t0;
%lst=(gmst(t0)+ant.long/15)*3600;
y=y_gd(gin);
t=x_gd(gin);

t=t-t(1);
dt=dx_gd(gin);
%n=n_gd(gin);

if exist('mask','var')
    y=y.*mask(:);
end

FS=1/86164.09053083288;

fr=fr0+(-2:2)*FS;

for i = 1:5
    A(i)=sum(y.*exp(-1j*2*pi*fr(i)*t))*dt;
end


function [h0 eta psi cohe phi0]=estipar(X,A0,A45)
% This function uses 5-vectors to make parameter estimation
%
% Input:
%   X:      data 5-vector
%   A0:     + signal 5-vector
%   A45:    x signal 5-vector
%
% Output:
%      Parameters and coherence estimations

% matched filters to estimate complex amplitudes (Eq. 19,20 of ref.2)
mf0=conj(A0)./norm(A0).^2;
mf45=conj(A45)./norm(A45).^2;
hp=sum(X.*mf0);
hc=sum(X.*mf45);

h0=sqrt(norm(hp)^2+norm(hc)^2); %Amplitude estimator eq.B1 of ref.2)

a=hp/h0;
b=hc/h0;

A=real(a*conj(b)); %(See Eq.B2 of ref.2: the division by h0 lacks there!)
B=imag(a*conj(b)); %(Eq.B2 of ref.2: the division by h0 lacks there!)
C=norm(a)^2-norm(b)^2; %(Eq.B3 of ref.2: the division by h0 lacks there!)

eta=(-1+sqrt(1-4*B^2))/(2*B); %(Eta estimator Eq.B4 of ref.2)
cos4psi=C/sqrt((2*A)^2+C^2); %(Eq.B5 of ref.2)
sin4psi=2*A/sqrt((2*A)^2+C^2); %(Eq.B6 of ref.2)
psi=(atan2(sin4psi,cos4psi)/4)*180/pi; %psi estimator
phi0=angle(hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180))/sqrt(1+eta^2))); %(See Eq.32 of ref.1)

sig=hp*A0+hc*A45; %Total signal estimated 5-vector (use estimated complex amplitudes)
[mf cohe]=mfcohe_5vec(X,sig); %Call function to compute coherence

function [h0 eta psi phi0]=estipar_equiv(hp,hc)
% This function uses signal complex amplitude estimators of the equivalent signal to estimate
% signal parameters
%
% Input:
%   hp,hc: complex amplitude estimators of the equivalent signal
%
% Output:
%   Signal parameter estimations

h0=sqrt(norm(hp)^2+norm(hc)^2);

a=hp/h0;
b=hc/h0;

A=real(a*conj(b));
B=imag(a*conj(b));
C=norm(a)^2-norm(b)^2;

eta=(-1+sqrt(1-4*B^2))/(2*B);
cos4psi=C/sqrt((2*A)^2+C^2);
sin4psi=2*A/sqrt((2*A)^2+C^2);
psi=(atan2(sin4psi,cos4psi)/4)*180/pi;
phi0=angle(hp/(h0*(cos(2*psi*pi/180)-1j*eta*sin(2*psi*pi/180))));


