function peakmvmt = roiTriggeredMSNSynchronyLaser(metadata, radius, roitype, ind1, ind2, laseron) % movementCutoff should be 50 as per balltest2

    for m=1:numel(metadata)
        allMouseData = loadMouseLaser(metadata(m));
        traces = allRisingLaser(allMouseData);        
        if isempty(traces.(roitype))
            continue
        end
        transition = cat(1,diff(traces.(roitype),[],1) == 1,zeros(1,size(traces.(roitype),2)));
       
        peakMovement = [];
        peakInds = [];
        
        npeaks = 0;
                
        % keep only those indices in the desired time period
        if laseron == 1
            transition = bsxfun(@times,transition,~~allMouseData.laserIndices(:));
        elseif laseron == 0
            transition = bsxfun(@times,transition,~allMouseData.laserIndices(:));
        end
        
        for c=1:size(transition,2)
            
            currinds = transition(:,c);
            if strcmp(roitype,'msn')
                currtraces = traces.msn(:,setdiff(1:size(traces.msn,2),c));
            else
                currtraces = traces.msn;
            end
            
            [currmsn, npairs, npeakscurr] = peakTriggeredPairSynchSum(currtraces, currinds, radius);
            currpeakinds = peakTriggeredPairSynch(currtraces,currinds,radius, ind1, ind2);
            peakInds = cat(1,peakInds,currpeakinds);
            peakMovement = cat(2, peakMovement,currmsn);
            npeaks = npeaks + npeakscurr;
        end
        
        peakmvmt(m).msn = peakMovement;
        peakmvmt(m).npairs = npairs;
        peakmvmt(m).npeaks = npeaks;
        peakmvmt(m).peakinds = peakInds;
        fprintf('Done with %s\n',metadata(m).suffix);
    end

end