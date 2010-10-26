function varargout = test_pulse(varargin)
% TEST_PULSE M-file for test_pulse.fig
%      TEST_PULSE, by itself, creates a new TEST_PULSE or raises the existing
%      singleton*.
%
%      H = TEST_PULSE returns the handle to a new TEST_PULSE or the handle to
%      the existing singleton*.
%
%      TEST_PULSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TEST_PULSE.M with the given input arguments.
%
%      TEST_PULSE('Property','Value',...) creates a new TEST_PULSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before test_pulse_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to test_pulse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help test_pulse

% Last Modified by GUIDE v2.5 14-Apr-2010 23:45:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @test_pulse_OpeningFcn, ...
                   'gui_OutputFcn',  @test_pulse_OutputFcn, ...
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


% --- Executes just before test_pulse is made visible.
function test_pulse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to test_pulse (see VARARGIN)

% Choose default command line output for test_pulse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes test_pulse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = test_pulse_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function save_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to save_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_path_edit as text
%        str2double(get(hObject,'String')) returns contents of save_path_edit as a double


% --- Executes during object creation, after setting all properties.
function save_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_name_edit as text
%        str2double(get(hObject,'String')) returns contents of file_name_edit as a double


% --- Executes during object creation, after setting all properties.
function file_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function path_raw_data_edit_Callback(hObject, eventdata, handles)
% hObject    handle to path_raw_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of path_raw_data_edit as text
%        str2double(get(hObject,'String')) returns contents of path_raw_data_edit as a double


% --- Executes during object creation, after setting all properties.
function path_raw_data_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to path_raw_data_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_list_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_list_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_list_name_edit as text
%        str2double(get(hObject,'String')) returns contents of file_list_name_edit as a double


% --- Executes during object creation, after setting all properties.
function file_list_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_list_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function file_list_path_edit_Callback(hObject, eventdata, handles)
% hObject    handle to file_list_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of file_list_path_edit as text
%        str2double(get(hObject,'String')) returns contents of file_list_path_edit as a double


% --- Executes during object creation, after setting all properties.
function file_list_path_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_list_path_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function single_file_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to single_file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of single_file_name_edit as text
%        str2double(get(hObject,'String')) returns contents of single_file_name_edit as a double


% --- Executes during object creation, after setting all properties.
function single_file_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to single_file_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nb_char_group_edit_Callback(hObject, eventdata, handles)
% hObject    handle to nb_char_group_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nb_char_group_edit as text
%        str2double(get(hObject,'String')) returns contents of nb_char_group_edit as a double


% --- Executes during object creation, after setting all properties.
function nb_char_group_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nb_char_group_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fit_TP_check.
function fit_TP_check_Callback(hObject, eventdata, handles)
% hObject    handle to fit_TP_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of fit_TP_check


% --- Executes on button press in plot_check.
function plot_check_Callback(hObject, eventdata, handles)
% hObject    handle to plot_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_check


% --- Executes on button press in save_check.
function save_check_Callback(hObject, eventdata, handles)
% hObject    handle to save_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_check



function U_pulse_value_edit_Callback(hObject, eventdata, handles)
% hObject    handle to U_pulse_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of U_pulse_value_edit as text
%        str2double(get(hObject,'String')) returns contents of U_pulse_value_edit as a double


% --- Executes during object creation, after setting all properties.
function U_pulse_value_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to U_pulse_value_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sampling_rate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to sampling_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampling_rate_edit as text
%        str2double(get(hObject,'String')) returns contents of sampling_rate_edit as a double


% --- Executes during object creation, after setting all properties.
function sampling_rate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampling_rate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TP_1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TP_1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TP_1_edit as text
%        str2double(get(hObject,'String')) returns contents of TP_1_edit as a double


% --- Executes during object creation, after setting all properties.
function TP_1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TP_1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TP_2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TP_2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TP_2_edit as text
%        str2double(get(hObject,'String')) returns contents of TP_2_edit as a double


% --- Executes during object creation, after setting all properties.
function TP_2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TP_2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TP_3_edit_Callback(hObject, eventdata, handles)
% hObject    handle to TP_3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TP_3_edit as text
%        str2double(get(hObject,'String')) returns contents of TP_3_edit as a double


% --- Executes during object creation, after setting all properties.
function TP_3_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TP_3_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in set_config.
function set_config_Callback(hObject, eventdata, handles)
% hObject    handle to set_config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% ####################################### setting path  & global options###

