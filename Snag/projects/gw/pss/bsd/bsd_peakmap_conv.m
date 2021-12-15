function peaks=bsd_peakmap_conv(tfstrcell)
% converts cell structured peaks to array
%

% Version 2.0 - September 2016
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by O.J.Piccinni and S. Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

nt=length(tfstrcell.pt.tpeaks);
peaks=zeros(9,tfstrcell.pt.ntotpeaks);
wn=tfstrcell.subsp.wn;
ii=0;

for i = 1:nt
    pea=tfstrcell.pt.peaks{i};
    nn=length(pea.fr);
    wn0=wn(i,:);
    if nn > 0
        iif=round((pea.fr-tfstrcell.inifr)/(tfstrcell.dfr*tfstrcell.subsp.ssred1)-eps)+1;
        jjf=find(iif > tfstrcell.subsp.len_ss);
        if ~isempty(jjf)
            [miif,imiif]=max(iif);
            fprintf(' i = %d len %d max iif = %d  at %d  min %d \n',i,length(jjf),miif,imiif,min(iif));
            iif(jjf)=tfstrcell.subsp.len_ss;
        end
        peaks(1,ii+1:ii+nn)=tfstrcell.pt.tpeaks(i);
        peaks(2,ii+1:ii+nn)=pea.fr;
        peaks(3,ii+1:ii+nn)=pea.amp;
        peaks(4,ii+1:ii+nn)=wn0(iif);
        peaks(6,ii+1:ii+nn)=pea.cr;
        peaks(7,ii+1:ii+nn)=real(pea.cc);
        peaks(8,ii+1:ii+nn)=imag(pea.cc);
        ang=angle(real(pea.cc)+1j*imag(pea.cc))*180/pi;
        peaks(9,ii+1:ii+nn)=ang;
        ii=ii+nn;
    end
end
