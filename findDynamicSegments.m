
% takes three arguments: a samples x roi traces matrix, a
% threshold number of standard deviations for the cutoff, and a length of time between samples
% (1/Fs). Returns a binary matrix of 1s and 0s, each index corresponding to the same index in
% the traces matrix
function peakMatrix = findDynamicSegments(traces, stdThreshold, dt)
    numTraces = size(traces,2);
    peakMatrix = zeros(size(traces));
    for i=1:numTraces
        peakMatrix(:,i) = peakListFromTrace(traces(:,i), stdThreshold, dt);
    end

end
