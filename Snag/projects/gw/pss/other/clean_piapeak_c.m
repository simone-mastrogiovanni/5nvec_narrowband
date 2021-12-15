function clean_piapeak_c
%CLEAN_PIAPEAK_C  cleans the peak files for certain bands
%
%     mask   a array indicating the forbidden bins

load mask;

piafile=selfile_c('  ','p05 file to be cleaned');

[pathstr,name,ext,versn] = fileparts(piafile);
name=[name '_clean' ext];
piaout=fullfile(pathstr,name);

fid1=fopen(piafile);
fid2=fopen(piaout,'w');

nfft=fread(fid1,1,'int32'); nfft
fwrite(fid2,nfft,'int32');
n=0;
ntot=0;
AA=zeros(nfft,2);

for i = 1:nfft
    mjd=fread(fid1,1,'double');
    nmax=fread(fid1,1,'int32');
    ntot=ntot+nmax;
    v=fread(fid1,3,'double');  
    fwrite(fid2,mjd,'double');
    AA(i,1)=ftell(fid2);
    fwrite(fid2,nmax,'int32');
    fwrite(fid2,v,'double');
    nmax1=0;
    for j = 1:nmax
        b=fread(fid1,1,'int32');
        a=fread(fid1,1,'float');
        x=fread(fid1,1,'float');

%         jj=mod(b,n10);
%         if jj > 5 & jj < n10-5
%             fwrite(fid2,b,'int32');
%             fwrite(fid2,a,'float');
%             fwrite(fid2,x,'float');
%             nmax1=nmax1+1;
%         end
        if mask(b)
            continue
        end
        
        fwrite(fid2,b,'int32');
        fwrite(fid2,a,'float');
        fwrite(fid2,x,'float');
        nmax1=nmax1+1;
    end
    AA(i,2)=nmax1;
    n=n+nmax1;
    disp(sprintf(' > %d/%d   %d/%d  %d/%d',i,nfft,(nmax-nmax1),nmax,ntot-n,ntot));
end

for i = 1:nfft
    fseek(fid2,AA(i,1),'bof');
    fwrite(fid2,AA(i,2),'int32');
end
    
fclose(fid2);


function [f,pnam,fnam]=selfile_c(direc,question)
%SELFILE  selects a file in a directory
%
%        f=selfile(direc)
%
%   f        file with path
%   pnam     path
%   direc    the directory

% Version 1.0 - November 1998
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

if ~exist('question','var')
    question='File Selection';
end
    
cddir=['cd ' direc];
eval(cddir);

[fnam,pnam]=uigetfile('*.*',question);

f=strcat(pnam,fnam);