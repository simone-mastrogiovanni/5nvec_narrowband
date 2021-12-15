function vbl_=check_vbl(ic)
%CHECK_VBL  checks a vbl file
%
%  ic   >=0 level of checking
%       =0  file level
%       =1  block level
%       =2  channel level

file=selfile(' ');

if ~exist('ic')
    ic=3;
end

vbl_=vbl_open(file)
disp(sprintf('          ch            dx            dy          lenx  leny type   name'))    
for i = 1:vbl_.nch
    disp(sprintf(' channel %3d  --> %12f  %12f   %8d %4d %3d  %s',i,vbl_.ch(i).dx,vbl_.ch(i).dy, ...
    vbl_.ch(i).lenx,vbl_.ch(i).leny,vbl_.ch(i).type,vbl_.ch(i).name))
end

format long
vbl_.nextblock=0;
len=vbl_.len;
if len == 0
    len=999999999999;
end
kbl=0;

while vbl_.eof == 0
    kbl=kbl+1;
    if kbl > len
        break
    end
    vbl_=vbl_nextbl(vbl_);
    if vbl_.eof > 0
        break
    end
    if ic > 0 
        disp(sprintf('BLOCK %d  time = %f \n',vbl_.block,vbl_.bltime));
    end

    kch=vbl_.block;
    tim=vbl_.bltime;
    vbl_.ch0.next=-1;

    while vbl_.ch0.next ~= 0
        vbl_=vbl_nextch(vbl_);
        if ic > 1
            disp(sprintf('  CHANNEL %d   lenx = %d ;   inix = %d ;  next at %d \n',vbl_.ch0.chnum,vbl_.ch0.lenx,vbl_.ch0.inix,vbl_.ch0.next));
        end
    end
end

% lenteor=vbl_.point0+vbl_.len*vbl_.blen

info=dir(file)

fclose(vbl_.fid);
