function varargout = pacer_pannel(varargin)
% PACER_PANNEL MATLAB code for pacer_pannel.fig
%      PACER_PANNEL, by itself, creates a new PACER_PANNEL or raises the existing
%      singleton*.
%
%      H = PACER_PANNEL returns the handle to a new PACER_PANNEL or the handle to
%      the existing singleton*.
%
%      PACER_PANNEL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PACER_PANNEL.M with the given input arguments.
%
%      PACER_PANNEL('Property','Value',...) creates a new PACER_PANNEL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pacer_pannel_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pacer_pannel_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pacer_pannel

% Last Modified by GUIDE v2.5 20-Mar-2023 20:50:04

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pacer_pannel_OpeningFcn, ...
                   'gui_OutputFcn',  @pacer_pannel_OutputFcn, ...
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


% --- Executes just before pacer_pannel is made visible.
function pacer_pannel_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pacer_pannel (see VARARGIN)

% Choose default command line output for pacer_pannel
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes pacer_pannel wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pacer_pannel_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
%Z
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ModelName = 'spm_pacer';
    

    QZ = get(handles.slider1,'value');
    set(handles.edit1,'string',num2str(QZ));
    
    QY = get(handles.slider2,'value');
    set(handles.edit2,'string',num2str(QY));
    Qz = get(handles.slider7,'value');
    set(handles.edit6,'string',num2str(Qz));
    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
  [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
%        if (QZ==0)&&(QY==0)
%         du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         dw1 = aw1;
%       
%         dw2 = aw2;
%         dw3 = aw3;
% %         if (dw1>-10)&&(dw1<10)
% %         dir1 =-1;
% %         
% %         end
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%        end
%      [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(QZ,QY,Qz,dir1,dir2,dir3,du1,du2,du3);
    
    
    set(handles.edit7,'string',num2str(au1));
    set(handles.edit8,'string',num2str(au2));
    set(handles.edit9,'string',num2str(au3));
    set(handles.edit10,'string',num2str(aw1));
    set(handles.edit11,'string',num2str(aw2));
    set(handles.edit12,'string',num2str(aw3));
    if (abs(detJq)<0.002)||(abs(detJx)<0.002)
        set(handles.checkbox1,'value',1);
        set(handles.checkbox1,'BackgroundColor',[1 0 0]);
    else 
        set(handles.checkbox1,'value',0);
        set(handles.checkbox1,'BackgroundColor',[0 1 0]);
    end
    set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
    
    set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
     set_param([ModelName '/Srz'],'Gain',num2str(Qz))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
%Y----------
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

ModelName = 'spm_pacer';
    

    QZ = get(handles.slider1,'value');
    set(handles.edit1,'string',num2str(QZ));
    
    QY = get(handles.slider2,'value');
    set(handles.edit2,'string',num2str(QY));
    Qz = get(handles.slider7,'value');
    set(handles.edit6,'string',num2str(Qz));
    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
   [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
%    if (QZ==0)&&(QY==0)
%         du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         dw1 = aw1;
%       
%         dw2 = aw2;
%         dw3 = aw3;
% %         if (dw1>-10)&&(dw1<10)
% %         dir1 =-1;
% %         
% %         end
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%        end
%      [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(QZ,QY,Qz,dir1,dir2,dir3,du1,du2,du3);
    set(handles.edit7,'string',num2str(au1));
    set(handles.edit8,'string',num2str(au2));
    set(handles.edit9,'string',num2str(au3));
    set(handles.edit10,'string',num2str(aw1));
    set(handles.edit11,'string',num2str(aw2));
    set(handles.edit12,'string',num2str(aw3));
    if (abs(detJq)<0.002)||(abs(detJx)<0.002)
        set(handles.checkbox1,'value',1);
        set(handles.checkbox1,'BackgroundColor',[1 0 0]);
    else 
        set(handles.checkbox1,'value',0);
        set(handles.checkbox1,'BackgroundColor',[0 1 0]);
    end
    set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
    
    set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
     set_param([ModelName '/Srz'],'Gain',num2str(Qz))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))
% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton1.
%RUN--------------------------------------------------
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ModelName = 'spm_pacer';
open_system(ModelName);

set_param(ModelName,'BlockReduction','off');
set_param(ModelName,'StopTime','400');
set_param(ModelName,'StartFcn','1');
set_param(ModelName,'SimulationCommand','start');
set_param(ModelName,'EnablePacing','on');

% --- Executes on button press in pushbutton2.
%ZHome
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

 ModelName = 'spm_pacer';   

    QZ = 0;
    set(handles.edit1,'string',num2str(QZ));
    set(handles.slider1,'value',QZ);
    QY = get(handles.edit1,'value');
    Qz = get(handles.edit6,'value');
%     set(handles.edit2,'string',num2str(QY));
    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
    [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
    set_param([ModelName '/SU1'],'Gain',num2str(0))
    set_param([ModelName '/SU2'],'Gain',num2str(0))
    set_param([ModelName '/SU3'],'Gain',num2str(0))
    
    set_param([ModelName '/SW1'],'Gain',num2str(0))
    set_param([ModelName '/SW2'],'Gain',num2str(0))
    set_param([ModelName '/SW3'],'Gain',num2str(0))

        set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
     set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
    set_param([ModelName '/Srz'],'Gain',num2str(Qz))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ModelName = 'spm_pacer';   
set_param(ModelName,'SimulationCommand','stop');


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
dir1 = get(handles.slider4,'value');
set(handles.edit3,'string',num2str(dir1));

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
dir2 = get(handles.slider5,'value');
set(handles.edit4,'string',num2str(dir2));

% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
dir3 = get(handles.slider6,'value');
set(handles.edit5,'string',num2str(dir3));
    
    
% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
%YHome
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ModelName = 'spm_pacer';
  QZ = get(handles.edit1,'value');
  Qz = get(handles.edit6,'value');
  QY = 0;
    set(handles.edit2,'string',num2str(QY));
    set(handles.slider2,'value',QY);
    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
    [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
   set_param([ModelName '/SU1'],'Gain',num2str(0))
    set_param([ModelName '/SU2'],'Gain',num2str(0))
    set_param([ModelName '/SU3'],'Gain',num2str(0))
    
    set_param([ModelName '/SW1'],'Gain',num2str(0))
    set_param([ModelName '/SW2'],'Gain',num2str(0))
    set_param([ModelName '/SW3'],'Gain',num2str(0))

        set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
        set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
        set_param([ModelName '/Srz'],'Gain',num2str(Qz))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
   
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
ModelName = 'spm_pacer';
QZ = get(handles.slider1,'value');
    set(handles.edit1,'string',num2str(QZ));
    
    QY = get(handles.slider2,'value');
    set(handles.edit2,'string',num2str(QY));
    Qz = get(handles.slider7,'value');
    set(handles.edit6,'string',num2str(Qz));
    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
   [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,detJq,detJx] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
%     if (QZ==0)&&(QY==0)
%         du1 = 0;
%         du2 = 0;
%         du3 = 0;
%         else
%         du1 = au1;
%         du2 = au2;
%         du3 = au3;
%         dw1 = aw1;
%       
%         dw2 = aw2;
%         dw3 = aw3;
%         if (dw1>-10)&&(dw1<10)
%         dir1 =-1;
%         
%         end
%         AU= [au1,au2,au3];
%         AW = [aw1,aw2,aw3];
%         AQ =Q;
%        end
%      [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q,Dcheck] = pacer_ik(QZ,QY,Qz,dir1,dir2,dir3,du1,du2,du3);
    set(handles.edit7,'string',num2str(au1));
    set(handles.edit8,'string',num2str(au2));
    set(handles.edit9,'string',num2str(au3));
    set(handles.edit10,'string',num2str(aw1));
    set(handles.edit11,'string',num2str(aw2));
    set(handles.edit12,'string',num2str(aw3));
    if (abs(detJq)<0.002)||(abs(detJx)<0.002)
        set(handles.checkbox1,'value',1);
        set(handles.checkbox1,'BackgroundColor',[1 0 0]);
    else 
        set(handles.checkbox1,'value',0);
        set(handles.checkbox1,'BackgroundColor',[0 1 0]);
    end
    set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
    
    set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
     set_param([ModelName '/Srz'],'Gain',num2str(Qz))
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))

% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ModelName = 'spm_pacer';
  QZ = get(handles.edit1,'value');
  Qz = 0;
    set(handles.edit6,'string',num2str(Qz));
    set(handles.slider7,'value',Qz);
  QY = get(handles.edit2,'value');

    dir1 =  get(handles.slider4,'value');
    dir2 =  get(handles.slider5,'value');
    dir3 =  get(handles.slider6,'value');
    [au1,au2,au3,aw1,aw2,aw3,U1,U2,U3,W1,W2,W3,V1,V2,V3,vr1,vr2,vr3,Q] = pacer_tri_ik(QZ,QY,Qz,dir1,dir2,dir3);
    
    
    set_param([ModelName '/SU1'],'Gain',num2str(0))
    set_param([ModelName '/SU2'],'Gain',num2str(0))
    set_param([ModelName '/SU3'],'Gain',num2str(0))
    
    set_param([ModelName '/SW1'],'Gain',num2str(0))
    set_param([ModelName '/SW2'],'Gain',num2str(0))
    set_param([ModelName '/SW3'],'Gain',num2str(0))

        set_param([ModelName '/TQ'],'RotationMatrix',mat2str(Q))
    set_param([ModelName '/TU1'],'RotationMatrix',mat2str(U1))
    set_param([ModelName '/TU2'],'RotationMatrix',mat2str(U2))
    set_param([ModelName '/TU3'],'RotationMatrix',mat2str(U3))

    set_param([ModelName '/TW1'],'RotationMatrix',mat2str(W1))
    set_param([ModelName '/TW2'],'RotationMatrix',mat2str(W2))
    set_param([ModelName '/TW3'],'RotationMatrix',mat2str(W3))

    set_param([ModelName '/TV1'],'RotationMatrix',mat2str(V1))
    set_param([ModelName '/TV2'],'RotationMatrix',mat2str(V2))
    set_param([ModelName '/TV3'],'RotationMatrix',mat2str(V3))
    
    set_param([ModelName '/Tvr1'],'RotationMatrix',mat2str(vr1))
    set_param([ModelName '/Tvr2'],'RotationMatrix',mat2str(vr2))
    set_param([ModelName '/Tvr3'],'RotationMatrix',mat2str(vr3))
        set_param([ModelName '/SrZ'],'Gain',num2str(QZ))
        set_param([ModelName '/Srz'],'Gain',num2str(Qz))
     set_param([ModelName '/Sry'],'Gain',num2str(QY))
   
    set_param([ModelName '/SU1'],'Gain',num2str(au1))
    set_param([ModelName '/SU2'],'Gain',num2str(au2))
    set_param([ModelName '/SU3'],'Gain',num2str(au3))
    
    set_param([ModelName '/SW1'],'Gain',num2str(aw1))
    set_param([ModelName '/SW2'],'Gain',num2str(aw2))
    set_param([ModelName '/SW3'],'Gain',num2str(aw3))

    
% --- Executes on button press in pushbutton12.



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double


% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit10_Callback(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit10 as text
%        str2double(get(hObject,'String')) returns contents of edit10 as a double


% --- Executes during object creation, after setting all properties.
function edit10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit11_Callback(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit11 as text
%        str2double(get(hObject,'String')) returns contents of edit11 as a double


% --- Executes during object creation, after setting all properties.
function edit11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
