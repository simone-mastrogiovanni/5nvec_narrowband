function dds_=check_dds

file=selfile(' ');

dds_=dds_open(file)
for i = 1:dds_.nch
    disp(sprintf(' channel %3d  --> %s',i,dds_.ch{i}))
end

lenteor=dds_.point0+dds_.len*dds_.nch*8;

info=dir(file)

err=(lenteor-info.bytes)/8;
if err == 0
    disp('Length OK')
else
    if err > 0
        disp(sprintf('%d data less than expected',err))
    else
        disp(sprintf('%d data more than expected',-err))
    end
end

fclose(dds_.fid);
