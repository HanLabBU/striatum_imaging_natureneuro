function [peakMatrix] = getActivationStatePreInfLaser(suffix, cutoff)
    load(['preMouseData_' suffix '.mat'])
    peakMatrix = findDynamicSegmentsLaser(preMouseData.dff, cutoff, preMouseData.dt);
    disp(['done with' suffix ]);
end