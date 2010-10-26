function convertASCIIDataToMAT( folderDataPath, fileListFullPath )
% Load the raw data from the file list and pretreat it (organize it in
% sweeps). Throws an exception if the data file is not found.
    
    % Opens the file list and retrieve all options about data files by
    % parsing their names
    [nbFiles, fileNames, filePaths, newFilePaths] = getFilenamesFromFilelist( folderDataPath, fileListFullPath );

    % Load the data
    for i=1:nbFiles
        filename = char( fileNames{i} );
        newfilepath = char( newFilePaths{i} );
        filepath = char( filePaths{i} );
        
        if ~( exist( filepath, 'file' ) && ~exist( filepath, 'dir' ) )
            errString = sprintf('Error : the file "%s" (%s) couldn''t be found', filename, filepath);
            warndlg( errString );
            ME = MException( 'MATLAB:FileNotFound', errString );
            throw(ME);
        end

        display(strcat('- loading ''', filename, '''...')) ;
            rawData = load( filepath ) ;
        display('- ASCII Data loaded') ;
        save( newfilepath, 'rawData', '-mat');
        display(strcat('- saved ''', newfilepath, '''...')) ;
    end
    display( sprintf('--- Loaded %d files into workspace ---', nbFiles) );
end

function [nbFiles, filenames, filepaths, newfilepaths] = getFilenamesFromFilelist( folderDataPath, fileListFullPath )
    filenames = cell( 0 );
    filepaths = cell( 0 );
    newfilepaths = cell( 0 );
    nbSweeps = zeros( 0 );
    nbFiles = 0;

    %%%%%%%%%%%%%%%%%%%%% reading the file list %%%%%%%%%%%%%%%%%%%%%
    % ex : 20090210_3_07_29_ChR2_GB
        if exist( fileListFullPath, 'file' ) && ~exist( fileListFullPath, 'dir' )
            fid = fopen(fileListFullPath);
            fileList = textscan(fid, '%s %s %s %s %s %s %s %s' ) ; 
            % Un champ de plus que dans les autres scripts :
            % la date de début de l'enregistrement, en ms (dernier champ)
            % 20090126	3	07	28	ChR2	GB	-   123213432
            fclose(fid);
%             if numel(fileList{1}) ~= numel(fileList{8}) % problem with the file : invalid format (missing fields)
%                 errString = sprintf('Error : the file "%s" was ill-formed', fileListFullPath);
%                 warndlg( errString );
%                 ME = MException( 'MATLAB:WrongFormat', errString );
%                 throw(ME);
%             end
        else
            errString = sprintf('Error : the file "%s" couldn''t be found', fileListFullPath);
            warndlg( errString );
            ME = MException( 'MATLAB:FileNotFound', errString );
            throw(ME);
        end  
    %%%%%%%%%%%%%%%%%%%%% END reading the file list %%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%% Analysis of the file names %%%%%%%%%%%%%%%%%%%%%
    expdate_cells = fileList{1} ;      % class = cell : folder (and date)
    inf1_cells = fileList{2} ;         % class = cell
    inf2_cells = fileList{3} ;         % class = cell
    inf3_cells = fileList{4} ;         % class = cell : number of sweeps in the file
    type1_cells = fileList{5} ;        % class = cell
    type2_cells = fileList{6} ;        % class = cell

    nbFiles = numel( expdate_cells ) ;

    filenames = cell( nbFiles, 1 );
    filepaths = cell( nbFiles, 1 );
    newfilepaths = cell( nbFiles, 1 );
    nbSweeps = zeros( nbFiles, 1 );
    for i = 1:nbFiles
        path = strcat( folderDataPath, expdate_cells{i}, filesep() );
        strfilename = strcat( expdate_cells{i}, '_', inf1_cells{i}, '_', inf2_cells{i}, '_', inf3_cells{i}, '_', type1_cells{i}, '_',type2_cells{i}, '.asc' );
        filenames{i,:} = cellstr( strfilename );
        strfilename = strcat( path, strfilename );
        filepaths{i,:} = cellstr( strfilename );
        newfilepaths{i,:} = strrep(filepaths{i}, '.asc', '.mat');
        newfilepaths{i,:} = strrep(newfilepaths{i}, '.ASC', '.mat'); % just in case
        nbSweeps(i) = str2double( inf3_cells{i} ) ;
    end
end