save_path = getfield(handles, 'save_path_edit') ;
save_path = get(save_path, 'string') ;

save_file = getfield(handles, 'file_name_edit') ;
save_file = get(save_file, 'string') ;

file_list_path = getfield(handles, 'file_list_path_edit') ;
file_list_path = get(file_list_path, 'string') ;

data_path = getfield(handles, 'path_raw_data_edit') ;
data_path = get(data_path, 'string') ;


U_pulse_value = getfield(handles, 'U_pulse_value_edit') ;
U_pulse_value = str2double(get(U_pulse_value, 'string')) ;

sampling_rate =  getfield(handles, 'sampling_rate_edit') ;
sampling_rate = str2double(get(sampling_rate, 'string')) ;


list_files_check = getfield(handles, 'list_files_check') ;
list_files_check = get(list_files_check, 'value') ;

single_file_check = getfield(handles, 'single_file_check') ;
single_file_check = get(single_file_check, 'value') ;

temp = getfield(handles, 'nb_char_group_edit') ;
nb_char_group = str2double(get(temp, 'string')) ;
% ################################################# END path & options ####

temp = handles.sweep_range;
sweep_range = get(temp, 'string') ;

% ############################################################ settings ###
temp = getfield(handles, 'U_pulse_value_edit') ;
U_pulse_value = str2double(get(temp, 'string')) ;

temp = getfield(handles, 'sampling_rate_edit') ;
sampling_rate = str2double(get(temp, 'string')) ;


temp = getfield(handles, 'fit_TP_check') ;
fit_TP_check = get(temp, 'value') ;

temp = getfield(handles, 'plot_check') ;
plot_check = get(temp, 'value') ;

temp = getfield(handles, 'save_check') ;
save_check = get(temp, 'value') ;

to_do(1) = fit_TP_check ;   % do fit the test pulse
to_do(2) = plot_check ;     % do plot
to_do(3) = save_check ;     % do save


% TP_1 = pre-testpulse; TP_2 = Duration fit;  TP_3 = duration testpulse
temp = getfield(handles, 'TP_1_edit') ;
TP_1 = str2double(get(temp, 'string')) ;

temp = getfield(handles, 'TP_2_edit') ;
TP_2 = str2double(get(temp, 'string')) ;

TP_3 = TP_1 + 0.99*TP_2;

TP_2 = 0.8*TP_2 + TP_1;




time_points = [TP_1; TP_2; TP_3] ;

data_to_save = {'FileID','Capacitance_Meanfit[pF]','Rsquare_Meanfit','Rm (Mohm)', 'Ra (Mohm)'} ;

% Create a new handle for the figure
newHandleFigure = 0;
while ishghandle(newHandleFigure)
    newHandleFigure = newHandleFigure + 1;
end

% ######################################################## END settings ###
if list_files_check == 1

    % definie combien de colonnes seront lu en tant que caract�res
    str= '' ;
    
    
    for i=1:nb_char_group+4
        str = strcat('%s ',str) ;
    end
    
    
    path_file_list = file_list_path;

    fid = fopen(path_file_list) ;
    file_list = textscan(fid, str) ;
    fclose(fid);


    nb_fichiers = size(file_list{1},1) ;

   
    
    % read the text file raw and name the file and load it
    for ID=1:nb_fichiers
        file_ID = strcat(file_list{1}{ID},'_',file_list{2}{ID},'_',file_list{3}{ID},'_',file_list{4}{ID}) ;
        if nb_char_group > 4
            for i=5:nb_char_group
                file_ID = strcat(file_ID,'_',file_list{i}{ID}) ;
            end
        end
        
        file_name = strcat(file_ID, '.asc') ;
        expdate = file_list{1}{ID} ;
        nb_sweeps = str2num( file_list{4}{ID}) ;
        
        if abs(str2num(strcat(file_list{nb_char_group+1}{ID},'1234'))) == 1234  % abs() because the (nb_char_group+1)th character can be '-'
            U_pulse_value_list = U_pulse_value;
            sampling_rate_list = sampling_rate;
            time_points_list = time_points;
            
            
        else
            
            
            U_pulse_value_list= str2num( file_list{nb_char_group+1}{ID});
            
            sampling_rate_list= str2num( file_list{nb_char_group+2}{ID}) ;
            TP_1_list= str2num( file_list{nb_char_group+3}{ID});
            TP_2_list= str2num( file_list{nb_char_group+4}{ID}); %#ok<*ST2NM>
            TP_3_list = TP_1_list + 0.99*TP_2_list;
            TP_2_list = 0.8*TP_2_list + TP_1_list;
            time_points_list = [TP_1_list; TP_2_list; TP_3_list];
            
        end


        display(sprintf('loading %s ...',file_name )) ;

        path = strcat(data_path, expdate,filesep(), file_name) ;
        raw_data = load(path) ;

        display('data loaded');
        
        % The sweeps we don't want to be excluded from the analysis
        sweepsToKeep = 1:nb_sweeps; % here, all
        %%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%

        [data, sweepSize, nb_sweeps] = preteatRawData( raw_data, nb_sweeps, sweepsToKeep );

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        data_to_save = test_pulse_analysis(file_name, data, data_to_save, time_points_list,sampling_rate_list, U_pulse_value_list, nb_sweeps, to_do,ID, newHandleFigure) ;
        
    end



