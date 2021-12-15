% snag_file_doctor

file=selfile(' ')

fid=fopen(file);

answ=inputdlg({'Ini byte' 'Type' 'N data'},'Data to extract',1,{'0' 'float' '100'});
ini=eval(answ{1})
typ=answ{2}
N=eval(answ{3})

fseek(fid,ini,'bof')
y=fread(fid,N,typ);

fclose(fid)