function varargout = MatDataDisplay2(varargin)
% MATDATADISPLAY2 M-file for MatDataDisplay2.fig
%      MATDATADISPLAY2, by itself, creates a new MATDATADISPLAY2 or raises the existing
%      singleton*.
%
%      H = MATDATADISPLAY2 returns the handle to a new MATDATADISPLAY2 or the handle to
%      the existing singleton*.
%
%      MATDATADISPLAY2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MATDATADISPLAY2.M with the given input arguments.
%
%      MATDATADISPLAY2('Property','Value',...) creates a new MATDATADISPLAY2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MatDataDisplay2_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MatDataDisplay2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help MatDataDisplay2

% Last Modified by GUIDE v2.5 29-May-2006 12:08:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MatDataDisplay2_OpeningFcn, ...
                   'gui_OutputFcn',  @MatDataDisplay2_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before MatDataDisplay2 is made visible.
function MatDataDisplay2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MatDataDisplay2 (see VARARGIN)

% Choose default command line output for MatDataDisplay2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% This sets up the initial plot - only do when we are invisible
% so window can get raised using MatDataDisplay2.
if strcmp(get(hObject,'Visible'),'off')
    plot(rand(5));
end

% UIWAIT makes MatDataDisplay2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = MatDataDisplay2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
cla;

popup_sel_index = get(handles.popupmenuChannel, 'Value');
str = get(handles.popupmenuChannel, 'String');

ChannelName = str{popup_sel_index};
GPSstart = str2double(get(handles.editGPSstart, 'String'));
GPSFileStart = str2double(get(handles.editGPSFileStart, 'String'));
if (GPSstart < GPSFileStart)
    GPSstart = GPSFileStart;
    set(handles.editGPSstart, 'String',get(handles.editGPSFileStart, 'String'));
end
Nseconds = str2double(get(handles.editDuration, 'String'));
NLoops = floor(str2double(get(handles.editLoops, 'String')));
GPSend = GPSstart+Nseconds*NLoops;
set(handles.editGPSend, 'String',int2str(GPSend));

%fprintf(1,'Channel : %s  Duration %f\n',ChannelName,Duration);


fd = connectRemoteServer(hObject, eventdata, handles);
for i=1:NLoops
    i
    [myVect.nData,myVect.dx,myVect.DataD]=MatFrvSFileIGetV(fd,ChannelName,GPSstart,Nseconds);
%
    myVect.nData
    Fs=1/myVect.dx % sampling frequency
    if (get(handles.checkboxFilter,'Value') == 1)
        if (i==1)
            [b,a] = BuildFilter(hObject, eventdata, handles,Fs);
            [myVect.DataD,zf] = filter(b,a,myVect.DataD)
        else
            [myVect.DataD,zf] = filter(b,a,myVect.DataD,zf)
        end
    end
        
    GTimeEnd=0+Nseconds-myVect.dx;   %plot the time sequence
    t=0:myVect.dx:GTimeEnd;
    axes(handles.axes1);
    plot(t,myVect.DataD);
    title(ChannelName);
    drawnow;
    
    if(get(handles.DuplTimePlot,'Value')==1)
        figure(2);
        plot(t,myVect.DataD);
        title(ChannelName);
        xlabel(strcat('GPSstart  ',num2str(GPSstart)));
        drawnow;
        axes(handles.axes1);
    end
    
% output file if selected
 if(get(handles.checkboxOutFile,'Value')==1)
     if(i==1) 
         fid = fopen(get(handles.editOutFile,'String'),'w');
         fprintf(fid,'GPStime %s\n',ChannelName);
     end 
     for kk=1:myVect.nData
         fprintf(fid,'%12.4f %e\n',GPSstart+t(kk),myVect.DataD(kk));
     end
 end
%
% create PSD
    if (get(handles.PSDon,'Value')==1) 
        if(i==1)
            popup_sel_index = get(handles.popupWindow, 'Value');
            str = get(handles.popupWindow, 'String');
            PSDwindowName=str{popup_sel_index};
            switch PSDwindowName
                case 'Rectangular'
                    PSDwindow = rectwin(myVect.nData);
                case 'Bartlett-Hann'
                    PSDwindow = barthannwin(myVect.nData);
                case 'Blackman-harris'
                    PSDwindow = blackmanharris(myVect.nData);
                case 'Bohman'
                    PSDwindow = bohmanwin(myVect.nData);            
            end
            [Pxx,f] = periodogram(myVect.DataD,PSDwindow,[],Fs);
            SummPxx = Pxx;
        else
            Pxx = periodogram(myVect.DataD,PSDwindow);
            SummPxx = SummPxx + Pxx;
        end
    avePxx = SummPxx / i;
    axes(handles.axesPSD);
    cla;
    semilogy(f,avePxx);
