function [gout,isel]=extract_data_nb(gin,start_mjd,end_mjd,dtin)
% Extract a portion of the timeseries between a start MJD and end MJD 
%
% input:
% gin:  input gd
% start_mjd:  new start in mjd
% end_mjd: new end in mjd  
% dtin: Sampling time
%
% output:
% gout: new gd with the extracted data

cont=cont_gd(gin);
t0old=cont.t0;
start_mjd=start_mjd+t0old-floor(t0old); % adjust the cut in such a way that fall in an integer down-sampled time
end_mjd=end_mjd+t0old-floor(t0old);
        disp(sprintf('We will analyze data from the %f to %f day since the beginning of sbl file \n',start_mjd,end_mjd)); 
Dt1=(start_mjd-t0old); % Time interval between the old and the new start time
Dt2=(end_mjd-t0old); %  Time interval between the old and the new end time
Dt1=Dt1*86400;
Dt2=Dt2*86400;
t0new=start_mjd;
x=x_gd(gin);
y=y_gd(gin);
x=x(round(Dt1/dtin)+1:round(Dt2/dtin)+1); % take the interested times
y=y(round(Dt1/dtin)+1:round(Dt2/dtin)+1); % take the interested times
isel=round(Dt1/dtin)+1:round(Dt2/dtin)+1;
n=length(x);
%Build the output gd
gout=gin;
cont_red=cont;
cont_red.t0=t0new; % Update the initial time of data set
T0=(t0new-floor(t0new))*86400;
gout=edit_gd(gout,'x',x,'y',y,'cont',cont_red);
