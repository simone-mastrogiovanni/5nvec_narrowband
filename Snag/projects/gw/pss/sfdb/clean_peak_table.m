function [ptcl,basic_info,checkC]=clean_peak_table(ptin,basic_info)
% further cleaning of the peak map
%  two steps: h-w cancelling, time-frequency filter (not implemented here)
%
%   [peaks,basic_info,checkC]=clean_peak_table(ptin,basic_info,veto)
%
%    ptin         input peak table
%    basic_info

% Version 2.0 - October 2013 
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "La Sapienza" - Rome

tic
checkC=struct();

basic_info.proc.C_clean_peak_table.vers='140630';
basic_info.proc.C_clean_peak_table.tim=datestr(now);

ptcl=ptin;
epoch=basic_info.epoch;
tim=(basic_info.tim-epoch)*86400;
vel=basic_info.velpos(1:3,:);
index=basic_info.index;
Nt=basic_info.ntim;
dfr=basic_info.dfr;
v1=zeros(1,Nt);



if isfield(basic_info.mode,'veto_sour')
    veto_sour=basic_info.mode.veto_sour;
end

nveto_sour=0;
if exist('veto_sour','var')
    for j = 1:length(veto_sour)
        sour=veto_sour{j};
        sour=new_posfr(sour,epoch);
        fr0=sour.f0;
        sd=sour.df0;
        fr1=fr0+tim*sd;
        alpha=sour.a;
        delta=sour.d;
        r=astro2rect([alpha,delta],0);
        
        for i = 1:Nt
            v1(i)=dot(vel(:,i),r);
        end
        
        fr1=fr1.*(1+v1);
        
        for i = 1:Nt
            fr=ptin(2,index(i):index(i+1)-1);
            ii=find(abs(fr-fr1(i)) < dfr*1.5);
            nii=length(ii);
            if nii > 0
                ptcl(4,index(i)-1+ii)=0;
                nveto_sour=nveto_sour+nii;
            end
        end
    end
end

ii=find(ptcl(4,:) > 0);
nii=length(ii);
basic_info.NPeak(5)=nii;

basic_info.npeaks_vetosour=nveto_sour;
basic_info.proc.C_clean_peak_table.duration=toc;