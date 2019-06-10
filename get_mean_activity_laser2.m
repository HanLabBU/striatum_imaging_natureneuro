function mean_activity = get_mean_activity_laser2(metadata,genotype)
activities = struct('msn',[],'tdt',[]);
for m=1:numel(metadata)
    if (strcmp(genotype,'chi') && ~~metadata(m).isCHI) || ...
        (strcmp(genotype,'fsi') && ~metadata(m).isCHI) || strcmp(genotype,'all')
        mousedata = loadMouseLaser(metadata(m));
        act = allRisingLaser(mousedata);
        assert(~any(isnan(sum(act.msn))) && ~any(sum(isnan(act.fsi))) && ~any(sum(isnan(act.chi))),'nans involved');
        activities.msn = cat(1,activities.msn,mean(act.msn,1)');
        activities.tdt = cat(1,activities.tdt,mean(cat(2,act.fsi,act.chi),1)');
    end
end
mean_activity.msn = mean(activities.msn);
mean_activity.tdt = mean(activities.tdt);
end