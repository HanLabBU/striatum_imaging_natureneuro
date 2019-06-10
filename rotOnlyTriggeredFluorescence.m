function [peakFluorescence, sigInds, tstats, peakfluor] = rotOnlyTriggeredFluorescence(suffix, radius, noSamples)
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
%     [nhat, phat] = makeCatActivityTraces(suffix);

    allMouseData = loadMouse({suffix});
    speed = allMouseData.speed;
    rot = abs(allMouseData.rot);
    rotTransition2 = findRotPeaksManual(rot, allMouseData.dt);
    rotTransition = findRotPeaksManual2(rot, allMouseData.dt);
    assert(isequaln(rotTransition,rotTransition2));
    rotTransition = indices2Indicator(rotTransition, length(speed));
    movementTransition = rotTransition; %= unsharedWindow(rotTransition,speed,20, cut);
    
    
    fprintf('Number of events: %0.0f\n',sum(movementTransition));
    tracesCHI = allMouseData.tracesCHI;
    tracesCHI = cat(2,tracesCHI, allMouseData.broadTracesCHI);
    tracesMSN = allMouseData.tracesMSN;
    tracesMSN = cat(2, tracesMSN, allMouseData.broadTracesMSN);
    tracesFSI = allMouseData.tracesFSI;
    tracesFSI = cat(2, tracesFSI, allMouseData.broadTracesFSI);
    
    peakMovementCHI = peakTriggeredAverage(tracesCHI, movementTransition, radius, noSamples);    
    peakMovementMSN = peakTriggeredAverage(tracesMSN, movementTransition, radius, noSamples);
    peakMovementFSI = peakTriggeredAverage(tracesFSI, movementTransition, radius, noSamples);
    
    peakFluorescence.mvmt = peakTriggeredAverage(speed, movementTransition, radius, 0);
    peakFluorescence.rot = peakTriggeredAverage(rot, movementTransition, radius, 0);
    
    peakFluorescence.mvmt = nanmean(peakFluorescence.mvmt,2);
    peakFluorescence.rot = nanmean(peakFluorescence.rot,2);

    peakFluorescence.fsi = squeeze(nanmean(peakMovementFSI,2));
    peakFluorescence.chi = squeeze(nanmean(peakMovementCHI,2));
    peakFluorescence.msn = squeeze(nanmean(peakMovementMSN,2));

    [sigInds.msn.pos, sigInds.msn.neg,tstats.msn] = (findSigDifInds(peakFluorescence.msn,40));
    [sigInds.chi.pos, sigInds.chi.neg, tstats.chi] = (findSigDifInds(peakFluorescence.chi,40));
    [sigInds.fsi.pos, sigInds.fsi.neg, tstats.fsi] = (findSigDifInds(peakFluorescence.fsi,40));
    peakfluor.msn = peakMovementMSN;
    peakfluor.fsi = peakMovementFSI;
    peakfluor.chi = peakMovementCHI;
end

function unsharedPoints = unsharedWindow(x,y,window, cut)
    xinds = find(x);
    unsharedPoints = x;
    for i=1:length(xinds)
        xind = xinds(i);
        yinds = max(1,xind-window):min(length(y),xind+window);
        yvals = y(yinds);
        if any(yvals > cut)
            unsharedPoints(xind) = 0;
        end
    end
end