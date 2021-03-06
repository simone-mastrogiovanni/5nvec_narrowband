function [gout,gar]=simone_applies_spin_down_corrections_gpu(gar,gartime,gin,count_sd,dtout)
% This function applies spin-down correction to coherent searches
% Input:
% gar: input data strain (GPU matlab object)
% gartime: input time straim (GPU matlab object)
% gin: input gd
% count_sd: number of spin-down bins from the central spin-down value of the source
% dtout: Down-sample time
%
% OUTPUT;
% gout: Correted gd

SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency

cont=cont_gd(gin); % Waves parameters and other stuff

N=length(gar);
binf=1/(N*dtout);%$ Frequency bin due to the length of signal series 
nsidbin=floor(FS/binf);%$ Number of corrisponding to sidereal freq
binfsid=FS/nsidbin;%$New bin Submultiple of Sidereal freq
Tobs=1/binfsid; %$ New observation time
NS=round(Tobs/dtout); %$ Number of components in the array to save
binfsid=1/(NS*dtout); % Final frequency bin
%$$$$ SPIN-DOWN CORRECTION IN PHASE $$$$$$$
if ~isfield(cont.corrections_par,'d3f0')
    cont.corrections_par.d3f0=0;
    cont.corrections_par.d4f0=0;
    cont.corrections_par.d5f0=0;
    cont.corrections_par.d6f0=0;
    cont.corrections_par.d7f0=0;
elseif ~isfield(cont.corrections_par,'d5f0')
    cont.corrections_par.d5f0=0;
    cont.corrections_par.d6f0=0;
    cont.corrections_par.d7f0=0;
end
in.sd_c2=cont.corrections_par.df0/(2);
in.sd_c3=cont.corrections_par.ddf0/(6);
in.sd_c4=cont.corrections_par.d3f0/(24);
in.sd_c5=cont.corrections_par.d4f0/(120);
in.sd_c6=cont.corrections_par.d5f0/(720);
in.sd_c7=cont.corrections_par.d6f0/(5040);
in.sd_c8=cont.corrections_par.d7f0/(40320);
df0new=(cont.corrections_par.df0+count_sd*binfsid^2);
in.sd_c2=df0new/(2);
if (in.sd_c4 == 0)
    dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3;
elseif in.sd_c6 == 0
    dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5;
else
    dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8;
end
ph1sab=mod((dtsd),1)*2*pi;
exposa=exp(-1j*ph1sab);
%$Corrects signal for spin-down 
gar=gar.*exposa;
gout=gin;
cont.corrections_par.df0=df0new;
cont.df0=df0new;
gout=edit_gd(gout,'y',gar,'cont',cont); % Update the gd


end