%  
    if(get(handles.DuplTimePlot,'Value')==1)
        figure(3);
        semilogy(f,avePxx);
        title(strcat(ChannelName,' FFT'));
        xlabel(strcat('GPSstart  ',num2str(GPSstart)));
        axes(handles.axes1);
    end
    drawnow;
    clear Pxx;
    end
%    
% audio output
    if (get(handles.checkboxAudio,'Value') == 1)
       Massimo = max(myVect.DataD);
       Minimo  = min(myVect.DataD);
       Media   = mean(myVect.DataD);
       Volume = get(handles.sliderVolume, 'Value');
       AudioOutput = ((myVect.DataD-Media)/(Massimo-Minimo)+Media)*Volume;
%       max(AudioOutput)
%       min(AudioOutput)
       wavplay(AudioOutput,Fs,'async');
       clear AudioOutput;
    end
%    
%    
    GPSstart = GPSstart + Nseconds;
    clear myVect.*;
end

% close output file if it has been open
if(get(handles.checkboxOutFile,'Value')==1)
    fclose(fid);
     % FFT file
    if (get(handles.PSDon,'Value')==1) 
        [pathstr, nameFileOut, ext, versn] = fileparts(get(handles.editOutFile,'String'))
        nameFileFFT=strcat(pathstr,'\FFT',nameFileOut,ext);
        fid = fopen(nameFileFFT,'w');
        fprintf(fid,'freq %s\n',strcat(ChannelName,'FFT'));
        for kk=1:numel(avePxx)
            fprintf(fid,'%12.4f %e\n',f(kk),avePxx(kk));
        end
        fclose(fid);
    end 
end
    
if ((get(handles.PSDon,'Value')==1) & (i==1))    
  MaxF=length(f);
  MinF=0;
  set(handles.sliderMin,'Min',0);
  set(handles.sliderMin,'Max',f(MaxF-1));

  set(handles.sliderMax,'Max',f(MaxF));
  set(handles.editMaxSlider,'String',num2str(f(MaxF)));
  set(handles.sliderMax,'Value',f(MaxF)); %set min freq of the max slider
  set(handles.sliderMax,'Min',f(2));
end

MatFrvS_FileIEnd(fd); % close the file
MatFrvS_close_connection(fd);

clear avePxx;
clear SummPxx;
clear t;
clear f;

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
file = uigetfile('*.fig');
if ~isequal(file, 0)
    open(file);
end

% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
printdlg(handles.figure1)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selection = questdlg(['Close ' get(handles.figure1,'Name') '?'],...
                     ['Close ' get(handles.figure1,'Name') '...'],...
                     'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end

delete(handles.figure1)


% --- Executes on selection change in popupmenuChannel.
function popupmenuChannel_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuChannel contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuChannel


% --- Executes during object creation, after setting all properties.
function popupmenuChannel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});




