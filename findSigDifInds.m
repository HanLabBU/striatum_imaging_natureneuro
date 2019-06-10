function [posinds,neginds,zstats] = findSigDifInds(peakList,radius)
    posinds = zeros(size(peakList,2),1);
    neginds = zeros(size(peakList,2),1);
    
    zstats = struct('pos',[],'neg',[]);
    middleind = (size(peakList,1)-1)/2+1;
    firstchunk = (middleind-radius):(middleind-1);
    secondchunk = (middleind+1):(middleind+radius);
    for p=1:size(peakList,2)
        fst = peakList(firstchunk,p);
        scnd = peakList(secondchunk,p);
        if all(isnan(fst)) || all(isnan(scnd))
            pvalPos = nan;
            pvalNeg = nan;
            statspos.zval = nan;
            statsneg.zval = nan;
            error('allnan');
        else
            [pvalPos,~,statspos] = ranksum(peakList(firstchunk,p),peakList(secondchunk,p),'Tail','left');
            [pvalNeg,~,statsneg] = ranksum(peakList(firstchunk,p),peakList(secondchunk,p),'Tail','right');

        end
        if (isnan(pvalPos) || isnan(pvalNeg))
            error('nan pvals');
        end
        posinds(p) = pvalPos < 0.025;
        neginds(p) = pvalNeg < 0.025;
        zstats(p).pos = statspos.zval;
        zstats(p).neg = statsneg.zval;
    end
end