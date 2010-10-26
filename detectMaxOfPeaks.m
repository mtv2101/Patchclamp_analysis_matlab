function peaksMaxTable = detectMaxOfPeaks( peaksTable )
% Takes a cell 'peaksTable', with
% - peaksTable{ k, i, 1 } = times of the max of detected peaks ([ ] if no
% detected peak) for the k-th stim of the i-th sweep
% - peaksTable{ k, i, 2 } = indexes of the max of detected peaks ([ ] if no
% detected peak) for the k-th stim of the i-th sweep
% - peaksTable{ k, i, 3 } = maxima of detected peaks ([ ] if no detected
% peak) for the k-th stim of the i-th sweep
%
% Returns peaksMaxTable, where
%       peaksMaxTable{ k, i, 1 } : time of the maximum peak, for the sweep i, and stim k
%       peaksMaxTable{ k, i, 2 } : index of the maximum peak
%       peaksMaxTable{ k, i, 3 } : value of the maximum
% or -1, -1, -1 if no peak was detected.

    nbStims = size( peaksTable, 1 );
    nbSweeps = size( peaksTable, 2 ) - 1;   % nbSweeps + 1 for the mean
    peaksMaxTable = cell( nbStims, nbSweeps+1, 3 );

    for i=1:nbSweeps+1 % do also for the mean
        for k=1:nbStims
            if isempty( peaksTable{k,i,1} )
                peaksMaxTable{k,i,1} = -1;
                peaksMaxTable{k,i,2} = -1;
                peaksMaxTable{k,i,3} = -1;
            else
                j = find( peaksTable{k,i,3}(:) == max( peaksTable{k,i,3} ) );
                peaksMaxTable{k,i,1} = peaksTable{ k, i, 1 }(j);
                peaksMaxTable{k,i,2} = peaksTable{ k, i, 2 }(j);
                peaksMaxTable{k,i,3} = peaksTable{ k, i, 3 }(j);
            end
        end
    end

end
