function varargout = GUI_GBST_analys(varargin)
% GUI_GBST_ANALYS M-file for GUI_GBST_analys.fig
%      GUI_GBST_ANALYS, by itself, creates a new GUI_GBST_ANALYS or raises the existing
%      singleton*.
%
%      H = GUI_GBST_ANALYS returns the handle to a new GUI_GBST_ANALYS or the handle to
%      the existing singleton*.
%
%      GUI_GBST_ANALYS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GBST_ANALYS.M with the given input arguments.
%
%      GUI_GBST_ANALYS('Property','Value',...) creates a new GUI_GBST_ANALYS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_GBST_analys_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_GBST_analys_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_GBST_analys

% Last Modified by GUIDE v2.5 15-Jul-2009 10:38:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_GBST_analys_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_GBST_analys_OutputFcn, ...
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


% --- Executes just before GUI_GBST_analys is made visible.
function GUI_GBST_analys_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_GBST_analys (see VARARGIN)

% Choose default command line output for GUI_GBST_analys
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_GBST_analys wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_GBST_analys_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% Input

function ExpDate_edit_Callback(hObject, eventdata, handles)
function ExpDate_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function GBST_radiobutton_Callback(hObject, eventdata, handles)



function File_edit_Callback(hObject, eventdata, handles)
function File_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Unitn_edit_Callback(hObject, eventdata, handles)
function Unitn_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pretestpulse_edit_Callback(hObject, eventdata, handles)
function pretestpulse_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function testpulsedur_edit_Callback(hObject, eventdata, handles)
function testpulsedur_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function posttestpulse_edit_Callback(hObject, eventdata, handles)
function posttestpulse_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function poststim1_edit_Callback(hObject, eventdata, handles)
function poststim1_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function poststim2_edit_Callback(hObject, eventdata, handles)
function poststim2_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function atd_edit_Callback(hObject, eventdata, handles)
function atd_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ard_edit_Callback(hObject, eventdata, handles)
function ard_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% 
function plotdataselect_checkbox_Callback(hObject, eventdata, handles)
function savedataselect_checkbox_Callback(hObject, eventdata, handles)



function selectdata_pushbutton_Callback(hObject, eventdata, handles)

%%%%%% input %%%%%%%%%%
%ExpDate='20080812'
hExpDate_edit=getfield(handles, 'ExpDate_edit');
ExpDate = get(hExpDate_edit,'string');

PPR_check = getfield(handles, 'PPR_check');
PPR_check = get(PPR_check, 'value');

peak_1_threshold = getfield(handles, 'peak_1_threshold_edit');
peak_1_threshold = str2double(get(peak_1_threshold, 'string')) * 1e-12;  % en pA

peak_2_threshold = getfield(handles, 'peak_2_threshold_edit');
peak_2_threshold = str2double(get(peak_2_threshold, 'string')) * 1e-12;   % en pA

%file='GBST_1_17_30'
hGBST_radiobutton=getfield(handles, 'GBST_radiobutton');
if get(hGBST_radiobutton, 'value')==1;
FileType='GBST';
end
hFile_edit=getfield(handles, 'File_edit');
File = get(hFile_edit,'string');
x{1}=[];
x{1}=[FileType,'_',File];
file=x{1}

%Unit='U01'
hUnitn_edit= getfield(handles, 'Unitn_edit');
Unitn = get(hUnitn_edit, 'string');
x{1}=[];
x{1}=['U',Unitn];
Unitn=x{1}

hsavedataselect_checkbox=getfield(handles, 'savedataselect_checkbox');
val_SaveDataSelect= get(hsavedataselect_checkbox, 'value');

hplotdataselect_checkbox=getfield(handles, 'plotdataselect_checkbox');
val_PlotDataSelect= get(hplotdataselect_checkbox, 'value');

val_PlotDataSelect

% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
SamplingRate = str2double(get(hSamplingRate_edit,'string'));

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
a = str2double(get(hpretestpulse_edit,'string'));

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
b = str2double(get(htestpulsedur_edit,'string'));

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
c = str2double(get(hposttestpulse_edit,'string'));

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
d = str2double(get(hpoststim1_edit,'string'));

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
e = str2double(get(hpoststim2_edit,'string'));

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
atd = str2double(get(hatd_edit,'string'));

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
ard = str2double(get(hard_edit,'string'));

x{1}=['Exp',ExpDate,Unitn];
ExpDate=x{1};
%%%%%%%%%%%%%%%%%%%%
GabaStim4B(ExpDate, file, Unitn, SamplingRate, a, b, c, d, e, atd, ard, val_SaveDataSelect, val_PlotDataSelect, PPR_check, peak_1_threshold, peak_2_threshold)


function AnalyseGBSTDataList_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to AnalyseGBSTDataList_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

hsavedataselect_checkbox=getfield(handles, 'savedataselect_checkbox');
val_SaveDataSelect= get(hsavedataselect_checkbox, 'value');

hplotdataselect_checkbox=getfield(handles, 'plotdataselect_checkbox');
val_PlotDataSelect= get(hplotdataselect_checkbox, 'value');

PPR_check = getfield(handles, 'PPR_check');
PPR_check = get(PPR_check, 'value');

peak_1_threshold = getfield(handles, 'peak_1_threshold_edit');
peak_1_threshold = str2double(get(peak_1_threshold, 'string')) * 1e-12;

peak_2_threshold = getfield(handles, 'peak_2_threshold_edit');
peak_2_threshold = str2double(get(peak_2_threshold, 'string')) * 1e-12;

%%
hTimingType_popupmenu = getfield(handles, 'TimingType_popupmenu');
val = get(hTimingType_popupmenu,'value');

if val==1 ; % manual

% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
SamplingRate = str2double(get(hSamplingRate_edit,'string'));

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
a = str2double(get(hpretestpulse_edit,'string'));

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
b = str2double(get(htestpulsedur_edit,'string'));

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
c = str2double(get(hposttestpulse_edit,'string'));

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
d = str2double(get(hpoststim1_edit,'string'));

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
e = str2double(get(hpoststim2_edit,'string'));

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
atd = str2double(get(hatd_edit,'string'));

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
ard = str2double(get(hard_edit,'string'));



elseif val==2 ; % old Pulse fit
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',15000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',5000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',130000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',120000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',0);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    
elseif val==3 ; % PatchMaster 1
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',20000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',10000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',50);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    

elseif val==4 ; %Elphy Antoine 1
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',20);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',10000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',40000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',0);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);

elseif val==6 ; %PatchMaster 2
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',20000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',30000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',50);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    
end


%% 

load('Files_list')
[m,n]=size(Feuil1);
%%
for i=1:m
ExpDate=Feuil1{i,1};
Filen=Feuil1{i,3};
FileType=Feuil1{i,4};
Unitn= Feuil1{i,2};
TimingType= Feuil1{i,10};

x{1}=[Feuil1{i,4},'_',Feuil1{i,3}];
file=x{1}

x{1}=[ExpDate,Unitn];
ExpDate=x{1};

if val==5 ; % auto list
TimingType= Feuil1{i,10}
    if TimingType=='PatchMaster1'
    a=20000;
    b=10000;
    c=100000;
    d=150000;
    e=150000;
    atd=50;
    ard=1400;
    SamplingRate=50;
    elseif TimingType=='old PulseFit'
    a=15000;
    b=5000;
    c=130000;
    d=150000;
    e=120000;
    atd=0;
    ard=1400;
    SamplingRate=50;
    elseif TimingType=='ElphyAntoin1'
    a=10000;
    b=40000;
    c=100000;
    d=150000;
    e=150000;
    atd=0;
    ard=1400;
    SamplingRate=20;
    elseif TimingType=='PatchMaster2'
    a=20000;
    b=30000;
    c=100000;
    d=150000;
    e=150000;
    atd=50;
    ard=1400;
    SamplingRate=50;
    end
