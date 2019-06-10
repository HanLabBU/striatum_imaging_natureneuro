function eps = eventsPerSecSegs(actState, dt, segs)
actState = diff(actState,[],1) == 1;
actState = cat(1,zeros(1,size(actState,2)),actState);
actStateSegs = [];
for j=1:size(segs,1)
    actStateSegs = cat(1,actStateSegs, actState(segs(j,1):segs(j,2),:));
end
% eps = eventsPerSec(actStateSegs, dt);
eps = mean(actStateSegs)/dt;
end