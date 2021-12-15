% driver_sid_sweep0

tic
sids108L=sid_sweep('I:','ligol','O2',108,pulsar_3,1,10)
save('sids108L','sids108L')
toc

tic
sids108H=sid_sweep('I:','ligoh','O2',108,pulsar_3,1,10)
save('sids108H','sids108H')
toc

% sidsGCL=sid_sweep('I:','ligol','O2',108,GC,1,10)
% save('sidsGCL','sidsGCL')
% toc
% 
% sidsGCH=sid_sweep('I:','ligoh','O2',108,GC,1,10)
% save('sidsGCH','sidsGCH')
% toc