function varargout = Fig_Sweep_Selection(varargin)
% FIG_SWEEP_SELECTION M-file for Fig_Sweep_Selection.fig
%      FIG_SWEEP_SELECTION, by itself, creates a new FIG_SWEEP_SELECTION or raises the existing
%      singleton*.
%
%      H = FIG_SWEEP_SELECTION returns the handle to a new FIG_SWEEP_SELECTION or the handle to
%      the existing singleton*.
%
%      FIG_SWEEP_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIG_SWEEP_SELECTION.M with the given
%      input arguments.
%
%      FIG_SWEEP_SELECTION('Property','Value',...) creates a new FIG_SWEEP_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Fig_Sweep_Selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Fig_Sweep_Selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Fig_Sweep_Selection

% Last Modified by GUIDE v2.5 31-May-2010 11:56:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Fig_Sweep_Selection_OpeningFcn, ...
                   'gui_OutputFcn',  @Fig_Sweep_Selection_OutputFcn, ...
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


% --- Executes just before Fig_Sweep_Selection is made visible.
function Fig_Sweep_Selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Fig_Sweep_Selection (see VARARGIN)

% Choose default command line output for Fig_Sweep_Selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Fig_Sweep_Selection wait for user response (see UIRESUME)
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
% Display the threshold gradient for peak detection
displayThresholdGradient( handles );


% --- Outputs from this function are returned to the command line.
function varargout = Fig_Sweep_Selection_OutputFcn(hObject, eventdata, handles) 
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

temp = handles.save_path_edit;
save_path = get(temp, 'string') ;

