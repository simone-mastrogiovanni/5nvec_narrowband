function VP=extr_velpos(pialist)
% extracts velocity and position from pia files
%
%   VP(:,8)   central mjd, vel(3) pos(3) gps_s

% Version 2.0 - June 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

fidlist=fopen(pialist); %the list of files must contain the entire filepath
tline=fgetl(fidlist); 
nfil=0;

while tline ~= -1
    nfil=nfil+1;
    filepia{nfil}=tline;
    tline=fgetl(fidlist);
end

kchunk=0;

for i = 1:nfil                                  %for each SFDB09 file
    file=filepia{i};
    disp(file)

    fidpia=fopen(file);

    if fidpia <= 0
        disp([file ' not opened'])
        piahead=0;
%         data=0;
        return
    else
        fprintf('File %s opened, fid %d \n',file,fidpia)
    end
       
    while  ~feof(fidpia)        
        piahead=pia_read_block_09(fidpia);
     
        if feof(fidpia)~=0  
            break
        end
        kchunk=kchunk+1;
        
        if kchunk == 1
            lfftin=piahead.nsamples*2             
            t0=piahead.mjdtime;               % tempo del primo campione del file
            gpst0=piahead.gps_sec;
            gpst1=-10^6;
            halftfft=piahead.tbase/2;
        end
        
        t1=piahead.mjdtime; %should change for each fft
        centert=t1+halftfft/86400;
        gpst1=piahead.gps_sec;

        VP(kchunk,1)=centert;
        VP(kchunk,2)=piahead.vx_eq;
        VP(kchunk,3)=piahead.vy_eq;
        VP(kchunk,4)=piahead.vz_eq;

        VP(kchunk,5)=piahead.px_eq;
        VP(kchunk,6)=piahead.py_eq;
        VP(kchunk,7)=piahead.pz_eq;
        VP(kchunk,8)=piahead.gps_sec+halftfft;
    end

    fclose(fidpia);
end