function [times, indexes, values] = getPeaksInTimeWindow( peakList, indexBegin, indexEnd )
% Takes a 3xN matrix 'peakList', with
% - peakList( 1, : ) = times of the max of detected peaks ([ ] if no
% detected peak)
% - peakList( 2, : ) = indexes of the max of detected peaks
% - peakList( 3, : ) = maxima of detected peaks
%
% Returns 3 lists, with
% - #1 = times of the max of selected peaks ([ ] if no detected peak)
% - #2 = indexes of the max of selected peaks
% - #3 = maxima of selected peaks
% Where the "selected peaks" are the ones occurring between indexBegin and
% indexEnd

    indexes =  peakList(2,:);
    range1 = find( indexes >= indexBegin );
    range2 = find( indexes <= indexEnd );
    range = intersect( range1, range2 );

    times =  peakList(1,range);
    indexes =  peakList(2,range);
    values =  peakList(3,range);
end