end
 

GabaStim4B(ExpDate, file, Unitn, SamplingRate, a, b, c, d, e, atd, ard, val_SaveDataSelect, val_PlotDataSelect, PPR_check,peak_1_threshold, peak_2_threshold)

end

%%%%%%%%%%%%%%%%%%%%




% 
% 
% 
% %display('saving...')
% workspacetitle{1}= ['RawDataTable_it', expt]
% 
% save (workspacetitle{1}, 'rawdatatablei','rawdatatablet','expt', 'sweepnumber')
% 
% %display('saving...')
% ExpUnit{1}= [ExpDate, Unitn]
% load (ExpUnit{1})
% 
% ExpUnitName.(ExpUnit{1}).data.(file).RawDataTable= {rawdatatablei rawdatatablet expt sweepnumber};
% 
% save (ExpUnit{1}, 'ExpUnitName')



display('done')
beep



function SamplingRate_edit_Callback(hObject, eventdata, handles)

function SamplingRate_edit_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit12_Callback(hObject, eventdata, handles)




function edit12_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TimingType_popupmenu_Callback(hObject, eventdata, handles)


function TimingType_popupmenu_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SetTimePoints_pushbutton_Callback(hObject, eventdata, handles)

hTimingType_popupmenu = getfield(handles, 'TimingType_popupmenu');
val = get(hTimingType_popupmenu,'value');

if val==1 ; % manual

elseif val==2 ; % old Pulse fit
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',15000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',5000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',130000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',120000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',0);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    
elseif val==3 ; % PatchMaster 1
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',20000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',10000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',50);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    

elseif val==4 ; %Elphy Antoine 1
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',20);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',10000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',40000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',0);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);


elseif val==6 ; % PatchMaster 2
% SamplingRate = 50 %50us
hSamplingRate_edit=getfield(handles, 'SamplingRate_edit');
set (hSamplingRate_edit, 'string',50);

%a= 20000 % pre test pulse (ex:20ms)
hpretestpulse_edit=getfield(handles, 'pretestpulse_edit');
set (hpretestpulse_edit, 'string',20000);

%b= 10000 % test pulse duration (ex:10ms)
htestpulsedur_edit=getfield(handles, 'testpulsedur_edit');
set (htestpulsedur_edit, 'string',30000);

%c= 100000 % post test pulse(ex:100ms)
hposttestpulse_edit=getfield(handles, 'posttestpulse_edit');
set (hposttestpulse_edit, 'string',100000);

%d= 150000 % post stim1 (ex:150ms)
hpoststim1_edit=getfield(handles, 'poststim1_edit');
set (hpoststim1_edit, 'string',150000);

% e= 150000 % post stim2 (ex:150ms)
hpoststim2_edit=getfield(handles, 'poststim2_edit');
set (hpoststim2_edit, 'string',150000);

% atd= 50 %artefact theoretical duration (ex:0.05 ms)
hatd_edit=getfield(handles, 'atd_edit');
set (hatd_edit, 'string',50);

% ard= 1400 %artefact real duration 500us to adjust acordingly
hard_edit=getfield(handles, 'ard_edit');
set (hard_edit, 'string',1400);
    
end


% --- Executes on button press in GBST_unit_means_Pushbutton.
function GBST_unit_means_Pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to GBST_unit_means_Pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GBST_unit_means


% --- Executes on button press in PPR_check.
function PPR_check_Callback(hObject, eventdata, handles)
% hObject    handle to PPR_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PPR_check



function peak_1_threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to peak_1_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peak_1_threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of peak_1_threshold_edit as a double


% --- Executes during object creation, after setting all properties.
function peak_1_threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peak_1_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function peak_2_threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to peak_2_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of peak_2_threshold_edit as text
%        str2double(get(hObject,'String')) returns contents of peak_2_threshold_edit as a double


% --- Executes during object creation, after setting all properties.
function peak_2_threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peak_2_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
