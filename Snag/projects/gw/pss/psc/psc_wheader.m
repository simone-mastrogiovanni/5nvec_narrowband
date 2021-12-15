function psc_wheader(fid,pss_cand_head)
%PSC_WHEADER  writes a psc file header

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

fwrite(fid,pss_cand_head.prot,'int32');
fprintf(fid,'%128s',pss_cand_head.capt);
fwrite(fid,pss_cand_head.initim,'float64');
fwrite(fid,pss_cand_head.st,'float64');
fwrite(fid,pss_cand_head.fftlen,'int64');
fwrite(fid,pss_cand_head.inifr,'int64');
fwrite(fid,pss_cand_head.dlam,'float32');
fwrite(fid,pss_cand_head.dbet,'float32');
fwrite(fid,pss_cand_head.dsd1,'float32');
fwrite(fid,pss_cand_head.dcr,'float32');
fwrite(fid,pss_cand_head.dmh,'float32');
fwrite(fid,pss_cand_head.dh,'float32');

if pss_cand_head.prot > 2
    fwrite(fid,pss_cand_head.nsd1,'int32');
    dummy=zeros(1,16);
    fwrite(fid,dummy,'int32');
end