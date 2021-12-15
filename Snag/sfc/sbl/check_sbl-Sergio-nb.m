function sbl_=check_sbl(level,file)
%
%   level  0 = default, 1 reads all blocks, 2 -> all blocks verbose

if ~exist('level','var')
    level=0;
end

if ~exist('file','var')
    file=selfile(' ');
end

sbl_=sbl_open(file)
disp(sprintf('          ch          inix         iniy            dx            dy          lenx   leny type      bias'))    
for i = 1:sbl_.nch
    disp(sprintf(' channel %3d  --> %12f  %12f  %12f  %12f   %8d %4d %3d  %10d   %s',i,sbl_.ch(i).inix,sbl_.ch(i).iniy, ...
    sbl_.ch(i).dx,sbl_.ch(i).dy,sbl_.ch(i).lenx,sbl_.ch(i).leny,sbl_.ch(i).type,sbl_.ch(i).bias,sbl_.ch(i).name))
end

format long

lenteor=sbl_.point0+sbl_.len*sbl_.blen

info=dir(file)

err=lenteor-info.bytes

if level > 0
    tt=zeros(1,sbl_.len);
    k=0;
    
    while 1
        [M,t,blhead]=sbl_read_block(sbl_,1,1,1);
        if isempty(t) | t == 0
            disp('Error !')
            k,t
            break
        else
            tend=t;
        end
        k=k+1;
        tt(k)=t;
    end
    
    for i = 2:k
        if abs(tt(i)-tt(i-1))*86400-sbl_.dt > 1.e-6*sbl_.dt
            disp(sprintf('block %d, t = %f  hole of %f s',i,tt(i),(tt(i)-tt(i-1))*86400-sbl_.dt))
        end
    end
    sbl_.maxt=tend+sbl_.dt/86400;
    figure,plot(tt,'r.'),grid on
end
    

fclose(sbl_.fid);
