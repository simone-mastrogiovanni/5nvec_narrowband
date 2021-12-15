function source_tab(sources,tabfile)

N=length(sources);

for i = 1:N
    sim_a(i)=sources(i).a;
    sim_d(i)=sources(i).d;
    sim_eps(i)=sources(i).eps;
    sim_psi(i)=sources(i).psi;
    sim_f0(i)=sources(i).f0;
    sim_df0(i)=sources(i).df0;
    sim_ddf0(i)=sources(i).ddf0;
    sim_h(i)=sources(i).h;
    sim_snr(i)=sources(i).snr;
end

if ~exist('tabfile')
    tabfile='tabfile.dat';
end

disp([' --- Source data on ' tabfile])
fid=fopen(tabfile,'w');

fprintf(fid,'      Periodic Sources \r\n\r\n');
fprintf(fid,'   alpha       delta       epsilon      psi        fr_0         df_0         ddf_0            h         snr      \r\n\r\n');

for i = 1:N
    fprintf(fid,' %8.3f  %8.3f  %7.5f  %7.2f  %11.6f  %11.6f  %11.6f  %8.4e %8.4e \r\n',...
        sim_a(i),sim_d(i),sim_eps(i),sim_psi(i),sim_f0(i),sim_df0(i),sim_ddf0(i),...
        sim_h(i),sim_snr(i);
end

fclose(fid);
