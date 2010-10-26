function peaksTable = detectPeaks( data, nbStims, nbSweeps, intervalsToConsiderForMax, smoothingX, smoothingY, useSuggestion )
% 'data' is the matrix of points : data(iIndex, iSweep) is the value mesured
% at the time (or, rather, index) 'iIndex', for the sweep 'iSweep'
% and where data(iIndex, nbSweeps+2 ) is the time corresponding with this
% index
% intervalsToConsiderForMax(1:nbStims, 4) : for each stim, two intervals
% where peaks are to be kept ([point1,point2] and [point3,point4])
% Returns a cell 'peaksTable', with
% - peaksTable{ k, i, 1 } = times of the max of detected peaks ([ ] if no
% detected peak) for the k-th stim of the i-th sweep
% - peaksTable{ k, i, 2 } = indexes of the max of detected peaks ([ ] if no
% detected peak) for the k-th stim of the i-th sweep
% - peaksTable{ k, i, 3 } = maxima of detected peaks ([ ] if no detected
% peak) for the k-th stim of the i-th sweep

    if nargin < 7
        useSuggestion = 0;
    end

    %peaksTable = zeros( nbStims, nbSweeps+1, 2 );
    peaksTable = cell( nbStims, nbSweeps+1, 3 );
    
    % Handle the case the inner (exclusion) interval is not within the
    % 'big' interval
    for k=1:nbStims
        if intervalsToConsiderForMax(k, 2) < intervalsToConsiderForMax(k, 1)
            intervalsToConsiderForMax(k, 2) =  intervalsToConsiderForMax(k, 1);
        end
        if intervalsToConsiderForMax(k, 3) > intervalsToConsiderForMax(k, 4)
            intervalsToConsiderForMax(k, 3) =  intervalsToConsiderForMax(k, 4);
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%% Baseline and Spike exclusion %%%%%%%%%%%%%%%%%%%
        for i=1:nbSweeps+1 % do also for the mean
            x = data( :, i );
            maxima = find( diff( diff(x) > 0 ) < 0 );    % Find all maxima
           
            %% Display graphs to see where is everything (DEBUG)
%            figure
%            hold on, plot( data( :, nbSweeps+2 ), data( :, i ), 'b' );
            
            for k=1:nbStims
                selectedMaxima = [ ];
                maximaForStimK =  maxima( find( maxima >= intervalsToConsiderForMax(k, 1) ) );
                maximaForStimK =  maximaForStimK( find( maximaForStimK <= (intervalsToConsiderForMax(k, 4)  + 1 - smoothingX) ) );
                
                maximaForStimK1 =  maximaForStimK( find( maximaForStimK <= intervalsToConsiderForMax(k, 2) ) );
                maximaForStimK2 =  maximaForStimK( find( maximaForStimK >= intervalsToConsiderForMax(k, 3) ) );
                maximaForStimK = [ maximaForStimK1; maximaForStimK2 ];
                
                % Find a proposition of threshold
                thresMaxima = zeros( 1, numel(maximaForStimK) );
                [valueMax, p] = max( data( maximaForStimK(:), i ) );
                %for p=1:numel(maximaForStimK)
                    if maxima(p) - smoothingX > 0
                        thresMaxima(p) = data( maximaForStimK(p), i ) - data( maximaForStimK(p) - smoothingX, i );
                    end
                %end
                suggSmoothingY = max( thresMaxima ) * 0.5;
                
                if useSuggestion
                    smoothingY = suggSmoothingY;
                end
                
                % Now, see which peaks can pass the threshold criterion
                % (and only keep those)
                
                nMax = numel( maximaForStimK );
                for j=1:nMax
                    if ( data( maximaForStimK(j), i ) - data( maximaForStimK(j) - smoothingX, i ) >= smoothingY )
                        selectedMaxima = [selectedMaxima; maximaForStimK(j)];
                        
                        %% Display graphs to see where is everything (DEBUG)
%                         hold on, plot( data( maximaForStimK(j), nbSweeps+2 ), data( maximaForStimK(j), i ), 'r', 'Marker', 'o' );
%                         hold on, plot( data( maximaForStimK(j) - smoothingX, nbSweeps+2 ), data( maximaForStimK(j) - smoothingX, i ), 'k', 'Marker', 'o' );
%                     else
%                          hold on, plot( data( maximaForStimK(j), nbSweeps+2 ), data( maximaForStimK(j), i ), 'b', 'Marker', 'o' );
%                          hold on, plot( data( maximaForStimK(j) - smoothingX, nbSweeps+2 ), data( maximaForStimK(j) - smoothingX, i ), 'g', 'Marker', 'o' );
                    end                    
                end
                
                % If there were none, there suggest the threshold computed
                % above ; otherwise, everything is fine
                if isempty( selectedMaxima )
                    display( sprintf('Suggested Y threshold : %f', suggSmoothingY ) );
                    display( sprintf('Used Y threshold : %f', smoothingY ) );
                else
                    peaksTable{k,i,1} = data( selectedMaxima, nbSweeps + 2 ) ;
                    peaksTable{k,i,2} = selectedMaxima ;
                    peaksTable{k,i,3} = data( selectedMaxima, i ) ;
                end
                
%                 indexEffectiveStart = indexesBeginStims(k) ;
% 
%                 % spike pendant la stim
%                 while ( indexEffectiveStart + smoothingX < indexesEndStims(k) + 1 &&  ( data(indexEffectiveStart+smoothingX,i) - data(indexEffectiveStart,i) < smoothingY )  )
%                     indexEffectiveStart = indexEffectiveStart + 1;
%                 end
%
%                 % si pas de spike, on cherche apres la stim, en excluant l'artefact
%                 if indexEffectiveStart + smoothingX == indexesEndStims(k) + 1
%                     indexEffectiveStart = indexEndArtifact(k) ;
%                     while (indexEffectiveStart + smoothingX < indexEndSearchStims(k) + 1  &&  ( data(indexEffectiveStart+smoothingX,i) - data(indexEffectiveStart,i) < smoothingY ) )
%                         indexEffectiveStart = indexEffectiveStart + 1;
%                     end
%                 end
% 
%                 % fin du fichier atteinte == failure
%                 % sinon sweep selectionne pour ce critere
%                 if indexEffectiveStart + smoothingX < indexEndSearchStims(k) + 1
%                     peaksTable(k,i,1) = data( indexEffectiveStart, nbSweeps + 2 ) ;
%                     peaksTable(k,i,2) = indexEffectiveStart ;
%                 end
                
            end
        end
    %%%%%%%%%%%%%%%%%%%%%%%% END Baseline and Spike exclusion %%%%%%%%%%%%%%%%%

end
