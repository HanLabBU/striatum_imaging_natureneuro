function [activationState] = getActivationStateBroad(suffix, cutoff)
    load(['preMouseData_' suffix '.mat']);
    activationState = findBroadSegments(preMouseData.dff, cutoff, preMouseData.dt);
    disp(['done with ' suffix ]);
%     save(['processedData/activityTraces/activationStateBroad_' suffix '.mat'],'activationState')
end