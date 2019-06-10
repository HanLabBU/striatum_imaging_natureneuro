function peakmvmt = roiTriggeredMSNSynchSum(suffix, radius, roitype, ind1, ind2) % movementCutoff should be 50 as per balltest2

    for m=1:numel(suffix)
        % load mouse and deconvolved traces
        allMouseData = loadMouse({suffix{m}});
        
        % load deconvolved traces
        traces = allRising(allMouseData);  
        
        if isempty(traces.(roitype))
            continue
        end
        % compute event onsets
        movementTransition = diff(traces.(roitype),1) == 1;
       
        peakMovement = [];
        peakMovementSpeed = [];
        peakInds = [];
        
        npeaks = 0;
        
        for c=1:size(movementTransition,2)
            
            currinds = movementTransition(:,c);
            if strcmp(roitype,'msn')
                currtraces = traces.msn(:,setdiff(1:size(traces.msn,2),c));
            else
                currtraces = traces.msn;
            end
            
            
            % compute synchrony sum (n*(n-1)/2 values for each event)
            [currmsn, npairs, npeakscurr] = peakTriggeredPairSynchSum(currtraces, currinds, radius);
            
            % get and store individual values from ind1 and ind2 for each
            % pair
            currpeakinds = peakTriggeredPairSynch(currtraces,currinds,radius, ind1, ind2);
            peakInds = cat(1,peakInds,currpeakinds);
            peakMovement = cat(2, peakMovement,currmsn);
            npeaks = npeaks + npeakscurr;
        end
        
        % store values
        peakmvmt(m).msn = peakMovement;
        peakmvmt(m).speed = peakMovementSpeed;
        peakmvmt(m).npairs = npairs;
        peakmvmt(m).npeaks = npeaks;
        peakmvmt(m).peakinds = peakInds;
        fprintf('Done with %s\n',suffix{m});
    end

end