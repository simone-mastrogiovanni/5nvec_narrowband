%PROVA_R87

setsnag
eval(['cd ' rogdata]);

[fid,reclen,initime,samptim]=open_r87('G9111V006.R87')

[header,data]=read_r87_ch(fid,reclen,201);
plot(data);

type prova_r87.m