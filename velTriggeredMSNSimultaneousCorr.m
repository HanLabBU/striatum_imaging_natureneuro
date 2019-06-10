function peakmvmt = velTriggeredMSNSimultaneousCorr(suffix, radius,mousetype, cutoff) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
    for m=1:numel(suffix)
        allMouseData = loadMouse({suffix{m}});
        if strmatch(mousetype,'chi')
            if ~allMouseData.isCHI
                continue
            end
        elseif strmatch(mousetype,'fsi')
            if allMouseData.isCHI
                continue
            end
        end
        
        allMouseData = addSpeedInfo(allMouseData,1,5);
        traces = allFluor(allMouseData);
        centroids = allCentroids(allMouseData);
        
        limiting_distance = cutoff; %um
        
        centroidDist.fsi = pdist2(centroids.fsi, centroids.fsi);
        centroidDist.msn = pdist2(centroids.msn, centroids.msn);
        centroidDist.chi = pdist2(centroids.chi, centroids.chi);
        
        currmsn = segmentCorr(traces.msn, allMouseData.hiSpdSustainSegs);
        currmsn = cat(2,currmsn,segmentCorr(traces.msn, allMouseData.loSpdSustainSegs));
        
        [currmsnin, currmsnout] = msnInRadius(currmsn, centroidDist.msn, limiting_distance);
        peakmvmt(m).msnin = currmsnin;
        peakmvmt(m).msnout = currmsnout;
        
        if strmatch(mousetype,'fsi')
            currfsi = segmentCorr(traces.fsi, allMouseData.hiSpdSustainSegs);
            currfsi = cat(2,currfsi,segmentCorr(traces.fsi, allMouseData.loSpdSustainSegs));
            [currfsiin, currfsiout] = msnInRadius(currfsi,centroidDist.fsi,limiting_distance);
            peakmvmt(m).intin = currfsiin;
            peakmvmt(m).intout = currfsiout;
        else
             currchi = segmentCorr(traces.chi, allMouseData.hiSpdSustainSegs);
            currchi = cat(2,currchi,segmentCorr(traces.chi, allMouseData.loSpdSustainSegs));
            [currchiin, currchiout] = msnInRadius(currchi,centroidDist.chi,limiting_distance);
            peakmvmt(m).intin = currchiin;
            peakmvmt(m).intout = currchiout;
        end
        
        fprintf('Done with %s\n',suffix{m});
    end
end

function [trigFluorIn, trigFluorOut] = msnInRadius(peaktrigcorr, dist, limdist)
dist = dist(tril(true(size(dist)),-1));
inds = find(dist*1.3 < limdist); %find pairs that are within 100 um
%initialize output variables
trigFluorIn = peaktrigcorr(inds,:);
trigFluorOut = peaktrigcorr(setdiff(1:length(dist),inds),:);


end