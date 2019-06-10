function peakStarts = findValleysManual(vel, dt)
    peakStarts = [];
    LENPEAK = 10;
    LENBASELINE = 10;
    MAXHEIGHTBASE = 5;
    MINHEIGHTPEAK = 15;
    numSegsTotal = 0;
    indMat = (vel > MAXHEIGHTBASE);
    peakStartMat = find(diff(indMat) == -1); % data point just before it drops below threshold speed (5)
    for segment = 1:length(peakStartMat) % for each positive slope segment
        segStart = peakStartMat(segment);
        segEnd = min(length(vel),segStart + LENPEAK);
        currPeakStart = vel(max(1,(segStart-LENBASELINE)):segStart); % 11 time point start
% make sure that time points after acceleration remain above
        if max(currPeakStart) > MINHEIGHTPEAK % this area must exceed 15
            if hasMaxBaseline(MAXHEIGHTBASE, vel(segStart+1:min(length(vel),segEnd)))   
                numSegsTotal = numSegsTotal + 1;
                peakStarts = cat(1,peakStarts,segStart);
            end
        end

    end
end

function hasBaseline = hasMaxBaseline(maxVal,baseline)
    if all(baseline <= maxVal)
        hasBaseline = true;
    else
        hasBaseline = false;
    end
end
