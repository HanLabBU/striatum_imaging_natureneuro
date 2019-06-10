function eps = eventsPerSec(activityTrace, dt)
    diffAct = [zeros(1,size(activityTrace,2)); diff(activityTrace,[],1)] == 1;
    eps = mean(diffAct)/dt;
end