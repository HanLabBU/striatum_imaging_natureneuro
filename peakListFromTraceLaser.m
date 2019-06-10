function [peakList] = peakListFromTraceLaser(trace, stdThreshold, dt)
%     traceFilt = removeMAMin(trace, 10, 500); %make sure to cite this: n vivo two-photon imaging of sensory-evoked dendritic calcium signals in cortical neurons
    fc = 1/2000; fs = 1;
    Wn = fc/fs*2;
    [b,a] = butter(2,Wn,'high');
    traceFilt = filtfilt(b,a,trace);
    
    
    peakList = identifyPeakIndices(traceFilt, zeros(size(traceFilt)), stdThreshold);
    meanNoPeak = mean(traceFilt(~peakList));
    stdNoPeak = std(traceFilt(~peakList));
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

    if (isempty(peakStarts) && isempty(peakEnds)) || (length(peakStarts) == 1 && length(peakEnds) == 1)
        
    else
        c = nchoosek(1:length(peakStarts),2);
        if any(abs(peakStarts(c(:,1))-peakEnds(c(:,2))) <= 1)
            disp('no');
        end
    end
    peakList = generateBinoFromStartAndEnd(traceFilt, peakStarts, peakEnds);

    
end
