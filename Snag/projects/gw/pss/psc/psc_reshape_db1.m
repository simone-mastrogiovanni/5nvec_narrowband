function psscand_reshape(dirin)
% PSSCAND_RESHAPE  pss candidate files post-processing
%
%  dirin   input directory (root)

% Version 2.0 - October 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

snag_local_symbols;

if ~exist('dirin')
    dirin=selfolder;
    dirin=[dirin dirsep];
end

nfreq=2000;
N=2000000;

for i = 1:nfreq
    vdir1=floor((i-1)/100);
    vdir2=floor((i-vdir1*100-1)/10);
    vdir3=floor(i-vdir1*100-vdir2*10-1);
    dir1=sprintf('%04d',vdir1*100);
    dir2=sprintf('%02d',vdir2*10);
%     disp([dir1 dirsep dir2 dirsep dir3])
    file=sprintf('pss_cand_%04d.cand',i-1);
    filtot=[dirin dir1 dirsep dir2 dirsep file];
    fid=fopen(filtot,'r+');
    if fid < 0
        disp(['no ' filtot]);
        continue;
    end
    candstr=pss_candheader(fid);
    point=ftell(fid);
    
    [cand,nread,eofstat]=pss_readcand(fid,N);
    fr=psc_readfr(cand);
    [fr,ix]=sort(fr);
    cand=reshape(cand,8,length(cand)/8);
    cand1=cand(:,ix);
    cand=cand1(:);
    
    fseek(fid,point,'bof');
    fwrite(fid,cand,'uint16');
    
    fclose(fid);
end
