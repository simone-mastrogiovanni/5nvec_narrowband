% compile all the FrvSocket library for MatLab
%
% by M.Punturo
% 22/03/05
% revised by A. Eleuteri
%   the script recognizes the platform on which it runs.
% 1/6/05
%
%revised by punturo 13/02/06
%

function Make(platform)
% Compile the FrvSocket library for Matlab
% Make

if strcmp(computer,'PCWIN')
    WsLib=fullfile(matlabroot,'sys','lcc','lib','wsock32.lib');
    platform='-DWINDOWS';
    mex('MatFrvClient.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrSFileITEnd.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrSFileITStart.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvS_close_connection.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvS_FileIEnd.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvS_FrIfile.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSconnect.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSFileIGetV.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSFrameInfoDownload.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSGetVect.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSIncrFrame.c',platform,'-DNOFRVLIB',WsLib)
    mex('MatFrvSFileIGetAdcNames.c',platform,'-DNOFRVLIB',WsLib)
else
    platform='-DUNIX';
    mex('MatFrvClient.c','-DNOFRVLIB',platform)    
    mex('MatFrSFileITEnd.c','-DNOFRVLIB',platform)
    mex('MatFrSFileITStart.c','-DNOFRVLIB',platform)
    mex('MatFrvS_close_connection.c','-DNOFRVLIB',platform)
    mex('MatFrvS_FileIEnd.c','-DNOFRVLIB',platform)
    mex('MatFrvS_FrIfile.c','-DNOFRVLIB',platform)
    mex('MatFrvSconnect.c','-DNOFRVLIB',platform)
    mex('MatFrvSFileIGetV.c','-DNOFRVLIB',platform)
    mex('MatFrvSFrameInfoDownload.c','-DNOFRVLIB',platform)
    mex('MatFrvSGetVect.c','-DNOFRVLIB',platform)
    mex('MatFrvSIncrFrame.c','-DNOFRVLIB',platform)
    mex('MatFrvSFileIGetAdcNames.c','-DNOFRVLIB',platform)
end

