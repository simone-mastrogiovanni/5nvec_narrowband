function cand=psc_type(n1,n2,notype,file)
%PSC_TYPE  takes and types candidates from file
%
%    cand=psc_type(n1,n2,notype,file)
%
%  n1,n2   min,max sequence number
%  notype  >0 no type
%  file    candidate file

% Version 2.0 - November 2005
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('notype')
    notype=0;
end
if ~exist('file','var')
    file=selfile('');
end

fid=fopen(file,'r');

head=psc_rheader(fid)
dfr=1/(head.st*head.fftlen);

if n1 > 1
    [precand,nread]=fread(fid,n1*8,'uint16');
    if nread < n1*8
        disp([' *** Not enough data : total ' num2str(nread/8)])
    end
end

nn=n2-n1+1;
[cand,nread]=fread(fid,nn*8,'uint16');
nread1=floor(nread/8)*8;
if nread1 ~= nread
    disp(sprintf(' *** %d extra words !',nread-nread1))
    nread=nread1;
    cand=cand(1:nread1);
end
nn=nread/8;

cand=psc_vec2mat(cand,head,nn);

if notype <= 0
    for i = 1:nn
        fprintf(1,' %d %f <%f,%f> %e %f %f %e \n',i,cand(1,i),cand(2,i),cand(3,i),cand(4,i),cand(5,i),cand(6,i),cand(7,i));
    end
end

cand.cand=cand;
cand.epoch=head.initim;