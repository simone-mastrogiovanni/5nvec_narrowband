function struc=file2struct(fid)
% reads a structure from a file written by struct2file

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

headn=fread(fid,128,'char');
head=char(headn')
strname=strtrim(head(14:115));
% str=strname;
str=struct();
nfiel=str2num(head(117:121));

struc.name=strname;
struc.nfiel=nfiel;

for i = 1:nfiel
%     ftell(fid)
    fien=fread(fid,128,'char');
    fie=char(fien')
    fiename=strtrim(fie(37:128));
    I=sscanf(fie(4:30),'%d');
    itip=I(1);nr=I(2);nc=I(3);
    nn=nr*nc;
    switch itip
        case 1
            aa=fread(fid,nn,'char');
            aa=char(aa');
        case 3
            aa=fread(fid,nn,'int32');
        case 4
            aa=fread(fid,nn,'float');
        case 5
            aa=fread(fid,nn,'int64');
        case 8
            aa=fread(fid,nn,'double');
        case 104
            vec=fread(fid,nn*2,'float');
            aa=vec2complex(vec);
        case 108
            vec=fread(fid,nn*2,'double');
            aa=vec2complex(vec);
        case 200
            aa=file2struct(fid);
    end
    eval(['str.' fiename '=aa;'])
    pos=checkpos(fid)
end

eval(['struc.' strname '=str;']);


function pos=checkpos(fid)

pos0=ftell(fid);
pos=ceil(pos0/16)*16;
fseek(fid,pos,'bof');