function peakMatrix = findBroadSegments(traces,cutoff,  dt)
    numTraces = size(traces,2);
    peakMatrix = zeros(size(traces));
    for i=1:numTraces
        peakMatrix(:,i) = broadPeakFromTrace(traces(:,i),cutoff, dt);
    end
    
end