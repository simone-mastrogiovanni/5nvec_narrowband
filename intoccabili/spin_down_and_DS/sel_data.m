function [vsel tsel mask gdout]=sel_data(in,seglist,delint,idet,lpmin,lpmax,mask)
% SEL_DATA: function to select data segments (read from a file)
%
% Example of usage:
%[vsel tsel mask_crab_vsr4_sci crab_vsr4_sci]=sel_data(gcrab_vsr4,'/storage/users/palomba/ana_hi/segments_Science_VSR4.txt',0,0,0,0);
%
% Input arguments:
%   in:         inout data gd or file
%   seglist:    file containing segment list
%   delint:     number of seconds to be removed at the beginning and end of
%               each segment (tipically 0 for virgo data, 150 for ligo data)
%   idet:       detector-dependent flag (0: virgo; 1:ligo)
%   lpmin,lpmax:laser power interval (for ligo only, normally unused)
%   mask:       data mask, if previously computed
%

itsel=[];
delint=0
if ~exist('delint','var')
    delint=0;
end

if isa(in,'gd')
    v1=y_gd(in);
    t1=x_gd(in);
    tini_simone=t1(1);
    t1=t1-tini_simone;
    cont=cont_gd(in);
    t0=cont.t0;
    v2=mjd2gps(t0)+t1;
else
    fid1 = fopen(in, 'r');
    A=textscan(fid1,'%f %f');
    v1=A{2};
    v2=A{1};
    fclose(fid1);
end
if ~exist('idet','var')
    idet=0;
end

if ~exist('mask','var')
    fid = fopen(seglist, 'r');
    if (idet==0) %Virgo-type segment file
        R=textscan(fid,'%f %f');
        tstart=R{1};
        tstop=R{2};
    elseif (idet==1 && lpmax == 0) % ligo-type segment file
        R=textscan(fid,'%f %f %f %f');
        tstart=R{2};
        tstop=R{3};
        seglength=R{4};
        %   elseif (lpmax>0)
        %       load ligol_S6_power.mat;
        %       tstart=round(mjd2gps(lp(1,:)));
        %       tstop=round(mjd2gps(lp(2,:)));
        %       laspow=lp(3,:);
        %       figure;plot(laspow)
    end
    
    fclose(fid);
    lensc=0;
    nseg=0;
    
    reverseStr = '';
    
    
    for i=1:length(tstart)
        if tstop(i)-tstart(i)>2*delint
            s=find(v2>=tstart(i)+delint & v2<=tstop(i)-delint);
            lensc=lensc+length(s);
            itsel=cat(2,itsel,s');
            nseg=nseg+1;
        end
        percentDone = 100 *i/ length(tstart);
        msg = sprintf('Percent of cleaning: %3.1f', percentDone); %Don't forget this semicolon
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end
    
    tsel=v2(itsel);
    vsel=zeros(1,length(v1));
    tsel=zeros(1,length(t1));
    vsel(itsel)=v1(itsel);
    tsel(itsel)=t1(itsel);
    fprintf('science fraction: %f\n',lensc/length(v1));
    mask=zeros(1,length(v2));
    mask(itsel)=1;
else
    tsel=v2;
    vsel=v1.*mask';
end

if isa(in,'gd')
    gdout=in;
    gdout=edit_gd(gdout,'y',vsel,'x',tsel+tini_simone);
end

fprintf('Number of segments: %d\n',nseg);
figure,plot(in,'bo'),hold on,plot(gdout,'rx');
