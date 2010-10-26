function [answer, missingFileIndex] = checkifFilesExistInDirectory( filename_array )
% Check if all the files whose names are in filename_array exist in
% directory_path ; if so, return 1 and missingFileIndex = -1 ; otherwise, return 0 and the index of
% the missing file in the array
answer = 1;
missingFileIndex = -1;

n = size(filename_array, 1) ;
i = 1;

while (answer == 1 && i <= n)
    if exist(char(filename_array{i}), 'file') == 0
        missingFileIndex = i;
        answer = 0;
    end
    i = i + 1;
end

end

