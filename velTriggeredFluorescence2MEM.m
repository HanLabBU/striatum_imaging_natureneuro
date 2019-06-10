function [peakFluorescence, mouseid,roiid,eventid] = velTriggeredFluorescence2MEM(mouseno, radius) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
%     [nhat, phat] = makeCatActivityTraces(suffix);

peakFluorescence = struct('fsi',[],'chi',[],'msn',[]);
mouseid = struct('fsi',[],'chi',[],'msn',[]);
roiid = struct('fsi',[],'chi',[],'msn',[]);
eventid = struct('fsi',[],'chi',[],'msn',[]);
fields = fieldnames(mouseid);
suffix = mouseSuffix(mouseno);
mice = cellfun(@(x) regexp(x,'^([0-9]*)','match'),suffix);

n_events = 0;
curr_roi = 0;
for m=1:numel(suffix)
    allMouseData = loadMouse(suffix(m));
    speed = allMouseData.speed;
    threshold = 55;

    movementTransition = findVelocityPeaks(speed, threshold);
    fprintf('%d peaks\n',length(movementTransition));
    movementTransition = indices2Indicator(movementTransition, length(speed));
    allMouseData = addSpeedInfo(allMouseData,1,5);
    
    traces = allFluor(allMouseData);
    curr_events = n_events + (1:sum(movementTransition));
    n_events = max(curr_events);
    for f=1:numel(fields)
        peakMovement.(fields{f}) = peakTriggeredAverage(traces.(fields{f}), movementTransition, radius, 0);
        roi_ids_curr = repmat((1:size(peakMovement.(fields{f}),3))+curr_roi,size(peakMovement.(fields{f}),2),1);
        curr_roi = curr_roi + size(peakMovement.(fields{f}),3);
        eventids_curr = repmat(curr_events,1,size(peakMovement.(fields{f}),3));
        
        eventid.(fields{f}) = cat(1,eventid.(fields{f}),eventids_curr(:));
        roiid.(fields{f}) = cat(1,roiid.(fields{f}),roi_ids_curr(:));
        peakFluorescence.(fields{f}) = cat(2,peakFluorescence.(fields{f}), reshape(peakMovement.(fields{f}),2*radius+1,[]));
        mouseid.(fields{f}) = cat(1,mouseid.(fields{f}),repmat(nominal(mice{m}),size(peakMovement.(fields{f}),3)*size(peakMovement.(fields{f}),2),1));
    end
end
    
    

end
