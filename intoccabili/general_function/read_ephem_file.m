function [tephem f0ephem df0ephem ephyes]=read_ephem_file(source)

if ~isfield(source,'ephfile')
    ephyes=0;
    tephem=-1;
    f0ephem=0;
    df0ephem=0;
else
    ephyes=1;
    if (~isfield(source,'ephstarttime') || ~isfield(source,'ephendtime'))
        error('No start and/or stop time in the source structure.');
    else
        fprintf('start time: %f - end time: %f\n',source.ephstarttime,source.ephendtime);
    end
   ephemeris = load(source.ephfile);
   vals = find(ephemeris(:,1) >= source.ephstarttime & ephemeris(:,1) <= source.ephendtime);
   tephem=ephemeris(vals,1)+ephemeris(vals,2)/86400;
   f0ephem=ephemeris(vals,3);
   df0ephem=ephemeris(vals,4);
end
