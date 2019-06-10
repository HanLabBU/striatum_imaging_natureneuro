function peakmvmt = roiTriggeredROISigInds(suffix, radius, noSamples, activityBool, roitype,posorneg) % movementCutoff should be 50 as per balltest2

    for m=1:numel(suffix)
        % load current session
        allMouseData = loadMouse({suffix{m}});
        
        % get deconvolved traces
        act = allRising(allMouseData);
        
        % get fluorescence traces
        fluor = allFluor(allMouseData);
        
        % get speed for this session
        speed = allMouseData.speed;
        
        % define transitions 
        transition = diff(act.(roitype),1) == 1;
        
        % trim transitions if supplied this field
        if exist('posorneg','var')
            % get movement onsets, convert to binary
            siginds = getSigModulated(suffix{m},roitype);
            % trim the transition matrix
            transition = transition(:,~~siginds.(posorneg)); 
        end
        
        % depending on this flag, use deconvolved traces or fluorescence
        % traces
        if nargin > 3 && activityBool
            traces = act;
        else
            traces = fluor;
        end

        %initialize output values
        peakMovementFSI = nan(2*radius+1,size(traces.fsi,2),size(transition,2));
        peakMovementMSN = nan(2*radius+1,size(traces.msn,2),size(transition,2));
        peakMovementCHI = nan(2*radius+1,size(traces.chi,2),size(transition,2));
        peakMovementSpeed = [];
        
        for c=1:size(transition,2)
            % for each ROI, get peak triggered average around its events
            currchi = peakTriggeredAverage(traces.chi, transition(:,c), radius, noSamples);
            currmsn = peakTriggeredAverage(traces.msn, transition(:,c), radius, noSamples);
            currfsi = peakTriggeredAverage(traces.fsi, transition(:,c), radius, noSamples);
            currspeed = peakTriggeredAverage(speed, transition(:,c), radius, 0);
            
            % store values after averaging across events
            peakMovementFSI(:,:,c) = squeeze(nanmean(currfsi,2));
            peakMovementMSN(:,:,c) = squeeze(nanmean(currmsn,2));
            peakMovementCHI(:,:,c) = squeeze(nanmean(currchi,2));
            peakMovementSpeed = cat(2,peakMovementSpeed,squeeze(nanmean(currspeed,2)));
        end
        
        % store output
        peakmvmt(m).fsi = peakMovementFSI;
        peakmvmt(m).msn = peakMovementMSN;
        peakmvmt(m).chi = peakMovementCHI;
        peakmvmt(m).speed = peakMovementSpeed;
        
        % set to nan self-triggered events
        peakmvmt(m).(roitype)(:,~~eye(size(peakmvmt(m).(roitype),2),size(peakmvmt(m).(roitype),3))) = nan;
        fprintf('Done with %s\n',suffix{m});
    end
end