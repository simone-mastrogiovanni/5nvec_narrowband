function check_harmsubharm(lines,fr)
% CHECK_HARMSUBHARM  checks if a frequency is from a list of lines as an
%                    harmonics or sub-harmonics
%
%     lines   array with lines
%     fr      checked frequency

% Version 2.0 - July 2007
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

nhar=20;
ii=0;
for i = 1:nhar
    for j = 1:nhar
        har=i/j;
        ind=find(abs(fr*har./lines-1)<0.001);
        if ~isempty(ind)
            for k = 1:length(ind)
                ii=ii+1;
                disp(sprintf('%3d / %3d  of %f  rank %d  err = %f',i,j,...
                    lines(ind(k)),ind(k),fr*har./lines(ind(k))-1))
            end
        end
    end
end

disp(sprintf('  %d solutions found',ii))