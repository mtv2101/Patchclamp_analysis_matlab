function [indexBeginStims, indexEffectiveBeginStims, indexEndStims, indexBeginArtifact, indexEndArtifact, indexEndAnswers] = getStimsUsefulPoints(  sizeSweep, stimsInfo, samplingRate )
% Return tables containing data used for the treatment of stims
nbStims = size( stimsInfo, 1 );

timeBeginStims = zeros(1, nbStims) ;
timeEndStims = zeros(1, nbStims) ;
indexEndStims = zeros(1, nbStims) ;                 % stim end
stimDurations = zeros(1, nbStims) ;
artifactExclDurations = zeros(1, nbStims) ;
timeEndAnswers = zeros(1, nbStims) ;
indexEndAnswers = zeros(1, nbStims) ;
indexBeginArtifact = zeros(1, nbStims) ;              % stim end - artifact exclusion time
indexEndArtifact = zeros(1, nbStims) ;              % stim end + artifact exclusion time
indexBeginStims = zeros(1, nbStims) ;               % Stims beginning
indexEffectiveBeginStims = zeros(1, nbStims) ;      % 1 ms after the stim beginning
 
    for k=1:nbStims   
        timeBeginStims(k) = stimsInfo(k,1) ; % en ms
        indexBeginStims(k) = int32( stimsInfo(k,1) / samplingRate ) + 1 ;
        stimDurations(k) = stimsInfo(k,2) ; % en ms
        artifactExclDurations(k) = stimsInfo(k,3) ; % en ms, temps d'exclusion apres debut artefact

        if k == nbStims
            indexEndAnswers(k) = sizeSweep ;
        else
            timeEndAnswers(k) = stimsInfo(k+1,1) ;
            indexEndAnswers(k) = int32(timeEndAnswers(k) / samplingRate) + 1 ;
        end
        indexEffectiveBeginStims(k) = int32( (timeBeginStims(k) + 1) / samplingRate) + 1 ;

        timeEndStims(k) = timeBeginStims(k) + stimDurations(k) ;
        indexEndStims(k) = int32(timeEndStims(k) / samplingRate) + 1 ;
        indexBeginArtifact(k) = indexEndStims(k) - int32( artifactExclDurations(k) / samplingRate ) ;
            indexBeginArtifact(k) = min( indexBeginArtifact(k), indexBeginStims(k) ) ;
        indexEndArtifact(k) = indexEndStims(k) + int32( artifactExclDurations(k) / samplingRate ) ;
            indexEndArtifact(k) = min( indexEndArtifact(k), indexEndAnswers(k) ) ;
            
        % Don't overlap
        if indexBeginArtifact(k) < indexEffectiveBeginStims(k)
           indexBeginArtifact(k) =  indexEffectiveBeginStims(k) + 1;
        end
    end

end

