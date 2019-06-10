function [peakStarts, peakEnds] = findPeaksManual(vel, dt)
    peakStarts = [];
    peakEnds = [];
    LENPEAK = 10;
    LENBASELINE = 10;%10;
    MAXHEIGHTBASE = 5;%5;
    MINHEIGHTPEAK = 40; %15;

    taxis = dt*(1:length(vel));
    numSegsTotal = 0;
    indMat = (vel < MAXHEIGHTBASE);
    if indMat(1)
        indMat(1) = 0;
    end
    peakStartMat = find(diff(indMat) == -1)-1;
    for segment = 1:length(peakStartMat) % for each positive slope segment
        segStart = peakStartMat(segment);
        segEnd = min(length(vel),segStart + LENPEAK);

% make sure that time points after acceleration remain above
        if hasMaxBaseline(MAXHEIGHTBASE, vel(max(1,(segStart-LENBASELINE)):segStart))
            currPeakRegion = vel(max(1,(segStart-LENBASELINE)):min(length(vel),segEnd+LENPEAK));
            if max(currPeakRegion) > MINHEIGHTPEAK
                numSegsTotal = numSegsTotal + 1;
                peakStarts = cat(1,peakStarts,segStart);%+minIndex-1);
                peakEnds = cat(1, peakEnds,findPeakEnd(segEnd,indMat));
            end
        end
    end
end

function peakEnd = findPeakEnd(ind, indMat)
diffmat = find(diff(indMat) == -1);
diffmat(diffmat <= ind) = [];
if isempty(diffmat)
    peakEnd = length(indMat);
    return
end
peakEnd = min(diffmat);
end

function segments = posSlopeSegs(x)
    segments = activeSegments(diff(x) > 0);
    segments =  segments{1};
end

function hasSlope = hasMinSlope(minVal, dx)
    if max(dx) > minVal
        hasSlope = true;
    else
        hasSlope = false;
    end
end

function hasBaseline = hasMinBaseline(minVal, baseline)
    if all(baseline >= minVal)
        hasBaseline = true;
    else
        hasBaseline = false;
    end
end

function hasBaseline = hasMaxBaseline(maxVal,baseline)
    if all(baseline <= maxVal)
        hasBaseline = true;
    else
        hasBaseline = false;
    end
end

function hasVar = hasSufficientVar(firstVal,baseline)
    if sum(baseline-firstVal) < 5
        hasVar = true;
    else
        hasVar = false;
    end
end