function varargout = KeepSelectedSweeps(varargin)
% KEEPSELECTEDSWEEPS M-file for KeepSelectedSweeps.fig
%      KEEPSELECTEDSWEEPS, by itself, creates a new KEEPSELECTEDSWEEPS or raises the existing
%      singleton*.
%
%      H = KEEPSELECTEDSWEEPS returns the handle to a new KEEPSELECTEDSWEEPS or the handle to
%      the existing singleton*.
%
%      KEEPSELECTEDSWEEPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KEEPSELECTEDSWEEPS.M with the given input arguments.
%
%      KEEPSELECTEDSWEEPS('Property','Value',...) creates a new KEEPSELECTEDSWEEPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before KeepSelectedSweeps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to KeepSelectedSweeps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help KeepSelectedSweeps

% Last Modified by GUIDE v2.5 16-Mar-2010 11:20:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @KeepSelectedSweeps_OpeningFcn, ...
                   'gui_OutputFcn',  @KeepSelectedSweeps_OutputFcn, ...
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


% --- Executes just before KeepSelectedSweeps is made visible.
function KeepSelectedSweeps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to KeepSelectedSweeps (see VARARGIN)

% Choose default command line output for KeepSelectedSweeps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes KeepSelectedSweeps wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = KeepSelectedSweeps_OutputFcn(hObject, eventdata, handles) 
% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in submit_button.
function submit_button_Callback(hObject, eventdata, handles)
display('begin final step of selection...') ;
% ######################################################## Setting path ###
temp = handles.processed_sweep_data_path ;
sweep_data_path = get(temp, 'string') ;

temp = handles.processed_sweep_selection_path ;
sweep_select_path = get(temp, 'string') ;

temp = handles.save_path_edit;
save_path = get(temp, 'string') ;

temp = handles.save_name_edit;
save_name = get(temp, 'string');
% #################################################### END Setting path ###

% Check that the .mat files do exist
if ~( exist( sweep_data_path, 'file' ) && ~exist( sweep_data_path, 'dir' ) )
    display( sprintf('Error : the file "%s" couldn''t be found', sweep_data_path) );
    return;
end
if ~( exist( sweep_select_path, 'file' ) && ~exist( sweep_select_path, 'dir' ) )
    display( sprintf('Error : the file "%s" couldn''t be found', sweep_select_path) );
    return;
end
sweepDataArray = (load( sweep_data_path ));
sweepSlctArray = (load( sweep_select_path ));
display('Files loaded ..');
% Retrieve the arrays of data, which are the first fields from the struct loaded
% by "load" : sweepDataArray.ChR_GB_save_test
temp = char(fieldnames( sweepDataArray(1,1) ));
sweepDataArray = getfield( sweepDataArray(1,1), temp );
temp = char(fieldnames( sweepSlctArray(1,1) ));
sweepSlctArray = getfield( sweepSlctArray(1,1), temp );

display('-- Applying the selection to the sweeps ..');
validSweeps = keepOnlySelectedSweeps( sweepSlctArray, sweepDataArray );
display(validSweeps);

save_full_path = strcat(save_path, filesep(), save_name);
display( sprintf('-- Saving the selection to "%s"', save_full_path) );
save( save_full_path, 'validSweeps' );

% --- Executes during object creation, after setting all properties.
function save_path_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function save_name_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseFolderSavePath.
function browseFolderSavePath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = handles.save_path_edit;
save_path = get(temp, 'string') ;
directoryname = uigetdir( save_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end


% --- Executes during object creation, after setting all properties.
function processed_sweep_data_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseFolderSweepDataPath.
function browseFolderSweepDataPath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = handles.processed_sweep_data_path;
file_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.mat','Select the selection file',file_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end


% --- Executes during object creation, after setting all properties.
function processed_sweep_selection_path_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browseFolderSweepFilterPath.
function browseFolderSweepFilterPath_Callback(hObject, eventdata, handles)
% Default value : previous value
temp = handles.processed_sweep_selection_path;
file_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.mat','Select the selection file',file_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end