function editFilename_Callback(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editFilename as text
%        str2double(get(hObject,'String')) returns contents of editFilename as a double


% --- Executes during object creation, after setting all properties.
function editFilename_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editFilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on selection change in popupmenuFrvServers.
function popupmenuFrvServers_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuFrvServers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenuFrvServers contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuFrvServers


% --- Executes during object creation, after setting all properties.
function popupmenuFrvServers_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuFrvServers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editGPSFilestart_Callback(hObject, eventdata, handles)
% hObject    handle to editGPSFilestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGPSFilestart as text
%        str2double(get(hObject,'String')) returns contents of editGPSFilestart as a double


% --- Executes during object creation, after setting all properties.
function editGPSFilestart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGPSFilestart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editGPSend_Callback(hObject, eventdata, handles)
% hObject    handle to editGPSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGPSend as text
%        str2double(get(hObject,'String')) returns contents of editGPSend as a double


% --- Executes during object creation, after setting all properties.
function editGPSend_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGPSend (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushConnect.
function pushConnect_Callback(hObject, eventdata, handles)
% hObject    handle to pushConnect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fd = connectRemoteServer(hObject, eventdata, handles);

GPSstart=MatFrSFileITStart(fd); % read GPS start time of the file
[GPSstartString,GPSstartStringError] = sprintf('%10.0f',GPSstart);
set(handles.editGPSFileStart,'String',GPSstartString);
set(handles.editGPSFileStart,'Value',GPSstart);
%
GPSend=MatFrSFileITEnd(fd); % read GPS end time of the file 
[GPSendString,GPSendStringError] = sprintf('%10.0f',GPSend);
set(handles.editGPSFileEnd,'String',GPSendString);
set(handles.editGPSFileEnd,'Value',GPSend);
% close the file
MatFrvS_FileIEnd(fd);
MatFrvS_close_connection(fd);



function editGPSstart_Callback(hObject, eventdata, handles)
% hObject    handle to editGPSstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGPSstart as text
%        str2double(get(hObject,'String')) returns contents of editGPSstart as a double


% --- Executes during object creation, after setting all properties.
function editGPSstart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGPSstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editGPSFileStart_Callback(hObject, eventdata, handles)
% hObject    handle to editGPSFileStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editGPSFileStart as text
%        str2double(get(hObject,'String')) returns contents of editGPSFileStart as a double


% --- Executes during object creation, after setting all properties.
function editGPSFileStart_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editGPSFileStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editDuration_Callback(hObject, eventdata, handles)
% hObject    handle to editDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDuration as text
%        str2double(get(hObject,'String')) returns contents of editDuration as a double


% --- Executes during object creation, after setting all properties.
function editDuration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on key press over editDuration with no controls selected.
function editDuration_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to editDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ----- Returns socket ID for the connection defined by server and filename ------%
function fd = connectRemoteServer(hObject, eventdata, handles)
% hObject    handle to editDuration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  popup_sel_index = get(handles.popupmenuFrvServers, 'Value');
  str = get(handles.popupmenuFrvServers, 'String');

  RemoteServer = str{popup_sel_index};

  fd=MatFrvSconnect(RemoteServer,1490);
  [SocketString,SocketStringError] = sprintf('%d',fd);
  set(handles.textSocket,'String',SocketString); % write the socket ID 

  RemoteFile = get(handles.editFilename,'String');
  MatFrvS_FrIfile(fd,RemoteFile); % open remote file

return


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1




% --- Executes on button press in pushbuttonUpdate.
function pushbuttonUpdate_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GPSstart = str2double(get(handles.editGPSstart, 'String'));
GPSend = str2double(get(handles.editGPSend, 'String'));
NLoops = floor(str2double(get(handles.editLoops, 'String')));
Nseconds = ceil((GPSend-GPSstart)/NLoops);
set(handles.editGPSend, 'String',int2str(GPSstart+NLoops*Nseconds));
set(handles.editDuration, 'String',int2str(Nseconds));



% --- Executes on selection change in popupWindow.
function popupWindow_Callback(hObject, eventdata, handles)
% hObject    handle to popupWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupWindow contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupWindow


% --- Executes during object creation, after setting all properties.
function popupWindow_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupWindow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in checkboxGridX.
function checkboxGridX_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGridX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGridX

if (get(hObject,'Value')==1)
    axes(handles.axesPSD);
    set(handles.axesPSD,'XGrid','on');
else
    axes(handles.axesPSD);
    set(handles.axesPSD,'XGrid','off');
end



% --- Executes on button press in checkboxGridY.
function checkboxGridY_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxGridY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxGridY

if (get(hObject,'Value')==1)
    axes(handles.axesPSD);
    set(handles.axesPSD,'YGrid','on');
else
    axes(handles.axesPSD);
    set(handles.axesPSD,'YGrid','off');
end


% --- Executes during object creation, after setting all properties.
function checkboxGridX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to checkboxGridX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in checkboxLogX.
function checkboxLogX_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLogX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLogX


if (get(hObject,'Value')==1)
    axes(handles.axesPSD);
    set(handles.axesPSD,'XScale','log');
else
    axes(handles.axesPSD);
    set(handles.axesPSD,'XScale','linear');
end



% --- Executes on button press in checkboxLogY.
function checkboxLogY_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxLogY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxLogY

if (get(hObject,'Value')==1)
    axes(handles.axesPSD);
    set(handles.axesPSD,'YScale','log');
else
    axes(handles.axesPSD);
    set(handles.axesPSD,'YScale','linear');
end


% --- Executes on slider movement.
function sliderMin_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

 MinFreq = get(hObject,'Value');
 set(handles.editMinSlider, 'String', num2str(MinFreq));
 updateLowerPSD(MinFreq, handles);
 

% --- Executes during object creation, after setting all properties.
function sliderMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on slider movement.
function sliderMax_Callback(hObject, eventdata, handles)
% hObject    handle to sliderMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

 MaxFreq = get(hObject,'Value');
 set(handles.editMaxSlider, 'String', num2str(MaxFreq));
 updateUpperPSD(MaxFreq, handles) ;
 


% --- Executes during object creation, after setting all properties.
function sliderMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editLoops_Callback(hObject, eventdata, handles)
% hObject    handle to editLoops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLoops as text
%        str2double(get(hObject,'String')) returns contents of editLoops as a double


% --- Executes during object creation, after setting all properties.
function editLoops_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLoops (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes during object creation, after setting all properties.
function pushbuttonUpdate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbuttonUpdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





function editCutIN_Callback(hObject, eventdata, handles)
% hObject    handle to editCutIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCutIN as text
%        str2double(get(hObject,'String')) returns contents of editCutIN as a double


% --- Executes during object creation, after setting all properties.
function editCutIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCutIN (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function editCutOFF_Callback(hObject, eventdata, handles)
% hObject    handle to editCutOFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editCutOFF as text
%        str2double(get(hObject,'String')) returns contents of editCutOFF as a double


% --- Executes during object creation, after setting all properties.
function editCutOFF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editCutOFF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editOrder_Callback(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOrder as text
%        str2double(get(hObject,'String')) returns contents of editOrder as a double


% --- Executes during object creation, after setting all properties.
function editOrder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in checkboxFilter.
function checkboxFilter_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxFilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxFilter

if (get(hObject,'Value')==1)
    set(handles.uipanel7,'Visible','on');
    set(handles.editCutIN,'Visible','on');
    set(handles.editCutOFF,'Visible','on');
    set(handles.editOrder,'Visible','on');
    if (get(handles.radiobuttonLP,'Value') == 1)
        set(handles.editCutIN,'Visible','off');        
    end
    if (get(handles.radiobuttonHP,'Value') == 1)
        set(handles.editCutOFF,'Visible','off');        
    end
else
    set(handles.uipanel7,'Visible','off');
    
    set(handles.editCutIN,'Visible','off');
    set(handles.editCutOFF,'Visible','off');
    set(handles.editOrder,'Visible','off');

end




% --- Executes on button press in radiobuttonLP.
function radiobuttonLP_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonLP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonLP

if (get(hObject,'Value')==1)
    set(handles.editCutIN,'Visible','off');
    set(handles.editCutOFF,'Visible','on');
    set(handles.editOrder,'Visible','on');
end


% --- Executes on button press in radiobuttonHP.
function radiobuttonHP_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonHP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonHP
if (get(hObject,'Value')==1)
    set(handles.editCutIN,'Visible','on');
    set(handles.editCutOFF,'Visible','off');
    set(handles.editOrder,'Visible','on');
end



% --- Executes on button press in radiobuttonBP.
function radiobuttonBP_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonBP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonBP

if (get(hObject,'Value')==1)
    set(handles.editCutIN,'Visible','on');
    set(handles.editCutOFF,'Visible','on');
    set(handles.editOrder,'Visible','on');
end


% --- Executes on button press in radiobuttonBS.
function radiobuttonBS_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonBS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobuttonBS

if (get(hObject,'Value')==1)
    set(handles.editCutIN,'Visible','on');
    set(handles.editCutOFF,'Visible','on');
    set(handles.editOrder,'Visible','on');
end

%
% Build filter parameters
%
function [b,a] = BuildFilter(hObject, eventdata, handles,sfreq)

if(get(handles.checkboxFilter,'Value')==1)
  orderF = floor(str2double(get(handles.editOrder, 'String')));
  FiltroFlag = get(handles.radiobuttonLP,'Value');  % 1st bit LP 
  FiltroFlag = FiltroFlag+2*get(handles.radiobuttonHP,'Value'); % 2nd bit HP
  FiltroFlag = FiltroFlag+4*get(handles.radiobuttonBP,'Value'); % 3nd bit BP 
  FiltroFlag = FiltroFlag+8*get(handles.radiobuttonBS,'Value'); % 3nd bit BS
  switch FiltroFlag
      case 1 % LP
          Wn = 2*str2double(get(handles.editCutOFF, 'String'))/sfreq;
          if (Wn >= 1)
              Wn = 0.999;
              set(handles.editCutOFF, 'String',num2str(sfreq/2));
          end
          [b,a] = butter(orderF,Wn,'low');
          clear Wn;
      case 2 % HP
          Wn = 2*str2double(get(handles.editCutIN, 'String'))/sfreq;
          if (Wn >= 1)
              Wn = 0.999;
              set(handles.editCutIN, 'String',num2str(sfreq/2));
          end
          [b,a] = butter(orderF,Wn,'high');
          clear Wn;
      case 4 % BP
          Wn(1) = 2*str2double(get(handles.editCutIN, 'String'))/sfreq;
          Wn(2) = 2*str2double(get(handles.editCutOFF, 'String'))/sfreq;
          if (Wn(1)>Wn(2))
              Wtemp = Wn(1);
              Wn(1)=Wn(2);
              Wn(2)=Wtemp;
              set(handles.editCutIN, 'String',num2str(Wn(1)*sfreq/2));
              set(handles.editCutOFF, 'String',num2str(Wn(2)*sfreq/2));
          end
          if (Wn(2) >= 1)
              Wn = 0.999;
              set(handles.editCutOFF, 'String',num2str(sfreq/2))
          end
          [b,a] = butter(orderF,Wn);
          clear Wn;  
      case 8 % BS
          Wn(1) = 2*str2double(get(handles.editCutIN, 'String'))/sfreq;
          Wn(2) = 2*str2double(get(handles.editCutOFF, 'String'))/sfreq;
          if (Wn(1)>Wn(2))
              Wtemp = Wn(1);
              Wn(1)=Wn(2);
              Wn(2)=Wtemp;
              set(handles.editCutIN, 'String',num2str(Wn(1)*sfreq/2));
              set(handles.editCutOFF, 'String',num2str(Wn(2)*sfreq/2));
          end
          if (Wn(2) >= 1)
              Wn = 0.999;
              set(handles.editCutOFF, 'String',num2str(sfreq/2))
          end
          [b,a] = butter(orderF,Wn,'stop');
          clear Wn;     
  end
end
return


% --- Executes on button press in checkboxAudio.
function checkboxAudio_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxAudio (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxAudio
 if (get(hObject,'Value')==1)
    set(handles.sliderVolume ,'Visible','on');
    set(handles.textVolume ,'Visible','on');
 else
    set(handles.sliderVolume ,'Visible','off');
    set(handles.textVolume ,'Visible','off');
 end



% --- Executes on slider movement.
function sliderVolume_Callback(hObject, eventdata, handles)
% hObject    handle to sliderVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

 Volume=get(hObject,'Value');
 set(handles.textVolume, 'String',num2str(Volume));

% --- Executes during object creation, after setting all properties.
function sliderVolume_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderVolume (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end





function editMinSlider_Callback(hObject, eventdata, handles)
% hObject    handle to editMinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinSlider as text
%        str2double(get(hObject,'String')) returns contents of editMinSlider as a double
%
MinFreq =str2double(get(hObject,'String'));
set(handles.sliderMin, 'Value',MinFreq);
updateLowerPSD(MinFreq, handles);


% --- Executes during object creation, after setting all properties.
function editMinSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


function editMaxSlider_Callback(hObject, eventdata, handles)
% hObject    handle to editMaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMaxSlider as text
%        str2double(get(hObject,'String')) returns contents of editMaxSlider as a double
 MaxFreq =str2double(get(hObject,'String'));
 set(handles.sliderMax, 'Value',MaxFreq);
 updateUpperPSD(MaxFreq, handles) ;


% --- Executes during object creation, after setting all properties.
function editMaxSlider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMaxSlider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


%update lower limit of the PSD plot
function updateLowerPSD(MinFreq, handles)
 MinMaxFreq = get(handles.axesPSD,'XLim');
 MinMaxFreq(1)=MinFreq;
 set(handles.axesPSD,'XLim',MinMaxFreq); % change scale in the plot
 set(handles.sliderMax,'Min',MinFreq+0.0001); %set min freq of the max slider
 
%update upper limit of the PSD plot
function updateUpperPSD(MaxFreq, handles) 
 MinMaxFreq = get(handles.axesPSD,'XLim');
 MinMaxFreq(2)=MaxFreq;
 set(handles.axesPSD,'XLim',MinMaxFreq); % change scale in the plot
 set(handles.sliderMin,'Max',MaxFreq-0.0001); %set min freq of the max slider
 
 


% --- Executes on button press in checkboxOutFile.
function checkboxOutFile_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxOutFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxOutFile
 if (get(hObject,'Value')==1)
    set(handles.editOutFile ,'Visible','on');
 else
     set(handles.editOutFile ,'Visible','off');
 end


function editOutFile_Callback(hObject, eventdata, handles)
% hObject    handle to editOutFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOutFile as text
%        str2double(get(hObject,'String')) returns contents of editOutFile as a double


% --- Executes during object creation, after setting all properties.
function editOutFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOutFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in updateListChannels.
function updateListChannels_Callback(hObject, eventdata, handles)
% hObject    handle to updateListChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

prompt = {'File where to read the TOC'};
dlg_title = 'Channel list update';
num_lines = 1;
def =  cellstr(get(handles.editFilename,'String'));
fileTOC = inputdlg(prompt,dlg_title,num_lines,def);

if (length(fileTOC)==0)
    return;
end

fileTOC=strvcat(fileTOC);
%
% changes temporarely the filename to use standard connect function
set(handles.editFilename,'String',fileTOC);    

% connect remote server
fd = connectRemoteServer(hObject, eventdata, handles);

[myVect.nData,myVect.dataQbin]=MatFrvSFileIGetAdcNames(fd);
myVect.dataQ = cellstr(myVect.dataQbin);
MatFrvS_FileIEnd(fd);
MatFrvS_close_connection(fd);

if(strfind(fileTOC,'trend'))
    fid=fopen('lastTrend.txt','wt');
else if(strfind(fileTOC,'raw'))
        fid=fopen('lastRaw.txt','wt');
    else
        fid=fopen('lastUnknown.txt','wt');
    end
end

txtChannels=strvcat(myVect.dataQbin);

for i=1:myVect.nData
    fprintf(fid,'%s\n',txtChannels(i,:));
end
%
fclose(fid);

%restore standard filename
set(handles.editFilename,'String',strvcat(def));
set(handles.popupmenuChannel,'String',myVect.dataQ);
clear myVect.*


% --- Executes on button press in PlotEditor.
function PlotEditor_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEditor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotEditor

   plotedit;
  



% --- Executes on button press in ZoomButton.
function ZoomButton_Callback(hObject, eventdata, handles)
% hObject    handle to ZoomButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ZoomButton
if (get(handles.ZoomButton,'Value')==1) 
    set(handles.plotEditorButton,'Value',0);
    zoom on;
else
    zoom off
end
    


% --- Executes on button press in plotEditorButton.
function plotEditorButton_Callback(hObject, eventdata, handles)
% hObject    handle to plotEditorButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plotEditorButton
if (get(handles.plotEditorButton,'Value')==1) 
    set(handles.ZoomButton,'Value',0);
    plotedit on;
else
    plotedit off
end



% --- Executes on button press in updateLocalList.
function updateLocalList_Callback(hObject, eventdata, handles)
% hObject    handle to updateLocalList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
prompt = {'File where to read the TOC'};
dlg_title = 'Channel list update through local file';
num_lines = 1;
def =  cellstr('lastTrend.txt');
fileName = inputdlg(prompt,dlg_title,num_lines,def)

if (length(fileName)==0)
    return;
end

fid=fopen(char(fileName),'r');
a= native2unicode(fgets(fid));
while (feof(fid)==0)
    b = native2unicode(fgets(fid));
    a = strvcat(a,b);
end
fclose(fid);
clear b
b=cellstr(a);
set(handles.popupmenuChannel,'String',b);

return


% --- Executes on button press in DuplTimePlot.
function DuplTimePlot_Callback(hObject, eventdata, handles)
% hObject    handle to DuplTimePlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DuplTimePlot


