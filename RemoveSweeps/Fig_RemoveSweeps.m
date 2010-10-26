function varargout = Fig_RemoveSweeps(varargin)
% FIG_REMOVESWEEPS M-file for Fig_RemoveSweeps.fig
%      FIG_REMOVESWEEPS, by itself, creates a new FIG_REMOVESWEEPS or raises the existing
%      singleton*.
%
%      H = FIG_REMOVESWEEPS returns the handle to a new FIG_REMOVESWEEPS or the handle to
%      the existing singleton*.
%
%      FIG_REMOVESWEEPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG_REMOVESWEEPS.M with the given input arguments.
%
%      FIG_REMOVESWEEPS('Property','Value',...) creates a new FIG_REMOVESWEEPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fig_RemoveSweeps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fig_RemoveSweeps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fig_RemoveSweeps

% Last Modified by GUIDE v2.5 14-Apr-2010 22:37:37

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fig_RemoveSweeps_OpeningFcn, ...
                   'gui_OutputFcn',  @Fig_RemoveSweeps_OutputFcn, ...
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


% --- Executes just before Fig_RemoveSweeps is made visible.
function Fig_RemoveSweeps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fig_RemoveSweeps (see VARARGIN)

% Choose default command line output for Fig_RemoveSweeps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fig_RemoveSweeps wait for user response (see UIRESUME)
% uiwait(handles.figure1);

% Default path
[p1,p2] = matlabPathDependingOnComputer();
temp = getfield(handles, 'save_path_edit') ;
set(temp, 'string', strcat( p1, 'Matlab2008directory/')  ) ;
temp = getfield(handles, 'file_list_path_edit') ;
set(temp, 'string', strcat( p2, 'file_list1.txt') );
temp = getfield(handles, 'path_raw_data_edit') ;
set(temp, 'string', strcat( p1, 'Data_Electrophy/ASCII_ChR2_Evoked_GABA/')  ) ;
temp = getfield(handles, 'single_file_name_edit');
set(temp, 'string', strcat( p1, 'Data_Electrophy/ASCII_ChR2_Evoked_GABA/20090708/20090708_2_11_28_ChR2_GB.asc' ) );


% --- Outputs from this function are returned to the command line.
function varargout = Fig_RemoveSweeps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OK_pushbutton.
function OK_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to OK_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

display('begin data processing...') ;
% ######################################################## Setting path ###

temp = handles.path_raw_data_edit;
data_path = get(temp, 'string') ;

temp = handles.save_path_edit;
save_path = get(temp, 'string') ;

temp = handles.save_name_edit;
save_name = get(temp, 'string') ;
    
temp = handles.file_list_path_edit ;
file_list_path = get(temp, 'string') ;
    
temp = handles.single_file_name_edit ;
file_name = get(temp, 'string') ;
% #################################################### END Setting path ###



% ###################################################### Configurations ###
temp =  getfield(handles, 'sampling_rate_edit') ;
sampling_rate = str2double(get(temp, 'string')) ;

temp =  getfield(handles, 'stim_nb_edit') ;
nbStims = str2double(get(temp, 'string')) ;

temp =  getfield(handles, 'bss_time_edit') ;
bss_time = str2double(get(temp, 'string')) ;
temp =  getfield(handles, 'bss_rise_edit') ;
bss_rise = str2double(get(temp, 'string')) ;
begin_spike_smooth = [bss_time, bss_rise] ;


temp =  getfield(handles, 'stim_begin_edit') ;
stimBegin = get(temp, 'string') ;
stimBegin = regexp(stimBegin, '\_', 'split') ;

temp =  getfield(handles, 'stim_dur_edit') ;
stimDur = get(temp, 'string') ;

temp =  getfield(handles, 'stim_excl_edit') ;
stimExcl = get(temp, 'string') ;

stim = zeros(nbStims,3) ;
for i=1:nbStims
    stim(i,1) = str2double( stimBegin{i} ) ;
	stim(i,2) = str2double( stimDur ) ;
	stim(i,3) = str2double( stimExcl ) ;
