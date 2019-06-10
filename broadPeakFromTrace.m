function [peakList] = broadPeakFromTrace(trace,cutoff, dt)
    trace = removeMAMin(trace, 10, 500);
    filttrace = filterBroad(trace); %need to apply SOME sort of filter
    peakList = identifyPeakIndices(filttrace, zeros(size(filttrace)), cutoff);            
    meanNoPeak = mean(trace(~peakList));
    stdNoPeak = std(trace(~peakList));
    peakStarts = find(diff(peakList) == 1);
    peakEnds = find(diff(peakList) == -1);
    
     if isempty(peakStarts) || isempty(peakEnds)
         peakStarts = []; peakEnds = [];
     else
         if peakStarts(1) >= peakEnds(1)
             peakEnds(1) = [];
         end
         if isempty(peakStarts) || isempty(peakEnds)
             peakStarts = []; peakEnds = [];
         elseif peakStarts(end) >= peakEnds(end)
             peakStarts(end) = [];
         end
     end
     if isempty(peakStarts) || isempty(peakEnds)
         peakStarts = []; peakEnds = [];
     end
    [peakStarts, peakEnds] = exceedsMinThreshold(trace, peakStarts, peakEnds, meanNoPeak+5*stdNoPeak);
    
    peakList = generateBinoFromStartAndEnd(filttrace, peakStarts, peakEnds);

end