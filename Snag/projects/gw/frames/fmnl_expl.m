function fmnl_expl(file)
%FMNL_EXPLORE   explores frame file
%
%   Frame Matlab Native Library
%
%      fid=fmnl_explore(file)
%
%   file    ...

% Version 1.0 - October 1999
% Part of Snag toolbox - Signal and Noise for Gravitational Antennas
% Copyright (C) 1999  Sergio Frasca - sergio.frasca@roma1.infn.it
% Department of Physics - Universita` "La Sapienza" - Rome

disp(file)

[sel,ok]=listdlg('PromptString',{'Select an option:' ''},...
   				 'Name','Frame file Explorer',...
                'SelectionMode','single',...
                'ListString',{'Display all structures'...
                   'Display structures 1'...
                   'Display structures 1 and 2'...
                   'Display structures of type x'...
                   'Only the first x structures'...
                   'Structure sequence raw'...
                   'Structure sequence analytical'...
                   'Show FrVect'...
                   'Only resume'});
             
if sel == 4
   answ=inputdlg('Enter type number',...
      'Display structures of type...');
   ntyp=eval(answ{1});
end

nmin=0;nmax=1000000;
if sel == 5
   answ=inputdlg({'Init number' 'Final number'},...
      'Enter number of structures to display',2,...
   	{'1' '1000000'});
   nmin=eval(answ{1});
   nmax=eval(answ{2});
end

r_struct=fmnl_open(file,1);
fid=r_struct.cont.fid;

pos=ftell(fid)

fst_typ=0;
types=sparse(10000000,1);
classes=zeros(100,1);

ii=0;
iii=0;
iiiii=0;
frstat=0;

while fst_typ ~= -4
   fst=fmnl_read_struct(fid,struct_num);
   iii=iii+1;
   if fst.len <= 0
      disp('Error: structure length = 0');
      disp(fst);
      break;
   end
   fst_typ=fst.classtype;
   fst_typ1=fst_typ+1;
   types(fst_typ1)=types(fst_typ1)+1;
   
   if fst_typ == 1
      ii=ii+1;
      name1{ii}=fst.name;
      class1(ii)=fst.class;
   end
   
   if sel == 1
      disp(fst);
   end
   if sel == 2
      if fst_typ == 1
         disp(fst);
         pause
      end
   end
   if sel == 3
      if fst_typ < 3
         disp(fst);
         pause
      end
   end
   if sel == 4
      if fst_typ == ntyp
         disp(fst);
         pos=ftell(fid);
         fprintf(' structure, position :  %d, %d \n',iii,pos);
         pause
      end
   end
   if sel == 5
      if iii >= nmin & iii <= nmax
         disp(fst);
         pause
      end
   end
   if sel == 6
      if iiiii == 0
         fprintf('\n %4d',iii);
      end
      fprintf(' %3d ->%7d   ',fst.classtype,fst.len);
      iiiii=iiiii+1;
      if iiiii == 5
         iiiii=0;
      end
   end
   if sel == 7
      if frstat == 1
         if fst.classtype ~= 2
            frstat=0;
            fprintf('\n');
            iiiii=0;
         end
      end
      if fst.classtype == 1
         frstat=1;
         fprintf('\n Dictionary of %s \n',fst.name);
         iiiii=0;
      end
      if fst.classtype == struct_num(1) & frstat ~= 1
         fprintf('\n New frame  %d  - %d %d \n',fst.frame,fst.gps_s,fst.gps_n);
         iiiii=0;
      end
      fprintf(' %3d ->%7d    ',...
         fst.classtype,fst.len);
      iiiii=iiiii+1;
      if iiiii == 5
         fprintf('\n');
         iiiii=0;
      end
   end
   if sel == 8
      if fst_typ == struct_num(12)
         disp(fst);
         pos=ftell(fid);
         fprintf(' structure, position :  %d, %d \n',iii,pos);
         ans=input('Plot it ?  Y/N  [N]: ','s');
         if isempty(ans)
            ans='N';
         end
         if ans == 'y' | ans == 'Y'
            x=(1:fst.ndata)*fst.dx;
            plot(x,fst.data);zoom on
         end
      end
   end
end

%disp('Hit any key to go');
%disp(' ')
%pause
%k=find(types);
%ktyp(:,1)=(k-1);
%ktyp(:,2)=types(k);
%disp('  Structure types');disp(' ');
%disp(ktyp);

%class1,name1
disp('Hit any key to go');
disp(' ')
pause
disp('   Frame types: number,name,occurrence');
disp(' ')
for i = 1:ii
   fprintf('  %4d  -> %12s\t %5d \n',class1(i),name1{i},types(class1(i)+1));
end

pos=ftell(fid)