temp = handles.save_name_edit;
save_name = get(temp, 'string') ;

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
peakThresholds = zeros(3,2);
for i=1:3
    temp = getfield(handles, strcat('thres', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        temp = getfield(handles, strcat('thres', int2str(i), '_value') ) ;
        peakThresholds(i,1) = str2double(get(temp, 'string'));
        temp = getfield(handles, strcat('thres', int2str(i), '_max_value') ) ;
        peakThresholds(i,2) = str2double(get(temp, 'string'));
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

doRiseTimeExcl = 0;
riseTimeExcls = zeros(3,2);
for i=1:3
    temp = getfield(handles, strcat('risetimeexcl', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        doRiseTimeExcl = 1;        % At least one stim with rise time exclusion
        temp = getfield(handles, strcat('risetimeexcl', int2str(i), '_value') ) ;
        temp = get(temp, 'string') ;
        temp = regexp(temp, '\_', 'split');
        riseTimeExcls(i, 1) = str2double( temp{1} );
        riseTimeExcls(i, 2) = str2double( temp{2} );
        if timeToPeakExcls(i, 1) > timeToPeakExcls(i, 2)
            display( 'Rise time interval : beginning must be before end.' );
            temp = riseTimeExcls(i, 2);
            riseTimeExcls(i, 2) = riseTimeExcls(i, 1);
            riseTimeExcls(i, 1) = temp;
        end
    end
end

doDecayTimeExcl = 0;
decayTimeExcls = zeros(3,2);
for i=1:3
    temp = getfield(handles, strcat('decaytimeexcl', int2str(i), '_enabled') ) ;
    if get(temp, 'value') == 1
        doDecayTimeExcl = 1;        % At least one stim with rise time exclusion
        temp = getfield(handles, strcat('decaytimeexcl', int2str(i), '_value') ) ;
        temp = get(temp, 'string') ;
        temp = regexp(temp, '\_', 'split');
        decayTimeExcls(i, 1) = str2double( temp{1} );
        decayTimeExcls(i, 2) = str2double( temp{2} );
        if timeToPeakExcls(i, 1) > timeToPeakExcls(i, 2)
            display( 'Decay time interval : beginning must be before end.' );
            temp = decayTimeExcls(i, 2);
            decayTimeExcls(i, 2) = decayTimeExcls(i, 1);
            decayTimeExcls(i, 1) = temp;
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
toDo(1) = doRiseTimeExcl;
toDo(2) = doBLExcl;
toDo(3) = doTTPExcl;
temp = handles.plot_selectdata_check ;
toDo(4) = get(temp, 'value') ;
temp = handles.plot_fail_check;
toDo(5) = get(temp, 'value') ;
temp = handles.plot_max_check;
toDo(6) = get(temp, 'value') ;
toDo(7) = doDecayTimeExcl;
temp = handles.save_check;
toDo(8) = get(temp, 'value') ;
%%%%%%%%%%%%%  END EXC. CR.  %%%%%%%%%%%%%%

temp = handles.sweep_range;
sweep_range = get(temp, 'string') ;

% Percentage windows for rise and decay time
riseAndDecayThresholds = zeros(4,1);
temp = handles.thres1_rise_time;
riseAndDecayThresholds(1) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres2_rise_time;
riseAndDecayThresholds(2) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres2_decay_time;   % the highest threshold (100% by default)
riseAndDecayThresholds(3) = str2double( get(temp, 'string') ) / 100.0;
temp = handles.thres1_decay_time;   % the lowest threshold (63% by default)
riseAndDecayThresholds(4) = str2double( get(temp, 'string') ) / 100.0;

temp = getfield(handles, 'list_files_check') ;
list_files_check = get(temp, 'value') ;

temp = getfield(handles, 'single_file_check') ;
single_file_check = get(temp, 'value') ;

default_config = {sampling_rate, nbStims, begin_spike_smooth, stim, baseLineExcls, timeToPeakExcls, smoothing_time} ;

% ################################################## END Configurations ###


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File lists or single file options %%%%%%%%%%
[nbFiles, fileNames, filePaths, fileOptions, fileSweepNumbers] = getFilenamesAndOptions( handles );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all files of the file list do exist ; otherwise, print an error
% and return. Use the function from checkifFilesExistInDirectory.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if list_files_check == 1
    file_list_path = get( handles.file_list_path_edit, 'string') ;
    display( sprintf( 'Checking that all files from "%s" exist ...', file_list_path ) ) ;
else
    display( sprintf( 'Checking that the data file "%s" exists ...', char(fileNames{1}) ) ) ;
end
[allOK, missingIndex] = checkifFilesExistInDirectory( filePaths );
if allOK == 0
    display( sprintf('Error : missing data file "%s"', char(fileNames{missingIndex})) );
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% searching maximum number of stimulations
max_nbStims = nbStims ;
if single_file_check == 0
    
    % checking the NbStim parameter for all the files
    for ID=1:nbFiles
        if strcmp('',fileOptions{ID}) == 0
            options = regexp(fileOptions{ID},'\/','split') ;
    
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
        data_to_save{1,2*k+2} = strcat('Stim#',int2str(k),' Base Line') ;
        data_to_save{1,2*k+3} = strcat('Stim#',int2str(k),' Time to Peak') ;
        data_to_save{1,2*max_nbStims+4+k} = strcat('Stim#',int2str(k),' Threshold') ;
        data_to_save{1,3*max_nbStims+4+k} = strcat('Stim#',int2str(k),' Rise Time') ;
        data_to_save{1,4*max_nbStims+4+k} = strcat('Stim#',int2str(k),' Decay Time') ;
    end
    data_to_save{1,2*max_nbStims+4} = strcat(' Peak Detection') ;
else
    data_to_save = {} ;
end
  

% settings & analysis

% Saving default parameters (each loop incrementation, restore them)
stimBegin_default = stimBegin ;
stimDur_default = stimDur ;
stimExcl_default = stimExcl ;
for ID=1:nbFiles
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
        
        if strcmp('',fileOptions{ID}) == 0
            options = regexp(fileOptions{ID},'\/','split') ;
            
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
                elseif size(regexp(str,'SweepRange=','end')) ~= 0
                    index = regexp(str,'SweepRange=','end') ;
                    sweep_range = str(index(1)+1:size(str,2));
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
    
    nbSweeps = fileSweepNumbers(ID);
    file_name = char( fileNames{ID} );
    file_path = char( filePaths{ID} );
    
    display(strcat('loading ''',file_name,'''...')) ;
    raw_data = load(file_path) ;
    display('data loaded') ;
    
    % The sweeps we don't want to be excluded from the analysis
    sweepsToKeep = getSweepRange( sweep_range, nbSweeps );
    
    data_to_save = Code_Selection2(file_name, ID, nbSweeps, sweepsToKeep, sampling_rate, nbStims, stim, begin_spike_smooth, peakThresholds, timeToPeakExcls, baseLineExcls, riseTimeExcls, decayTimeExcls, riseAndDecayThresholds, allStimsMustPass, raw_data, smoothing_time, toDo, data_to_save ) ;
    
end

% Put result into the workspace
display('registering result in the workspace ...') ;
to_save = genvarname(save_name, who) ;
assignin( 'base', to_save, data_to_save );

% Sweep selected range
display( '--------------------------------' );
display( 'Range of sweeps (can be used in other utilities for range selection) : ' );
display( getSweepRangeFromSelectionMatrix( data_to_save ) );
display( '--------------------------------' );

% And save it, if it was asked
if toDo(8) == 1
    display('saving...') ;

    eval([to_save ' = data_to_save;']);
    
    save_path = strcat(save_path, save_name) ;
    save(save_path, save_name);
end
display('Done.') ;
% ########################################### END Analysis of the files ###


function [nbFiles, filenames, filepaths, options, nbSweeps] = getFilenamesAndOptions( handles )
    filenames = cell( 0 );
    filepaths = cell( 0 );
    options = cell( 0 );
    nbSweeps = zeros( 0 );
    nbFiles = 0;

    list_files_check = get( handles.list_files_check, 'value' );
    %single_file_check = get( handles.single_file_check, 'value' );
    data_path = get( handles.path_raw_data_edit, 'string' ) ;
    file_list_path = get( handles.file_list_path_edit, 'string') ;
    file_single_path = get( handles.single_file_name_edit, 'string' ) ;
    %%%%%%%%%%%%%%%%%%%%% reading the file list %%%%%%%%%%%%%%%%%%%%%
    % ex : 20090210_3_07_29_ChR2_GB
    if list_files_check == 1
        if exist( file_list_path, 'file' ) && ~exist( file_list_path, 'dir' )
            fid = fopen(file_list_path);
            fileList = textscan(fid, '%s %s %s %s %s %s %s') ;
            fclose(fid);
        else
            display( sprintf('Error : the file "%s" couldn''t be found', file_list_path) );
            return;
        end  
    else
        % All this is done to use single files and list of files the same way :
        % we create a phony list of only one file, and set the right data_path
        [data_path, file_single_path, ext, versn] = fileparts(file_single_path);
        [data_path, tmp, ext, versn] = fileparts(data_path); % remove the last part of the folder (which is 'expdate' and will be added below
        data_path = strcat( data_path, filesep() );
        fileList = regexp(file_single_path, '\_', 'split') ;
        fileList = {{fileList{1}}, {fileList{2}}, {fileList{3}}, {fileList{4}}, {fileList{5}},  {fileList{6}}, {'-'}};    
    end
    %%%%%%%%%%%%%%%%%%%%% END reading the file list %%%%%%%%%%%%%%%%%%%%%

    % ############################################### Analysis of the files ###
    expdate_cells = fileList{1} ;      % class = cell
    inf1_cells = fileList{2} ;         % class = cell
    inf2_cells = fileList{3} ;         % class = cell
    inf3_cells = fileList{4} ;         % class = cell
    type1_cells = fileList{5} ;        % class = cell
    type2_cells = fileList{6} ;        % class = cell

    nbFiles = numel( expdate_cells ) ;

    filenames = cell( nbFiles, 1 );
    filepaths = cell( nbFiles, 1 );
    options = cell( nbFiles, 1 );
    nbSweeps = zeros( nbFiles, 1 );
    for i = 1:nbFiles
        path = strcat( data_path, expdate_cells{i}, filesep() );
        strfilename = strcat( expdate_cells{i}, '_', inf1_cells{i}, '_', inf2_cells{i}, '_', inf3_cells{i}, '_', type1_cells{i}, '_',type2_cells{i}, '.asc' );
        filenames{i,:} = cellstr( strfilename );
        strfilename = strcat( path, strfilename );
        filepaths{i,:} = cellstr( strfilename );
        options{i, :} = fileList{7}{i};
        nbSweeps(i) = str2double( inf3_cells{i} ) ;
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

% Display the threshold gradient for peak detection
function displayThresholdGradient( handles )
    dx = str2double( get( handles.bss_time_edit, 'string' ) );
    dy = str2double( get( handles.bss_rise_edit, 'string' ) );
    if dx == 0
        dx = 10^(-99);
    end
    gradient = dy/dx;
    set( handles.slope_dxdy, 'String', sprintf( 'dx/dy : %g', gradient ) );

function bss_time_edit_Callback(hObject, eventdata, handles)
displayThresholdGradient( handles );

function bss_rise_edit_Callback(hObject, eventdata, handles)
displayThresholdGradient( handles );

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



function save_name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to save_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of save_name_edit as text
%        str2double(get(hObject,'String')) returns contents of save_name_edit as a double


% --- Executes during object creation, after setting all properties.
function save_name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to save_name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_selectdata_check.
function plot_selectdata_check_Callback(hObject, eventdata, handles)
% hObject    handle to plot_selectdata_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_selectdata_check


% --- Executes on button press in plot_fail_check.
function plot_fail_check_Callback(hObject, eventdata, handles)
% hObject    handle to plot_fail_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_fail_check


% --- Executes on button press in save_check.
function save_check_Callback(hObject, eventdata, handles)
% hObject    handle to save_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of save_check


% --- Executes on button press in plot_max_check.
function plot_max_check_Callback(hObject, eventdata, handles)
temp = handles.plot_selectdata_check ;
doPlot = get(temp, 'value') ;
temp = handles.plot_fail_check;
doPlot = doPlot || get(temp, 'value') ;
if ~doPlot
    set( handles.plot_max_check, 'value', 0 );
    warndlg( 'To plot maxima, at least one ''Plot'' checkbox must be enabled.' );
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



function sweep_range_Callback(hObject, eventdata, handles)
% hObject    handle to sweep_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sweep_range as text
%        str2double(get(hObject,'String')) returns contents of sweep_range as a double


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


% --- Executes on button press in ttpexcl1_enabled.
function ttpexcl1_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl1_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttpexcl1_enabled



function ttpexcl1_value_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttpexcl1_value as text
%        str2double(get(hObject,'String')) returns contents of ttpexcl1_value as a double


% --- Executes during object creation, after setting all properties.
function ttpexcl1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttpexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ttpexcl2_enabled.
function ttpexcl2_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl2_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttpexcl2_enabled



function ttpexcl2_value_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttpexcl2_value as text
%        str2double(get(hObject,'String')) returns contents of ttpexcl2_value as a double


% --- Executes during object creation, after setting all properties.
function ttpexcl2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttpexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ttpexcl3_enabled.
function ttpexcl3_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl3_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ttpexcl3_enabled



function ttpexcl3_value_Callback(hObject, eventdata, handles)
% hObject    handle to ttpexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ttpexcl3_value as text
%        str2double(get(hObject,'String')) returns contents of ttpexcl3_value as a double


% --- Executes during object creation, after setting all properties.
function ttpexcl3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttpexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function blexcl3_value_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blexcl3_value as text
%        str2double(get(hObject,'String')) returns contents of blexcl3_value as a double


% --- Executes during object creation, after setting all properties.
function blexcl3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blexcl3_enabled.
function blexcl3_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl3_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blexcl3_enabled



function blexcl2_value_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blexcl2_value as text
%        str2double(get(hObject,'String')) returns contents of blexcl2_value as a double


% --- Executes during object creation, after setting all properties.
function blexcl2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blexcl2_enabled.
function blexcl2_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl2_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blexcl2_enabled



function blexcl1_value_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of blexcl1_value as text
%        str2double(get(hObject,'String')) returns contents of blexcl1_value as a double


% --- Executes during object creation, after setting all properties.
function blexcl1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to blexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in blexcl1_enabled.
function blexcl1_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to blexcl1_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of blexcl1_enabled


% --- Executes on button press in thres1_enabled.
function thres1_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thres1_enabled



function thres1_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_value as text
%        str2double(get(hObject,'String')) returns contents of thres1_value as a double


% --- Executes during object creation, after setting all properties.
function thres1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in thres2_enabled.
function thres2_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thres2_enabled



function thres2_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_value as text
%        str2double(get(hObject,'String')) returns contents of thres2_value as a double


% --- Executes during object creation, after setting all properties.
function thres2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in thres3_enabled.
function thres3_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to thres3_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of thres3_enabled



function thres3_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres3_value as text
%        str2double(get(hObject,'String')) returns contents of thres3_value as a double


% --- Executes during object creation, after setting all properties.
function thres3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smoothing_time_2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_time_2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothing_time_2_edit as text
%        str2double(get(hObject,'String')) returns contents of smoothing_time_2_edit as a double


% --- Executes during object creation, after setting all properties.
function smoothing_time_2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothing_time_2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function smoothing_time_1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to smoothing_time_1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of smoothing_time_1_edit as text
%        str2double(get(hObject,'String')) returns contents of smoothing_time_1_edit as a double


% --- Executes during object creation, after setting all properties.
function smoothing_time_1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to smoothing_time_1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_nb_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stim_nb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_nb_edit as text
%        str2double(get(hObject,'String')) returns contents of stim_nb_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_nb_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_nb_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_begin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stim_begin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_begin_edit as text
%        str2double(get(hObject,'String')) returns contents of stim_begin_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_begin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_begin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_dur_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stim_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_dur_edit as text
%        str2double(get(hObject,'String')) returns contents of stim_dur_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_dur_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_dur_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stim_excl_edit_Callback(hObject, eventdata, handles)
% hObject    handle to stim_excl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stim_excl_edit as text
%        str2double(get(hObject,'String')) returns contents of stim_excl_edit as a double


% --- Executes during object creation, after setting all properties.
function stim_excl_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stim_excl_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function bss_rise_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bss_rise_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function bss_time_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bss_time_edit (see GCBO)
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



function thres2_rise_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_rise_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_rise_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres2_rise_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres2_rise_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_rise_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres1_rise_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_rise_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_rise_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres1_rise_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres1_rise_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_rise_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function risetimeexcl3_value_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of risetimeexcl3_value as text
%        str2double(get(hObject,'String')) returns contents of risetimeexcl3_value as a double


% --- Executes during object creation, after setting all properties.
function risetimeexcl3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to risetimeexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in risetimeexcl3_enabled.
function risetimeexcl3_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl3_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of risetimeexcl3_enabled



function risetimeexcl2_value_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of risetimeexcl2_value as text
%        str2double(get(hObject,'String')) returns contents of risetimeexcl2_value as a double


% --- Executes during object creation, after setting all properties.
function risetimeexcl2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to risetimeexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in risetimeexcl2_enabled.
function risetimeexcl2_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl2_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of risetimeexcl2_enabled



function risetimeexcl1_value_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of risetimeexcl1_value as text
%        str2double(get(hObject,'String')) returns contents of risetimeexcl1_value as a double


% --- Executes during object creation, after setting all properties.
function risetimeexcl1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to risetimeexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in risetimeexcl1_enabled.
function risetimeexcl1_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to risetimeexcl1_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of risetimeexcl1_enabled


% --- Executes on button press in decaytimeexcl1_enabled.
function decaytimeexcl1_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl1_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of decaytimeexcl1_enabled



function decaytimeexcl1_value_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decaytimeexcl1_value as text
%        str2double(get(hObject,'String')) returns contents of decaytimeexcl1_value as a double


% --- Executes during object creation, after setting all properties.
function decaytimeexcl1_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl1_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decaytimeexcl2_enabled.
function decaytimeexcl2_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl2_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of decaytimeexcl2_enabled



function decaytimeexcl2_value_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decaytimeexcl2_value as text
%        str2double(get(hObject,'String')) returns contents of decaytimeexcl2_value as a double


% --- Executes during object creation, after setting all properties.
function decaytimeexcl2_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl2_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in decaytimeexcl3_enabled.
function decaytimeexcl3_enabled_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl3_enabled (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of decaytimeexcl3_enabled



function decaytimeexcl3_value_Callback(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of decaytimeexcl3_value as text
%        str2double(get(hObject,'String')) returns contents of decaytimeexcl3_value as a double


% --- Executes during object creation, after setting all properties.
function decaytimeexcl3_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to decaytimeexcl3_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres1_rise_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_rise_time as text
%        str2double(get(hObject,'String')) returns contents of thres1_rise_time as a double


% --- Executes during object creation, after setting all properties.
function thres1_rise_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres2_rise_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_rise_time as text
%        str2double(get(hObject,'String')) returns contents of thres2_rise_time as a double


% --- Executes during object creation, after setting all properties.
function thres2_rise_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_rise_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres1_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres1_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres1_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres2_decay_time_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_decay_time as text
%        str2double(get(hObject,'String')) returns contents of thres2_decay_time as a double


% --- Executes during object creation, after setting all properties.
function thres2_decay_time_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_decay_time (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in quickplot.
function quickplot_Callback(hObject, eventdata, handles)

%%%%%%%%%%%%%%%%%%%%% Settings %%%%%%%%%%%%%%%%%%%%%
temp =  handles.sampling_rate_edit ;
samplingRate = str2double(get(temp, 'string')) ;

temp =  handles.stim_nb_edit;
nbStims = str2double(get(temp, 'string')) ;

stim = zeros(nbStims,3) ;
    temp =  getfield(handles, 'stim_begin_edit') ;
    stimBegin = get(temp, 'string') ;
    stimBegin = regexp(stimBegin, '\_', 'split') ;
    temp =  getfield(handles, 'stim_dur_edit') ;
    stimDur = get(temp, 'string') ;
    temp =  getfield(handles, 'stim_excl_edit') ;
    stimExcl = get(temp, 'string') ;
    for i=1:nbStims
        stim(i,1) = str2double( stimBegin{i} ) ;
        stim(i,2) = str2double( stimDur ) ;
        stim(i,3) = str2double( stimExcl ) ;
    end

smoothingTimes = zeros(1,2) ;
    temp =  getfield(handles, 'smoothing_time_1_edit') ;
    smoothingTimes(1,1) = str2double(get(temp, 'string')) ;
    temp =  getfield(handles, 'smoothing_time_2_edit') ;
    smoothingTimes(1,2) = str2double(get(temp, 'string')) ;
    
% The sweeps we don't want to be excluded from the analysis
temp = handles.sweep_range;
sweepRange = get(temp, 'string') ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% File lists or single file options %%%%%%%%%%
[nbFiles, fileNames, filePaths, fileOptions, fileSweepNumbers] = getFilenamesAndOptions( handles );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check if all files of the file list do exist ; otherwise, print an error
% and return. Use the function from checkifFilesExistInDirectory.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if get( handles.list_files_check, 'value' ) == 1
    file_list_path = get( handles.file_list_path_edit, 'string') ;
    display( sprintf( 'Checking that all files from "%s" exist ...', file_list_path ) ) ;
else
    display( sprintf( 'Checking that the data file "%s" exists ...', char(fileNames{1}) ) ) ;
end
[allOK, missingIndex] = checkifFilesExistInDirectory( fileNames );
if allOK == 0
    display( sprintf('Error : missing data file "%s"', char(fileNames{missingIndex})) );
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:nbFiles
    nbSweeps = fileSweepNumbers(i);
    file_name = char( fileNames{i} );
    file_path = char( filePaths{i} );
    
    display(strcat('loading ''',file_name,'''...')) ;
    rawData = load(file_path) ;
    display('data loaded') ;
    
    % The sweeps we don't want to be excluded from the analysis
    sweepsToKeep = 1:nbSweeps;

    doQuickSweepsPlot( nbSweeps, sweepsToKeep, samplingRate, nbStims, stim, rawData, smoothingTimes, file_name );
end



function thres1_max_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres1_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres1_max_value as text
%        str2double(get(hObject,'String')) returns contents of thres1_max_value as a double


% --- Executes during object creation, after setting all properties.
function thres1_max_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres1_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres2_max_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres2_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres2_max_value as text
%        str2double(get(hObject,'String')) returns contents of thres2_max_value as a double


% --- Executes during object creation, after setting all properties.
function thres2_max_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres2_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function thres3_max_value_Callback(hObject, eventdata, handles)
% hObject    handle to thres3_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of thres3_max_value as text
%        str2double(get(hObject,'String')) returns contents of thres3_max_value as a double


% --- Executes during object creation, after setting all properties.
function thres3_max_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to thres3_max_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
