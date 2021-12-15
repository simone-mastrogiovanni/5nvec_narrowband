function out=gd_subspec(in,N,res)
% computes subspectra
%
%   in    input gd (type 1)
%   N     number of subspectra
%   

% Snag version 2.0 - February 2018
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

n=n_gd(in);
y=y_gd(in);
n1=floor(n/N);
i1=1;
out=cell(N,1);

ps=gd_pows(in,'resolution',res);
figure,semilogy(ps),grid on

figure

for i = 1:N
    y1=y(i1:i1+n1-1);
    in1=edit_gd(in,'y',y1);
    ps=gd_pows(in1,'resolution',res);
    out{i}.in1=in1;
    out{i}.ps=ps;
    semilogy(ps),hold on
    i1=i1+n1;
end

grid on
    