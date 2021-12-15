function [gdout gdin]=total_clean_gd(gdin,sciseglist,idet,delint)
% 
% 1.sel_data_v3 --> selects science segments data using sciseglist
% (implemented directly in this code)
% 2.logarithmize --> evaluates the median abs level to be used in 3. (*10 typical threshold)
% 3.complex_clip --> applies cleaning usign the threshod compute in 2.
%
%  gdin          gd to be cleanded
%  sciseglist    science segment list (different format of files pay attention) (e.g '/storage/users/piccinni/O1_H1_segments_science_full.txt')
%  delint:     number of seconds to be removed at the beginning and end of
%               each segment (tipically 0 for virgo data, 150 for ligo data)
%  idet:       detector-dependent flag (0: virgo; 1:ligo)
%%O.J.Piccinni july 2016
tic
science=1;
cont=cont_gd(gdin);
ant=cont.ant;

if ~exist('sciseglist','var')
    science=0
end

if ~exist('idet','var')
    switch ant
        case 'virgo'
            idet=0;
        case 'ligol'
            idet=1;
        case 'ligoh'
            idet=1;
    end
   % ant
   % idet
end

if ~exist('delint','var')
    delint=0
end


if science==1

itsel=[];


v1=y_gd(gdin);
t1=x_gd(gdin);

t0=cont.t0
v2=mjd2gps(t0)+t1;

if ~exist('idet','var')
    idet=0;
end

fid = fopen(sciseglist, 'r');
if (idet==0) %Virgo-type segment file: tstart tstop
    R=textscan(fid,'%f %f');
    tstart=R{1};
    tstop=R{2};
elseif (idet==1) % ligo-type segment file: num tstart tstop duration 
    R=textscan(fid,'%f %f %f %f');
    tstart=R{2};
    tstop=R{3};
    seglength=R{4};
end

    fclose(fid);
    lensc=0;
    nseg=0;
    
for i=1:length(tstart)
    if tstop(i)-tstart(i)>2*delint
        s=find(v2>=tstart(i)+delint & v2<=tstop(i)-delint);
        lensc=lensc+length(s);
        itsel=cat(2,itsel,s');
        nseg=nseg+1;
    end
end

vsel=zeros(1,length(v1));
vsel(itsel)=v1(itsel);
fprintf('science fraction: %f\n',lensc/length(v1));

if isa(gdin,'gd')
    dx=dx_gd(gdin);
    gdin=edit_gd(gdin,'y',vsel, 'dx',dx);
end

fprintf('Number of segments: %d\n',nseg);
%figure,plot(in),hold on,plot(gdout,'r');

%[~ , ~, gdin v2 v20 R itsel]=sel_data_v3(gdin,sciseglist,0,1);  %!!!!!! idet=0 for VSR4 or Ligo idet=1for O1 (full) sel_data_v3(in,seglist,delint,idet,mask)

end
[~, mi]=logarithmize(gdin);

gdout=complex_clip(gdin,10*mi);
cont=cont_gd(gdout);
cont.tcreation=datestr(now);
cont.durcreation=toc;
cont.mi_abs_lev=mi;
gdout=edit_gd(gdout,'cont',cont);
clear  v2 R itsel

