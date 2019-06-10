function mean_activity = get_mean_synchrony_laser_individual_nonlaser(metadata,genotype)
mean_activity = [];
for m=1:numel(metadata)
    if (strcmp(genotype,'chi') && ~metadata(m).isCHI) || ...
        (strcmp(genotype,'fsi') && ~~metadata(m).isCHI)
        continue
    end
        mousedata = loadMouseLaser(metadata(m));
        act = allRisingLaser(mousedata);
        act.msn = act.msn(~mousedata.laserIndices,:);
        n_msn = size(act.msn,2);
        coactive = sum(act.msn,2);
        mn = (coactive.*(coactive-1)/2)/(n_msn*(n_msn-1)/2);
        mean_activity = cat(1,mean_activity,mean(mn));
end

end