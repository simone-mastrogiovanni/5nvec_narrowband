function out=LM_read(file)
% LM_READ reads files of type Pasco (generalized) or SnagLab
%
%       out=LM_read(file)
%
%   out       output structure
%      .type  102  Pasco standard (x y) ; unclevel = 0
%             101  Pasco y              ; unclevel = 0
%             103  Pasco x y dy         ; unclevel = 1
%             104  Pasco x dx y dy      ; unclevel = 2
%             201  SnagLab UD           ; unclevel = 2
%             202  SnagLab MD           ; unclevel = 20
%             203  SnagLab SD           ; unclevel = 0
%      .n     number of data (number of rows)
%      .m     number of y values for each row
%      .x
%      .dx
%      .y
%      .dy
%      .sel   selected (1 or 0)
%      .unclevel

% Project LabMec - part of the toolbox Snag - April 2009
% by Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Sapienza University - Rome

if ~exist('fil','var')
    [file pathname]=uigetfile('*.*');
    file=[pathname file];
end

fid=fopen(file);

if fid > 0
    disp([file ' opened'])
else
    disp([file ' not opened'])
    out=0;
    return
end

line=fgetl(fid);
disp(line);

typ=0;
n=0;

if line(1:3) == '#UD'
    typ=201;
    out.unclevel=2;
    line=fgetl(fid);
    disp(line);
    line=fgetl(fid);
    disp(line);
    while 1
        line=fgetl(fid);
        line=strrep(line,',','.');
        
        n=n+1;
        a=sscanf(line,' %g');
        out.x(n)=a(1);
        out.dx(n)=a(2);
        out.y(n)=a(3);
        out.dy(n)=a(4);
        out.sel(n)=a(5);
        
        if feof(fid) 
            break
        end
    end
elseif line(1:3) == '#MD'
    typ=202;
    out.unclevel=20;
    line=fgetl(fid);
    disp(line);
    a=sscanf(line,' %d');
    m=a(1);
    line=fgetl(fid);
    disp(line);
    a=sscanf(line,' %g');
    out.dx=a(1);
    out.dy=a(2);
    for i = 1:m
        line=fgetl(fid);
        disp(line);
    end
    while 1
        line=fgetl(fid);
        line=strrep(line,',','.');
        
        n=n+1;
        a=sscanf(line,' %g');
        out.x(n)=a(1);
        for i = 1:m
            out.y(i,n)=a(i+1);
        end
        
        if feof(fid) 
            break
        end
    end
elseif line(1:3) == '#SD'
    typ=203;
    out.unclevel=0;
    line=fgetl(fid);
    disp(line);
    line=fgetl(fid);
    disp(line);
    line=strrep(line,',','.');
    a=sscanf(line,' %g');
    t1=a(2);
    dt=a(3);
    out.ini=t1;
    out.dt=dt;
    
    c=fscanf(fid,'%c');
    c=strrep(c,',','.');

    c=sscanf(c,'%g');
    out.n=length(c);
    out.y=c;
    out.x=t1+dt*(0:out.n-1)';
else
    line=fgetl(fid);
    disp(line);
    
    while 1
        line=fgetl(fid);
        line=strrep(line,',','.');
        
        n=n+1;
        a=sscanf(line,' %g');
        if n == 1
            typ=100+length(a);
            out.type=typ;
        end
        out.unclevel=typ-102;
        if typ == 101
            out.y(n)=a(1);
        elseif typ == 102
            out.x(n)=a(1);
            out.y(n)=a(2);
        elseif typ == 103
            out.x(n)=a(1);
            out.y(n)=a(2);
            out.dy(n)=a(3);
        elseif typ == 104
            out.x(n)=a(1);
            out.dx(n)=a(2);
            out.y(n)=a(3);
            out.dy(n)=a(4);
        else
            disp(' *** ERROR !')
        end
        
        if feof(fid) 
            break
        end
    end
end

fclose(fid);

out.type=typ;
out.n=n;