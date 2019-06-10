function velTriggeredMSNSimultaneousCorrShuffle(suffix, radius,mousetype, cutoff,nreps) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
    mouseData = loadMouse(suffix);
    parpool('local',20);
    parfor n=1:nreps
        peakmvmt = struct('msnin',[],'msnout',[],'intin',[],'intout',[]);
        tic
        for m=1:numel(suffix)
            allMouseData = mouseData(m);
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
            
            traces = jitter_all_traces(traces);
            
            centroids = allCentroids(allMouseData);

            limiting_distance = cutoff; %um

            centroidDist_fsi = pdist2(centroids.fsi, centroids.fsi);
            centroidDist_msn = pdist2(centroids.msn, centroids.msn);
            centroidDist_chi = pdist2(centroids.chi, centroids.chi);

            currmsn = segmentCorr(traces.msn, allMouseData.hiSpdSustainSegs);
            currmsn = cat(2,currmsn,segmentCorr(traces.msn, allMouseData.loSpdSustainSegs));

            [currmsnin, currmsnout] = msnInRadius(currmsn, centroidDist_msn, limiting_distance);
            peakmvmt(m).msnin = currmsnin;
            peakmvmt(m).msnout = currmsnout;

            if strmatch(mousetype,'fsi')
                currfsi = segmentCorr(traces.fsi, allMouseData.hiSpdSustainSegs);
                currfsi = cat(2,currfsi,segmentCorr(traces.fsi, allMouseData.loSpdSustainSegs));
                [currfsiin, currfsiout] = msnInRadius(currfsi,centroidDist_fsi,limiting_distance);
                peakmvmt(m).intin = currfsiin;
                peakmvmt(m).intout = currfsiout;
            else
                currchi = segmentCorr(traces.chi, allMouseData.hiSpdSustainSegs);
                currchi = cat(2,currchi,segmentCorr(traces.chi, allMouseData.loSpdSustainSegs));
                [currchiin, currchiout] = msnInRadius(currchi,centroidDist_chi,limiting_distance);
                peakmvmt(m).intin = currchiin;
                peakmvmt(m).intout = currchiout;
            end
        end
        toc
        saveiter(peakmvmt,mousetype,n);
        fprintf('Done with %d\n',n);
    end
    delete(gcp('nocreate'));
end

function saveiter(peakmvmt,mousetype,n)
    save(sprintf('pearson_shuffles/pearson_shuffle_rep_%s_%d.mat',mousetype,n),'peakmvmt');
end

function [trigFluorIn, trigFluorOut] = msnInRadius(peaktrigcorr, dist, limdist)
dist = dist(tril(true(size(dist)),-1));
inds = find(dist*1.3 < limdist); %find pairs that are within 100 um
%initialize output variables
trigFluorIn = peaktrigcorr(inds,:);
trigFluorOut = peaktrigcorr(setdiff(1:length(dist),inds),:);


end