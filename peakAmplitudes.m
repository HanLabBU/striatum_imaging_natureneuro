function [peakAmps] = peakAmplitudes(peaks)
    peakAmps = cell(numel(peaks),1);
    for roi=1:numel(peaks)
        currROI = peaks{roi};
        currAmps = zeros(numel(currROI),1);
        for currPeak=1:numel(currROI)
            maxVal = max(currROI{currPeak});
            if isempty(maxVal)
                maxVal = nan;
            end
            currAmps(currPeak) = maxVal;
        end
        peakAmps{roi} = currAmps;
    end
end