function [peakList] = peakListFromTrace(trace, stdThreshold, dt)
%     traceFilt = filterDynamic(trace);
    traceFilt = removeMAMin(trace, 10, 500); %make sure to cite this: In vivo two-photon imaging of sensory-evoked dendritic calcium signals in cortical neurons
    peakList = identifyPeakIndices(traceFilt, zeros(size(traceFilt)), stdThreshold);
    meanNoPeak = mean(traceFilt(~peakList));
    stdNoPeak = std(traceFilt(~peakList));
%     [peakStarts, peakMaxes, peakEnds] = getPeakInfo(traceFilt, peakList);
    peakStarts = find(diff(peakList) == 1);
    peakEnds = find(diff(peakList) == -1);
    if isempty(peakEnds) || isempty(peakStarts)
        peakList = zeros(size(trace));
        return;
    end
    if peakEnds(1) < peakStarts(1)
        peakEnds(1) = [];
    end
    if peakEnds(end) < peakStarts(end)
        peakStarts(end) = [];
    end
    
    [peakStarts, peakEnds] = exceedsMinThreshold(traceFilt, peakStarts, peakEnds, meanNoPeak+5*stdNoPeak);
    peakList = generateBinoFromStartAndEnd(traceFilt, peakStarts, peakEnds);

    
end