elseif single_file_check == 1
    
    temp = getfield(handles, 'single_file_name_edit') ;
    path = get(temp, 'string') ;
    
    [data_path, file_name, ext, versn] = fileparts(path);
    
    file_list = regexp(file_name, '\_', 'split') ;
    
    file_ID = strcat(file_list{1},'_',file_list{2},'_',file_list{3},'_',file_list{4}) ;
    if nb_char_group > 4
        for i=5:nb_char_group
                file_ID = strcat(file_ID,'_',file_list{i}) ;
        end
    end
    
    file_name = strcat(file_ID, '.asc'); 
    expdate = file_list{1} ;
    nb_sweeps = str2double( file_list{4}) ;

    display(strcat('loading.',file_name,'...')) ;
    
    display(path);
    raw_data = load(path) ;

    display('data loaded')
    ID = 1 ;
    
    % The sweeps we don't want to be excluded from the analysis
    sweepsToKeep = getSweepRange( sweep_range, nb_sweeps );
    
    %%%%%%%%%%%%%%%%%%%%% ASCII raw Data file to Data matrix %%%%%%%%%%%%%%%%%%

   [data, sweepSize, nb_sweeps] = preteatRawData( raw_data, nb_sweeps, sweepsToKeep );

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    data_to_save = test_pulse_analysis(file_name, data, data_to_save, time_points, sampling_rate, U_pulse_value, nb_sweeps, to_do,ID, newHandleFigure ) ;
end

to_save = genvarname(save_file, who) ;
if to_do(3) == 1
    display('saving...')
    eval([to_save ' = data_to_save;']);
   
    save_path = strcat(save_path, save_file) ;
    save(save_path, save_file) ;
    
end

% Put result into the workspace
display('registering result in the workspace ...') ;
assignin( 'base', to_save, data_to_save );

display('done') ;



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


% --- Executes on button press in browseFolderRawDataPath.
function browseFolderRawDataPath_Callback(hObject, eventdata, handles) %#ok<*INUSL,*DEFNU>
% Select the radio button 'file list'
set( handles.list_files_check, 'Value', 1.0 );
% Default value : previous value
temp = handles.path_raw_data_edit;
rawdata_path = get(temp, 'string') ;
directoryname = uigetdir( rawdata_path, 'Pick a Directory');
if directoryname ~= 0
    % Add the trailing "/" and set the new path in the input box
    directoryname = strcat( directoryname, filesep() );
    set( temp, 'string', directoryname );
end

% --- Executes on button press in browseFileListPath.
function browseFileListPath_Callback(hObject, eventdata, handles)
% Select the radio button 'file list'
set( handles.list_files_check, 'Value', 1.0 );
% Default value : previous value
temp = handles.file_list_path_edit;
filelist_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.txt','Select the index file',filelist_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end


% --- Executes on button press in browseDataFilePath.
function browseDataFilePath_Callback(hObject, eventdata, handles)
% Select the radio button 'file list'
set( handles.single_file_check, 'Value', 1.0 );
% Default value : previous value
temp = handles.single_file_name_edit;
filelist_path = get(temp, 'string') ;
[filename,directoryname] = uigetfile('*.asc','Select the index file', filelist_path) ;
if directoryname ~= 0
    % set the new path in the input box
    directoryname = strcat( directoryname, filename );
    set( temp, 'string', directoryname );
end



function sweep_range_Callback(hObject, eventdata, handles)
% hObject    handle to sweep_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Select the radio button 'file list'
set( handles.single_file_check, 'Value', 1.0 );


% --- Executes during object creation, after setting all properties.
function sweep_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sweep_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
