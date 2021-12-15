% driver_sid_sweep_GC   (12-4-2019)

bw=10; %   bw      narrow bandwidth in units of 1/SD (typically 10)
freq=10;

for i = 1:70
    nameL=sprintf('sidsGC_%04d_%04d_%d_L',freq,freq+10,bw)
    tic
    sidsGCL=sid_sweep('I:','ligol','O2',freq+5,GC,1,10)
    save(nameL,'sidsGCL')
    toc
    
    nameH=sprintf('sidsGC_%04d_%04d_%d_H',freq,freq+10,bw)
    tic
    sidsGCH=sid_sweep('I:','ligoh','O2',freq+5,GC,1,10)
    save(nameH,'sidsGCH')
    toc
    
    freq=freq+10;
end
