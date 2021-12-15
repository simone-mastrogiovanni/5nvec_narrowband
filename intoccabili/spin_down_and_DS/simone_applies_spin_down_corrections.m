function gout=simone_applies_spin_down_corrections(gin,count_sd,dtout)
% This function applies spin-down correction to coherent searches
% Input:
% gin: input gd
% count_sd: number of spin-down bins from the central spin-down value of the source
% dtout: Down-sample time
%
% OUTPUT;
% gout: Correted gd

SD=86164.09053083288; %$ Sidereal day in seconds
FS=1/86164.09053083288; %$ Sidereal frequency

gar=y_gd(gin);  % data time-series
gartime=x_gd(gin); % data time vector
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
end
if ~isfield(cont.corrections_par,'d4f0')
    cont.corrections_par.d4f0=0;
end
if ~isfield(cont.corrections_par,'d5f0')
    cont.corrections_par.d5f0=0;
end
if ~isfield(cont.corrections_par,'d6f0')
    cont.corrections_par.d6f0=0;
end
if ~isfield(cont.corrections_par,'d7f0')
    cont.corrections_par.d7f0=0;
end
if ~isfield(cont.corrections_par,'d8f0')
    cont.corrections_par.d8f0=0;
end
if ~isfield(cont.corrections_par,'d9f0')
    cont.corrections_par.d9f0=0;
end
if ~isfield(cont.corrections_par,'d10f0')
    cont.corrections_par.d10f0=0;
end
if ~isfield(cont.corrections_par,'d11f0')
    cont.corrections_par.d11f0=0;
end
if ~isfield(cont.corrections_par,'d12f0')
    cont.corrections_par.d12f0=0;
end
in.sd_c2=cont.corrections_par.df0/factorial(2);
in.sd_c3=cont.corrections_par.ddf0/factorial(3);
in.sd_c4=cont.corrections_par.d3f0/factorial(4);
in.sd_c5=cont.corrections_par.d4f0/factorial(5);
in.sd_c6=cont.corrections_par.d5f0/factorial(6);
in.sd_c7=cont.corrections_par.d6f0/factorial(7);
in.sd_c8=cont.corrections_par.d7f0/factorial(8);
in.sd_c9=cont.corrections_par.d8f0/factorial(9);
in.sd_c10=cont.corrections_par.d9f0/factorial(10);
in.sd_c11=cont.corrections_par.d10f0/factorial(11);
in.sd_c12=cont.corrections_par.d11f0/factorial(12);




df0new=(cont.corrections_par.df0+count_sd*binfsid^2);
in.sd_c2=df0new/(2);
choice_vector=[in.sd_c2,in.sd_c3,in.sd_c4,in.sd_c5,in.sd_c6,in.sd_c7,in.sd_c8,in.sd_c9,in.sd_c10,in.sd_c11,in.sd_c12];
iselection=find((log10(abs(choice_vector))~=-Inf));
if iselection(end)==1
dtsd=in.sd_c2*gartime.^2;    
end
if iselection(end)==2
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3;    
end
if iselection(end)==3
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4;    
end
if iselection(end)==4
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5;    
end
if iselection(end)==5
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6;    
end
if iselection(end)==6
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7;    
end
if iselection(end)==7
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8;    
end
if iselection(end)==8
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8+in.sd_c9*gartime.^9;    
end
if iselection(end)==9
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8+in.sd_c9*gartime.^9+in.sd_c10*gartime.^10;    
end
if iselection(end)==10
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8+in.sd_c9*gartime.^9+in.sd_c10*gartime.^10+in.sd_c11*gartime.^11;    
end
if iselection(end)==11
dtsd=in.sd_c2*gartime.^2+in.sd_c3*gartime.^3+in.sd_c4*gartime.^4+in.sd_c5*gartime.^5+in.sd_c6*gartime.^6+in.sd_c7*gartime.^7+in.sd_c8*gartime.^8+in.sd_c9*gartime.^9+in.sd_c10*gartime.^10+in.sd_c11*gartime.^11+in.sd_c12*gartime.^12;    
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
