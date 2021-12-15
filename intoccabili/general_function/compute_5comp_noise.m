function [A ind]=compute_5comp_noise(gin,fr0,L,ind,mask)
% COMPUTE_5COMP_NOISE  computes 5-vectors at "off-source" frequencies 
%
% Input:
%     gin        input data gd
%     fr0        source frequency
%     L          number of "off-source" frequency bins
%     ind        array of integer indexes to select "off-source" frequency bins
%     mask       if present, weights gin
% Output:
%     A         "off-source" 5-vectors
%     ind       array of indexes identifying selected "off-source" frequency bins 

% by C. Palomba (INFN Roma) and Rome Virgo CW group

FS=1/86164.09053083288; % sidereal frequency
spreadfact=10; 

% extract data from the input gd
y=y_gd(gin); % time domain data
t=x_gd(gin); % corresponding times
t=t-t(1);
dt=dx_gd(gin); % sampling time
n=n_gd(gin); % number of time samples

% apply mask if given in input
if exist('mask','var')
    y=y.*mask(:);
end

if ~exist('L','var')
    L=1000; % default value for the number of "off-source" frequencies
end
Ttot=t(length(t)); % total observation time
df=1/Ttot; % frequency bin
iside=round(FS/df+0.5); % number of bins corresponding to the sidereal frequency  
if ~exist('ind','var') 
    ind=-.5*spreadfact*L+ceil(spreadfact*L*rand(1,L)); % random integer values to be used to select "off-source" frequency bins
    ind=unique(ind); % remove duplicate integers 
    % keep only bins outside \pm 10 bins around search frequency and its sidebands
    ii = (ind > 0*iside+10 | ind < 0*iside-10) & (ind > iside+10 | ind < iside-10) & (ind > 2*iside+10 | ind ...
< 2*iside-10) & (ind > -iside+10 | ind < -iside-10) & (ind > -2*iside+10 | ind < -2*iside-10) & ...
(ind > 3*iside+10 | ind < 3*iside-10) & (ind > 4*iside+10 | ind < 4*iside-10) & ...
(ind > -3*iside+10 | ind < -3*iside-10) & (ind > -4*iside+10 | ind < -4*iside-10);
    ind=ind(ii); % take indexes corresponding to selected bins 
end
len=length(ind);
A=zeros(5,len);

for j=1:len % loop on the randomly selected indexes
    if floor(j/1000)-j/1000 == 0
        j=j
    end
    fr0=fr0+ind(j)*df; % compute the corresponding random frequency
    fr=fr0+(-2:2)*FS; % set of 5 frequencies   
    for i = 1:5 % compute 5-vector
        A(i,j)=sum(y.*exp(-1j*2*pi*fr(i)*t))*dt;
    end
end
