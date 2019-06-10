function peakmvmt = roiTriggeredROI(suffix, radius, noSamples, activityBool, roitype) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
    for m=1:numel(suffix)
        allMouseData = loadMouse({suffix{m}});
        
        act = allRising(allMouseData);
        
        speed = allMouseData.speed;
        
        transition = diff(act.(roitype),1) == 1;
        
        if nargin > 3 && activityBool
            traces = act;
        else
            traces = allFluor(allMouseData);
        end

        peakMovementFSI = nan(2*radius+1,size(traces.fsi,2),size(transition,2));
        peakMovementMSN = nan(2*radius+1,size(traces.msn,2),size(transition,2));
        peakMovementCHI = nan(2*radius+1,size(traces.chi,2),size(transition,2));
        peakMovementSpeed = [];
        for c=1:size(transition,2)
            currchi = peakTriggeredAverage(traces.chi, transition(:,c), radius, noSamples);
            currmsn = peakTriggeredAverage(traces.msn, transition(:,c), radius, noSamples);
            currfsi = peakTriggeredAverage(traces.fsi, transition(:,c), radius, noSamples);
            currspeed = peakTriggeredAverage(speed, transition(:,c), radius, 0);
            peakMovementFSI(:,:,c) = squeeze(nanmean(currfsi,2));
            peakMovementMSN(:,:,c) = squeeze(nanmean(currmsn,2));
            peakMovementCHI(:,:,c) = squeeze(nanmean(currchi,2));
            peakMovementSpeed = cat(2,peakMovementSpeed,squeeze(nanmean(currspeed,2)));
        end
        
        peakmvmt(m).fsi = peakMovementFSI;
        peakmvmt(m).msn = peakMovementMSN;
        peakmvmt(m).chi = peakMovementCHI;
%         peakmvmt(m).rot = peakMovementRot;
        peakmvmt(m).speed = peakMovementSpeed;
        
        peakmvmt(m).(roitype)(:,~~eye(size(peakmvmt(m).(roitype),2),size(peakmvmt(m).(roitype),3))) = nan;
        fprintf('Done with %s\n',suffix{m});
    end
end