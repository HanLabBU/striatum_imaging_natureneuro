% suffix is the session we want to use, radius is the window we want to use
% around each event, and normalize is whether or not we want to normalize
% the fluorescence
function [peakFluorescence, sigInds, tstats, peakfluor] = dyTriggeredFluorescence(suffix, radius, normalize) % movementCutoff should be 50 as per balltest2


    %load session, speed, and rotation
    allMouseData = loadMouse({suffix});
    speed = allMouseData.speed;
    rot = abs(allMouseData.rot);
    
    % get movement onset events
    movementTransition1 = findPeaksManual(speed, allMouseData.dt);
    movementTransition = findPeaksManual2(speed, allMouseData.dt);
    assert(isequaln(movementTransition1,movementTransition),'find peaks manual gives different results!!!!');
    
    % convert indices to indicator
    movementTransition = indices2Indicator(movementTransition, length(speed));
    fprintf('Number of events: %0.0f\n',sum(movementTransition));
    
    % get all traces for this current session
    traces = allFluor(allMouseData);
    
    % get peak triggered average for all types of traces around movement
    % transitions
    peakMovementCHI = peakTriggeredAverage(traces.chi, movementTransition, radius, normalize);    
    peakMovementMSN = peakTriggeredAverage(traces.msn, movementTransition, radius, normalize);
    peakMovementFSI = peakTriggeredAverage(traces.fsi, movementTransition, radius, normalize);
    peakFluorescence.mvmt = peakTriggeredAverage(speed, movementTransition, radius, 0);
    peakFluorescence.rot = peakTriggeredAverage(rot, movementTransition, radius, 0);
    
    % average everything across all trials
    peakFluorescence.mvmt = nanmean(peakFluorescence.mvmt,2);
    peakFluorescence.rot = nanmean(peakFluorescence.rot,2);
    peakFluorescence.fsi = squeeze(nanmean(peakMovementFSI,2));
    peakFluorescence.chi = squeeze(nanmean(peakMovementCHI,2));
    peakFluorescence.msn = squeeze(nanmean(peakMovementMSN,2));

    % using 40 time point windows, find significantly modulated indices
    [sigInds.msn.pos, sigInds.msn.neg, tstats.msn] = (findSigDifInds(peakFluorescence.msn,40));
    [sigInds.chi.pos, sigInds.chi.neg, tstats.chi] = (findSigDifInds(peakFluorescence.chi,40));
    [sigInds.fsi.pos, sigInds.fsi.neg, tstats.fsi] = (findSigDifInds(peakFluorescence.fsi,40));
    %store for output
    peakfluor.msn = peakMovementMSN;
    peakfluor.fsi = peakMovementFSI;
    peakfluor.chi = peakMovementCHI;
end
