function sortTracesLaser(metadata)
% done with first 10
for m = 1:numel(metadata)
    load(['preMouseData_' metadata(m).suffix '.mat']);
    load(['activation_state_dynamic_' metadata(m).suffix '.mat']);
    load(['activation_state_broad_' metadata(m).suffix '.mat']);
    laserstart = [0; diff(preMouseData.laserIndices) == 1];
    laserend = [diff(preMouseData.laserIndices) == -1; 0];
    assert(preMouseData.laserIndices(1) ~= 1 && preMouseData.laserIndices(end) ~= 1,'laserstart and end wont work');
    traces = preMouseData.dff;
    [dynamicIndices, nonDynamicIndices] = markBadTraces2Laser(traces, 'Select non-dynamic',laserstart,laserend);
    save(sprintf('processedData/traceSelectionLaser/dynamic_indices_%s.mat',metadata(m).suffix),'dynamicIndices');
    [laserIndicesIndices, nonLaserIndicesIndices] = markBadTraces2Laser(traces(:,nonDynamicIndices),'Select non-laser',laserstart,laserend);
    
    laserIndices = nonDynamicIndices(laserIndicesIndices);
    nonLaserIndices = nonDynamicIndices(nonLaserIndicesIndices);
    
    save(sprintf('processedData/traceSelectionLaser/laser_indices_%s.mat',metadata(m).suffix),'laserIndices');
    
    [ broadIndicesIndices, nonbroadindicesindices] = markBadTraces2Laser(traces(:,nonLaserIndices), 'Select non-broad',laserstart,laserend);
    broadIndices = nonLaserIndices(broadIndicesIndices);
    save(sprintf('processedData/traceSelectionLaser/broad_indices_%s.mat',metadata(m).suffix),'broadIndices');

    nonBroadIndices = nonLaserIndices(nonbroadindicesindices);
    if isempty(nonBroadIndices)
        conjIndicesIndices = [];
        nonconjindices = [];
    else
        [conjIndicesIndices, nonconjindices] = markBadTraces2Laser(traces(:,nonBroadIndices), 'Select non-conjunctive',laserstart,laserend);
    end
    conjIndices = nonBroadIndices(conjIndicesIndices);
    save(sprintf('processedData/traceSelectionLaser/conj_indices_%s.mat',metadata(m).suffix),'conjIndices');
    junkIndices = nonBroadIndices(nonconjindices);
    save(sprintf('processedData/traceSelectionLaser/junk_indices_%s.mat',metadata(m).suffix),'junkIndices');

    fprintf('Done with %s\n',metadata(m).suffix);
end
