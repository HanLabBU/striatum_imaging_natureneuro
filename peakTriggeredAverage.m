 % Pass in 3 arguments: activity trace, which is a samples x roi binary
% matrix containing logicals that represent periods of time when an roi is
% active. Movement peaks is a binary vector with 1s during movement onset,
% where movement onset = peaks to which roi activity is aligned. Radius is
% the distance to look around each movement peak. Returns two items:
% bsActivityAroundPeaks and activityAroundPeaks, which contain the mean
% activity around peaks, and bootstrapped mean activity around peaks.

function [activityAroundPeaks] = peakTriggeredAverage(activityTrace, movementPeaks, radius, noSamples)
        startpeaknum = sum(movementPeaks(1:radius));
        movementPeaks(1:radius) = 0;
       
        finpeaknum = sum(movementPeaks(length(movementPeaks)-radius+1:end));
        movementPeaks(length(movementPeaks)-radius+1:end) = 0;

        activityAroundPeaks = movementTriggeredPeak(activityTrace, movementPeaks, radius);
        activityAroundPeaks = cat(2,nan(size(activityAroundPeaks,1),startpeaknum,size(activityAroundPeaks,3)), activityAroundPeaks);

        activityAroundPeaks = cat(2,activityAroundPeaks, nan(size(activityAroundPeaks,1),finpeaknum,size(activityAroundPeaks,3)));
    if noSamples > 0
        mnSamps = repmat(nanmean(activityTrace,1),size(activityAroundPeaks,2),1);
        stdSamps = repmat(nanstd(activityTrace,[],1),size(activityAroundPeaks,2),1);
        
        activityAroundPeaks = bsxfun(@minus,activityAroundPeaks,reshape(mnSamps,1,size(mnSamps,1),size(mnSamps,2)));
        activityAroundPeaks = bsxfun(@rdivide, activityAroundPeaks,reshape(stdSamps,1,size(stdSamps,1),size(stdSamps,2)));
    end
end