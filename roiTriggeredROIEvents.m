function [peakmvmt, stats] = roiTriggeredROIEvents(suffix, radius, noSamples, activityBool, roitype,mousetype, preinds, postinds) % movementCutoff should be 50 as per balltest2
% pass in the suffix of the mouse for which you want to get movement
% triggered ROI activity. must also pass in a vector with the good ROIs for
% this suffix, and a radius for this trace. Also, must have an nhat_cat_
% for the particular mouse/condition. These can be obtained by running:
    if nargin < 7
    preinds = 41:50; postinds = 52:61;
    end
    innerstruct = struct('mn',zeros(2*radius+1,1),'m2',zeros(2*radius+1,1),'n',0);
    stats.msn = innerstruct;
    stats.chi = innerstruct;
    stats.fsi = innerstruct;
    
    for m=1:numel(suffix)
        allMouseData = loadMouse({suffix{m}});
        if strcmpi(mousetype,'chi') && ~allMouseData.isCHI
            fprintf('Skipping %s\n',suffix{m});
            continue;
        elseif strcmpi(mousetype,'fsi') && allMouseData.isCHI
            fprintf('Skipping %s\n',suffix{m});
            continue;
        end
        
        act = allRising(allMouseData);
        
        transition = diff(act.(roitype),[],1) == 1;
        
        if nargin > 3 && activityBool
            traces = act;
        else
            traces = allFluor(allMouseData);
        end
                
        nevents.msn = nansum(nansum(transition(radius+1:end-radius,:))*(size(traces.msn,2)-strcmpi('msn',roitype)));
        nevents.fsi = nansum(nansum(transition(radius+1:end-radius,:))*(size(traces.fsi,2)-strcmpi('fsi',roitype)));
        nevents.chi = nansum(nansum(transition(radius+1:end-radius,:))*(size(traces.chi,2)-strcmpi('chi',roitype)));
        
        peakMovement.fsi = zeros(2*radius+1,1);
        peakMovement.msn = zeros(2*radius+1,1);
        peakMovement.chi = zeros(2*radius+1,1);
        peak.pre = [];
        peak.post = [];
        
        for c=1:size(transition,2)
            curr.chi = peakTriggeredAverage(traces.chi, transition(:,c), radius, noSamples);
            curr.msn = peakTriggeredAverage(traces.msn, transition(:,c), radius, noSamples);
            curr.fsi = peakTriggeredAverage(traces.fsi, transition(:,c), radius, noSamples);
            
            curr.(roitype)(:,:,c) = nan;
            curr.msn = reshape(curr.msn,radius*2+1,[]);
            curr.chi = reshape(curr.chi,radius*2+1,[]);
            curr.fsi = reshape(curr.fsi,radius*2+1,[]);

            peak.pre = cat(1,peak.pre, nanmean(curr.msn(preinds,:),1)');
            peak.post = cat(1,peak.post, nanmean(curr.msn(postinds,:),1)');
            if ~activityBool
                stats = updateStats(stats, curr);
            end
            peakMovement.fsi = peakMovement.fsi + (nansum(curr.fsi,2));
            peakMovement.msn = peakMovement.msn + (nansum(curr.msn,2));
            peakMovement.chi = peakMovement.chi + (nansum(curr.chi,2));
        end
        
        peakmvmt(m).nevents = nevents;
        peakmvmt(m).fsi = peakMovement.fsi;
        peakmvmt(m).msn = peakMovement.msn;
        peakmvmt(m).chi = peakMovement.chi;
        peakmvmt(m).pre = peak.pre;
        peakmvmt(m).post = peak.post;
        fprintf('Done with %s\n',suffix{m});
    end
end

function stats = updateStats(stats,currdata)
    fields = fieldnames(currdata);
    for f=1:numel(fields)
        cdata = currdata.(fields{f});
        stats.(fields{f}) = online_variance(stats.(fields{f}), cdata);
    end
end