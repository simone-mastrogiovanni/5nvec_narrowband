function out=struct2file(struc,mtyp,fid,strname)
% stores in a file a structure
%
%    out=struct2file(struct,fid)
%
%   struct   structure
%   mtyp     storage type modifiers (for each structure element) if
%             = 0 -> natural (char or whatelse)
%             = 3 -> int32
%             = 4 -> float32
%             = 5 -> int64
%   fid      file fid (fid = 0 -> only computes the length)
%   strname  name of the structure (max len 64)
%
% limitation: the objects in the structure are not saved
%             the substructure are saved only natural type
%
% data types
%  1     character
%  3     int32
%  4     float
%  5     int64
%  8     double
%  104   complex float
%  108   complex double
%  200   structure
%  0     not recognized

% Version 2.0 - January 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

out=struct();
lenfil=0;
fiel=fieldnames(struc);
nfiel=length(fiel);

out.fiel=fiel;
out.nfiel=nfiel;

if length(mtyp) == 1 && mtyp == 0
    mtyp(1:nfiel)=0;
end

if fid > 0
    fprintf(fid,'## structure %102s %5d fields',strname,nfiel); % First
end
lenfil=lenfil+128;

for i = 1:nfiel
    eval(['aa=struc.' fiel{i} ';']),lenfil
    [nr,nc]=size(aa);
    if ischar(aa) 
        itip=1;
    elseif isnumeric(aa)
        itip=8;
        if mtyp(i) == 3
            itip=4;
        elseif mtyp(i) == 4
            itip=4;
        elseif mtyp(i) == 5
            itip=5;
        end
        if ~isreal(aa)
            itip=itip+100;
        end
    elseif isstruct(aa)
        itip=200; 
    else
        itip=0;
    end

    if fid > 0
        fprintf(fid,'## %4d %10d %10d field %92s',itip,nr,nc,fiel{i});
    end
    lenfil=lenfil+128;
    
    switch itip
        case 1
            if fid > 0
                fwrite(fid,aa,'char');
            end
            lenfil=lenfil+ceil(length(aa)*1/16)*16;
        case 3
            if fid > 0
                fwrite(fid,aa,'int32');
            end
            lenfil=lenfil+ceil(length(aa)*4/16)*16;
        case 4
            if fid > 0
                fwrite(fid,aa,'float');
            end
            lenfil=lenfil+ceil(length(aa)*4/16)*16;
        case 5
            if fid > 0
                fwrite(fid,aa,'int64');
            end
            lenfil=lenfil+ceil(length(aa)*8/16)*16;
        case 8
            if fid > 0
                fwrite(fid,aa,'double');
            end
            lenfil=lenfil+ceil(length(aa)*8/16)*16;
        case 104
            if fid > 0
                vec=complex2vec(aa);
                fwrite(fid,vec,'float');
            end
            lenfil=lenfil+ceil(length(aa)*8/16)*16;
        case 108
            if fid > 0
                vec=complex2vec(aa);
                fwrite(fid,vec,'double');
            end
            lenfil=lenfil+ceil(length(aa)*16/16)*16;
        case 200 
            estr=['out1=struct2file(aa,0,fid,''' fiel{i} ''');']
            eval(estr)
            lenfil=lenfil+ceil(out1.lenfil/16)*16;
    end
    if fid > 0
        pos=checkpos(fid,0);
    end
end

if fid > 0
    out.strlen=ftell(fid);
end

out.lenfil=lenfil;


function pos=checkpos(fid,typ)
% fills file gaps 
% typ=1 blanks, typ=0 zeros

pos0=ftell(fid);
pos=ceil(pos0/16)*16;
if typ == 1
    d(1:pos-pos0)=' ';
else
    d(1:pos-pos0)=0;
end
fwrite(fid,d,'char')