function [centroids, tags] = plotSigMotionMap(mouseno)
suffix = mouseSuffix(mouseno);
currMouse = loadMouse(suffix);
[~, neurons] = triggeredActivityAll(@dyTriggeredFluorescence,mouseno,50,0);

pos.msn = neurons.pos.msn;
pos.chi = neurons.pos.chi;
pos.fsi = neurons.pos.fsi;

neg.msn = neurons.neg.msn;
neg.chi = neurons.neg.chi;
neg.fsi = neurons.neg.fsi;

centroids = cat(1,currMouse.centroidsMSN,currMouse.centroidsBroadMSN)*1.3;
tags = ones(size(centroids,1),1);
tags(neg.msn) = 2;
tags(pos.msn) = 3;
colorwheel = {[.5 .5 .5],[0 0 0],[1 0 0]};
plotCentroidsBySig(centroids, tags,colorwheel);
legend('Non-modulated','neg','pos');
title(suffix);
savePDF(gcf,sprintf('figures/%s/centroids_posnegmix_%s.pdf',date,mouseno));
end