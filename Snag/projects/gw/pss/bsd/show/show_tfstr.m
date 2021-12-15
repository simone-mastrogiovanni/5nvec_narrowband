function out=show_tfstr(in)
% shows features of a tfstr
%
%    in    bsd gd or tfstr

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

out=struct();

if ~isstruct(in)
    in=tfstr_gd(in);
end

np=in.pt.ntotpeaks;

figure,plot(in.pt.peaks(1,:),in.pt.peaks(2,:),'.'),grid on,xlabel('time (days)'),ylabel('frequency')
figure,plot(in.pt.peaks(1,:),in.pt.peaks(3,:),'.'),grid on,xlabel('time (days)'),ylabel('amplitude')
figure,plot(in.pt.peaks(1,:),in.pt.peaks(6,:),'.'),grid on,xlabel('time (days)'),ylabel('cr')
figure,plot(in.pt.peaks(1,:),in.pt.peaks(9,:),'.'),grid on,xlabel('time (days)'),ylabel('angle')

figure,hist(in.pt.peaks(1,:),100),title('time histogram'),grid on
figure,hist(mod(in.pt.peaks(1,:),1)*24,24),title('time histogram (hours)'),grid on
figure,hist(sidereal_hour(in.pt.peaks(1,:)),24),title('time histogram (sid. hours)'),grid on
figure,hist(in.pt.peaks(2,:),100),title('frequency histogram'),grid on
figure,hist(log10(in.pt.peaks(3,:)),100),title('log10(amp) histogram'),grid on
figure,hist(log10(in.pt.peaks(6,:)),100),title('log10(cr) histogram'),grid on
figure,hist(in.pt.peaks(9,:),100),title('angle histogram'),grid on

image_gd2(in.subsp.hdens,0,0),grid on
