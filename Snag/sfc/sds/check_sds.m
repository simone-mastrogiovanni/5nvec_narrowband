function sds_=check_sds

file=selfile(' ');

sds_=sds_open(file)
for i = 1:sds_.nch
    disp(sprintf(' channel %3d  --> %s',i,sds_.ch{i}))
end

lenteor=sds_.point0+sds_.len*sds_.nch*4;

info=dir(file)

err=(lenteor-info.bytes)/4;
if err == 0
    disp('Length OK')
else
    if err > 0
        disp(sprintf('%d data less than expected',err))
    else
        disp(sprintf('%d data more than expected',-err))
    end
end

fclose(sds_.fid);
