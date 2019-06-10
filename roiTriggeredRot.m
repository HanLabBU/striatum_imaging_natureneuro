function peakmvmt = roiTriggeredRot(suffix, radius, roitype) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
    for m=1:numel(suffix)
        allMouseData = loadMouse({suffix{m}});
        
        act = allRising(allMouseData);

        rot = abs(allMouseData.rot);
        
        transition = diff(act.(roitype),[],1) == 1;

        peakMovementRot = [];
        for c=1:size(transition,2)

            currspeed = peakTriggeredAverage(rot, transition(:,c), radius, 0);
  
            peakMovementRot = cat(2,peakMovementRot,nanmean(squeeze(currspeed),2));
        end
        
        peakmvmt(m).rot = peakMovementRot;
        
        fprintf('Done with %s\n',suffix{m});
    end
end