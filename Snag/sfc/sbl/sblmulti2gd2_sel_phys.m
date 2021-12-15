function g2=sblmulti2gd2_sel_phys(file,chn,x,y,maxl)
% sbl2gd2_sel_phys  puts a selection of data from an sbl file in a gd2 
%
%  Simplest way to call:  g2=sbl2gd2_sel_phys   (no arguments - interactive)
%
%   file        input file or cell array with multiple files of the same type
%   chn         number of the channel
%   x           a 2 value array containing the min and the max time; 0 -> all
%               the third integer value, if present, means average every
%   y           a 2 value array containing the min and the max of the secondary abscissa; 0 -> all
%               the third integer value, if present, means average every
%   maxl        maximum length of the data output (t component)
%
%  If the arguments are not present, asks interactively.
%  It works on chained files.

% Version 2.0 - November 2010
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Università "Sapienza" - Rome

if ~exist('maxl','var')
    maxl=110000;
end

if iscell(file)
    filecell=file;
else
    filecell={file};
end

nfil=length(filecell);
iii=0;
iix=0;
iiy=0;

for icell = 1:nfil
    file=filecell{icell}

    sbl_=sbl_open(file);
    t0=sbl_.t0;
    dt=sbl_.dt;
    n=sbl_.len;

    if ~exist('chn')
        for i = 1:sbl_.nch
            chss{i}=sbl_.ch(i).name;
        end
        [iadc iok]=listdlg('PromptString','Select a channel',...
           'Name','Channel selection',...
           'SelectionMode','single',...
           'ListString',chss);
        chn=iadc;
    end

    m=sbl_.ch(chn).lenx;
    inix=sbl_.ch(chn).inix;
    dx=sbl_.ch(chn).dx;
    nstr=sprintf('%d',n);
    mstr=sprintf('%d',m);

    if icell == 1
        if length(x) == 2
            x(3)=1;
        end
        if length(x) == 1
            x(1)=0;
            x(2)=99999;
            x(3)=1;
        end
        if length(y) == 2
            y(3)=1;
        end
        if length(y) == 1
            y(1)=inix;
            y(2)=inix+dx*(m-1);
            y(3)=1;
        end

        indmin=round((y(1)-inix)/dx+1);
        if indmin < 1
            indmin=1;
        end
        if indmin > m
            indmin=m;
        end

        indmax=round((y(2)-inix)/dx+1);
        if indmax < 1
            indmax=1;
        end
        if indmax > m
            indmax=m;
        end

        nx=floor(n/x(3));
        ny=floor((indmax-indmin+1)/y(3));
        indmax=indmin+ny*y(3)-1;
        out=zeros(maxl,ny);
        out1=zeros(1,ny);
        iniy=(indmin-1)*dx+inix;
        dy=dx*y(3);
    end

    tbl=t0;
    t2=0;indmin,indmax

    while tbl < x(2)
        [M,t1,blhead]=sbl_read_block(sbl_,chn,indmin,indmax);
        tbl=t1;
        if t1 > x(2)
            break
        end
    %     if strcmp(blhead,'No block')
        if t1 == 0
            break
        end
        if t1 < x(1)
            continue
        end
        M=M{1};
        iii=iii+1;
        t2=t2+t1;
        for i = 1:ny
            ii=(i-1)*y(3);
            out1(i)=out1(i)+mean(M(ii+1:ii+y(3)));
        end
        if floor(iii/x(3))*x(3) == iii
            iix=iix+1;
            t(iix)=t2/x(3);
            out(iix,:)=out1/x(3);
            out1=zeros(1,ny);
            t2=0;
        end 
        if floor(iix/1000)*1000 == iix
            iix
        end
    end
    fclose(sbl_.fid);
end

out=out(1:iix,:);

g2=gd2(out);
g2=edit_gd2(g2,'type',2,'x',t,'dx',dt,'ini2',iniy,'dx2',dy,'ini',t(1));