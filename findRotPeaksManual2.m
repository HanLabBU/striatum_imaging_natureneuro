function peakStarts = findRotPeaksManual2(rot, dt)
    peakStarts = [];
    LENPEAK = 10;
    LENBASELINE = 10;%10;
    MAXHEIGHTBASE = .5;%5;
    MINHEIGHTPEAK = 2; %15;

    taxis = dt*(1:length(rot));
    numSegsTotal = 0;
    indMat = (rot < MAXHEIGHTBASE);
    peakStartMat = find(diff(indMat) == -1)-1;
%     assert(all(peakStartMat > 0),'peak start is before 0!!!');
    peakStartMat(peakStartMat < 1) = [];
    for segment = 1:length(peakStartMat) % for each positive slope segment
        segStart = peakStartMat(segment);
        segEnd = min(length(rot),segStart + LENPEAK);

% make sure that time points after acceleration remain above
        if hasMaxBaseline(MAXHEIGHTBASE, rot(max(1,(segStart-LENBASELINE)):segStart))
%                     make sure that acceleration peak exceeds value
            currPeakRegion = rot(max(1,(segStart-LENBASELINE)):min(length(rot),segEnd+LENPEAK));
            if max(currPeakRegion) > MINHEIGHTPEAK
                numSegsTotal = numSegsTotal + 1;
                % find the lowest point in the acceleration period
                xseg = rot(segStart:segEnd);
                [~,minIndex] = min(xseg);
                peakStarts = cat(1,peakStarts,segStart);%+minIndex-1);
%                     
            end
        end
    end
%     figure; 
%     plot(taxis, vel,'b');
%     hold on;
%     plot(taxis(peakStarts),vel(peakStarts),'.r','MarkerSize',10);
%     fprintf(' %d segments\n', numSegsTotal);
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