function smoothedData = smoothData( sizeSweep, data, smoothingX_1, smoothingX_2, indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexEndArtifact )
% Return smoothed data, based on raw data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DATA SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%

display('beginning smoothing...') ;
nbSweeps = size( data, 2 ) - 2;
nbStims = numel( indexBeginStims );
smoothedData = zeros( sizeSweep, nbSweeps+2 ) ;
smoothedData(:,nbSweeps+2) = data(:,nbSweeps+2) ; % Last one is time : just copy it

% For each sweep, we consider 4 different areas (each sweep has 4 smooth
% points) :
% - between the end of the precedent stim and the beginning of
% this one, we smooth the data
% - between the beginning of the stim and 1 ms after the beginning, we
% don't
% - between that point and the end of the stim, we smooth
% - after the end of the stim, for a duration equal to the artifact exclusion time, we don't
smoothPoints = zeros(1, 4*nbStims+1) ;
smoothPoints(1) = 1;
for k=1:nbStims
    smoothPoints(4*k-2) = indexBeginStims(k); % Stim beginning
    smoothPoints(4*k-1) = indexEffectiveBeginStims(k);       % 1 ms after the stim beginning
    smoothPoints(4*k) = indexEndStims(k);              % stim end
    smoothPoints(4*k+1) = indexEndArtifact(k);        % stim end + artifact exclusion time
end

for i=1:nbSweeps+1
    for k=1:nbStims
        smoothedData(smoothPoints(4*k-3):smoothPoints(4*k-2),i) = smooth(data(smoothPoints(4*k-3):smoothPoints(4*k-2),i), smoothingX_1) ;
        smoothedData(smoothPoints(4*k-3):smoothPoints(4*k-2),i) = smooth(smoothedData(smoothPoints(4*k-3):smoothPoints(4*k-2),i), smoothingX_2) ;
        
        smoothedData(smoothPoints(4*k-2)+1:smoothPoints(4*k-1)-1,i) = data(smoothPoints(4*k-2)+1:smoothPoints(4*k-1)-1,i) ;
        
        smoothedData(smoothPoints(4*k-1):smoothPoints(4*k),i) = smooth(data(smoothPoints(4*k-1):smoothPoints(4*k),i),smoothingX_1) ;
        smoothedData(smoothPoints(4*k-1):smoothPoints(4*k),i) = smooth(smoothedData(smoothPoints(4*k-1):smoothPoints(4*k),i),smoothingX_2) ;
        
        smoothedData(smoothPoints(4*k)+1:smoothPoints(4*k+1)-1,i) = data(smoothPoints(4*k)+1:smoothPoints(4*k+1)-1,i) ;
    end
    % We smooth after the end of the last stim
    smoothedData(smoothPoints(4*k+1):sizeSweep,i) = smooth( data(smoothPoints(4*k+1):sizeSweep,i),smoothingX_1 ) ;
    smoothedData(smoothPoints(4*k+1):sizeSweep,i) = smooth( smoothedData(smoothPoints(4*k+1):sizeSweep,i),smoothingX_2 ) ;
end

display('smoothing done') ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END SMOOTHING %%%%%%%%%%%%%%%%%%%%%%%%%%

end

