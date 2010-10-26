function cleanData = removeArtifactsFromData( sweepSize, data, indexBeginArtifact, indexEndArtifact )
% The same data, but with the artifacts (whose beginnings and ends are in indexBeginArtifact and indexEndArtifact)
% replaced by a linear interpolation (a segment), so they won't mess up the
% ulterior computations.

    display('removing artifacts ...') ;
    nbSweeps = size( data, 2 ) - 2; % nbSweeps, +1 for the mean, +1 for the time
    nbStims = numel( indexBeginArtifact );

    cleanData = data ;
    for i=1:nbSweeps+1
        for k=1:nbStims
            x = [ indexBeginArtifact(k) indexEndArtifact(k) ];
            y = [ data(x(1), i) data(x(2), i) ];
            xi = indexBeginArtifact(k):indexEndArtifact(k);
            cleanData( indexBeginArtifact(k):indexEndArtifact(k), i ) = interp1(x,y,xi);
        end
    end
    display('removing done ...') ;
    
end