end

smoothing_time = zeros(1,2) ;

temp =  getfield(handles, 'smoothing_time_1_edit') ;
smoothing_time(1,1) = str2double(get(temp, 'string')) ;

temp =  getfield(handles, 'smoothing_time_2_edit') ;
smoothing_time(1,2) = str2double(get(temp, 'string')) ;

%%%%%%%%%%% EXCLUSION CRITERIONS %%%%%%%%%%
peakThresholds = zeros(1,3);
parfor i=1:3
    temp = getfield(handles, strcat('thres', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        temp = getfield(handles, strcat('thres', int2str(i), '_value') ) ;
        peakThresholds(i) = str2double(get(temp, 'string'));
    end
end

doBLExcl = 0;
baseLineExcls = zeros(1,3);
for i=1:3
    temp = getfield(handles, strcat('blexcl', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        doBLExcl = 1;        % At least one stim with base line exclusion
        temp = getfield(handles, strcat('blexcl', int2str(i), '_value') ) ;
        baseLineExcls(i) = str2double(get(temp, 'string'));
    end
end

doTTPExcl = 0;
timeToPeakExcls = zeros(3,2);
for i=1:3
    temp = getfield(handles, strcat('ttpexcl', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        doTTPExcl = 1;        % At least one stim with time-to-peak exclusion
        temp = getfield(handles, strcat('ttpexcl', int2str(i), '_value') ) ;
        temp = get(temp, 'string') ;
        temp = regexp(temp, '\_', 'split');
        timeToPeakExcls(i, 1) = str2double( temp{1} );
        timeToPeakExcls(i, 2) = str2double( temp{2} );
        if timeToPeakExcls(i, 1) > timeToPeakExcls(i, 2)
            display( 'TTP interval : beginning must be before end.' );
            temp = timeToPeakExcls(i, 2);
            timeToPeakExcls(i, 2) = timeToPeakExcls(i, 1);
            timeToPeakExcls(i, 1) = temp;
        end
    end
end

% Specifies if a sweep is valid if :
% - all stims are valid (1)
% or 
% - at least one stim is valid (0)
temp = handles.foreachstim_criterions;
allStimsMustPass = get(temp, 'value');

toDo = zeros(1,8) ;
toDo(2) = doBLExcl;
toDo(3) = doTTPExcl;
temp = handles.plot_selectdata_check ;
toDo(4) = get(temp, 'value') ;
temp = handles.plot_fail_check;
toDo(5) = get(temp, 'value') ;
temp = handles.plot_max_check;
toDo(6) = get(temp, 'value') ;
temp = handles.save_check;
toDo(8) = get(temp, 'value') ;
%%%%%%%%%%%%%  END EXC. CR.  %%%%%%%%%%%%%%



temp = getfield(handles, 'list_files_check') ;
list_files_check = get(temp, 'value') ;

temp = getfield(handles, 'single_file_check') ;
single_file_check = get(temp, 'value') ;

default_config = {sampling_rate, nbStims, begin_spike_smooth, stim, baseLineExcls, timeToPeakExcls, smoothing_time} ;

% ################################################## END Configurations ###



% ############################################### reading the file list ### 
% ex : 20090210_3_07_29_ChR2_GB
if list_files_check == 1
    if exist( file_list_path, 'file' ) && ~exist( file_list_path, 'dir' )
        fid = fopen(file_list_path);
        file_list = textscan(fid, '%s %s %s %s %s %s %s') ;
        fclose(fid);
    else
        display( sprintf('Error : the file "%s" couldn''t be found', file_list_path) );
        return;
    end  
elseif single_file_check == 1
    % All this is done to use single files and list of files the same way :
    % we create a phony list of only one file, and set the right data_path
    [data_path, file_name, ext, versn] = fileparts(file_name);
    [data_path, tmp, ext, versn] = fileparts(data_path); % remove the last part of the folder (which is 'expdate' and will be added below
    data_path = strcat( data_path, filesep() );
    file_list = regexp(file_name, '\_', 'split') ;
    file_list = {{file_list{1}}, {file_list{2}}, {file_list{3}}, {file_list{4}}, {file_list{5}},  {file_list{6}}};    
end
% ########################################### END reading the file list ###




% ############################################### Analysis of the files ###
expdate_cells = file_list{1} ;      % class = cell
inf1_cells = file_list{2} ;         % class = cell
inf2_cells = file_list{3} ;         % class = cell
inf3_cells = file_list{4} ;         % class = cell
type1_cells = file_list{5} ;        % class = cell
type2_cells = file_list{6} ;        % class = cell
        
nb_files = size(expdate_cells,1) ;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all files of the file list do exist ; otherwise, print an error
% and return. Use the function from checkifFilesExistInDirectory.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

files = cell(nb_files,1);
for i = 1:nb_files
    path = strcat( data_path, expdate_cells{i}, filesep() );
    strfilename = strcat( expdate_cells{i}, '_', inf1_cells{i}, '_', inf2_cells{i}, '_', inf3_cells{i}, '_', type1_cells{i}, '_',type2_cells{i} );
    strfilename = strcat(path, strfilename, '.asc');
    files{i,:} = cellstr( strfilename );
end
if list_files_check == 1
    display( sprintf( 'Checking that all files from "%s" exist ...', file_list_path ) ) ;
else
    display( sprintf( 'Checking that the data file "%s" exists ...', char(files{1}) ) ) ;
end
[allOK, missingIndex] = checkifFilesExistInDirectory( files );
if allOK == 0
    display( sprintf('Error : missing data file "%s"', char(files{missingIndex})) );
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% searching maximum number of stimulations
max_nbStims = nbStims ;
if single_file_check == 0
    
    % checking the NbStim parameter for all the files
    for ID=1:nb_files
        if strcmp('',file_list{7}{ID}) == 0
            options = regexp(file_list{7}{ID},'\/','split') ;
    
            for i=1:size(options,2)           
                str = options{i} ;
                if size(regexp(str,'NbStim=','end')) ~= 0
                    index = regexp(str,'NbStim=','end') ;
                    max_nbStims = max(str2double(str(index(1)+1:size(str,2))),max_nbStims) ;
                end
            end
        end       
    end
end


% setting the array for saving the data
if toDo(8) == 1
    
    data_to_save = cell(2, 2*max_nbStims+7) ;
    data_to_save{1,1} = 'File name' ;
    data_to_save{1,2} = 'Sweep nb' ;
    data_to_save{1,3} = 'criterions_selected_product' ;

    for k=1:max_nbStims
    % de 2...(pr max_nbStims=3)   
        data_to_save{1,2*k+2} = strcat('Stim#',int2str(k),'_crit1_prestim_spont') ;
        data_to_save{1,2*k+3} = strcat('Stim#',int2str(k),'_crit2_evoked_events') ;
        data_to_save{1,2*max_nbStims+4+k} = strcat('Stim#',int2str(k),'_threshold') ;
    end
    data_to_save{1,2*max_nbStims+4} = strcat('peak_detection') ;
else
    data_to_save = {} ;
end
  

% settings & analysis

% Saving default parameters (each loop incrementation, restore them)
stimBegin_default = stimBegin ;
stimDur_default = stimDur ;
stimExcl_default = stimExcl ;
for ID=1:nb_files
    if single_file_check == 0    
        % re-setting default parameters
        sampling_rate = default_config{1,1} ;
        nbStims = default_config{1,2};
        begin_spike_smooth = default_config{1,3} ;
        stim = default_config{1,4} ;
        baseLineExcls = default_config{1,5} ;
        timeToPeakExcls = default_config{1,6} ;
        smoothing_time = default_config{1,7} ;
        stimBegin = stimBegin_default ;
        stimDur = stimDur_default ;
        stimExcl = stimExcl_default ;
        
        % taking modified parameters if specified
        
        if strcmp('',file_list{7}{ID}) == 0
            options = regexp(file_list{7}{ID},'\/','split') ;
            
            for i=1:size(options,2)
                str = options{i} ;
                if size(regexp(str,'NbStim=','end')) ~= 0
                    index = regexp(str,'NbStim=','end') ;
                    nbStims = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'StimBegin=','end')) ~= 0
                    index = regexp(str,'StimBegin=','end') ;
                    stimBegin = regexp(str(index(1)+1:size(str,2)), '\_', 'split') ;
                elseif size(regexp(str,'StimDur=','end')) ~= 0
                    index = regexp(str,'StimDur=','end') ;
                    stimDur = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'StimExcl=','end')) ~= 0
                    index = regexp(str,'StimExcl=','end') ;
                    stimExcl = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'ExclCritStd=','end')) ~= 0
                    index = regexp(str,'ExclCritStd=','end') ;
                    timeToPeakExcls(:) = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'ExclCritBl=','end')) ~= 0
                    index = regexp(str,'ExclCritBl=','end') ;
                    baseLineExcls = regexp(str(index(1)+1:size(str,2)), '\_', 'split') ; %% NOT TESTED
                elseif size(regexp(str,'SamplingRate=','end')) ~= 0
                    index = regexp(str,'SamplingRate=','end') ;
                    sampling_rate = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'SmoothingTime1=','end')) ~= 0
                    index = regexp(str,'SmoothingTime1=','end') ;
                    smoothing_time(1,1) = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'SmoothingTime2=','end')) ~= 0
                    index = regexp(str,'SmoothingTime2=','end') ;
                    smoothing_time(1,2) = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'BSSTime=','end')) ~= 0
                    index = regexp(str,'BSSTime=','end') ;
                    bss_time = str2double(str(index(1)+1:size(str,2))) ;
                elseif size(regexp(str,'BSSRise=','end')) ~= 0
                    index = regexp(str,'BSSRise=','end') ;
                    bss_rise = str2double(str(index(1)+1:size(str,2))) ;
                end
            end

            if nbStims < size(stim,1)
                stim = zeros(nbStims,3);
            end

            for i=1:nbStims
                stim(i,1) = str2double(stimBegin{i}) ;
                stim(i,2) = str2double(stimDur);
                stim(i,3) = str2double(stimExcl);
            end
            
            begin_spike_smooth = [bss_time, bss_rise] ;
            
        end
    end
    
    expdate = expdate_cells{ID} ;
    
    % Reconstructing the full path
    file_ID = strcat(expdate_cells{ID},'_',inf1_cells{ID},'_',inf2_cells{ID},'_',inf3_cells{ID},'_',type1_cells{ID},'_',type2_cells{ID}) ;
    file_name = strcat(file_ID, '.asc') ;
    
    nbSweeps = str2double( inf3_cells{ID} ) ;
    
    display(strcat('loading ''',file_name,'''...')) ;
    
    path = strcat(data_path, expdate,'/', file_name) ;
    raw_data = load(path) ;
    
    display('data loaded') ;
    
    data_to_save = Code_Selection2(file_name, ID, nbSweeps, sampling_rate, nbStims, stim, begin_spike_smooth, peakThresholds, timeToPeakExcls, baseLineExcls, allStimsMustPass, raw_data, smoothing_time, toDo, data_to_save ) ;
    
end

% Put result into the workspace
display('registering result in the workspace ...') ;
to_save = genvarname(save_name, who) ;
assignin( 'base', to_save, data_to_save );

% And save it, if it was asked
if toDo(8) == 1
    display('saving...') ;

    eval([to_save ' = data_to_save;']);
    
    save_path = strcat(save_path, save_name) ;
    save(save_path, save_name);
end
display('Done.') ;
% ########################################### END Analysis of the files ###



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
