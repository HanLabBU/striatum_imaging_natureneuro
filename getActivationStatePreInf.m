function [peakMatrix] = getActivationStatePreInf(suffix, cutoff)
    load(['preMouseData_' suffix '.mat'])
    peakMatrix = findDynamicSegments(preMouseData.dff, cutoff, preMouseData.dt);
    disp(['done with' suffix ]);
end