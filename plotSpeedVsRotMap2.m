function [centroids, tags] = plotSpeedVsRotMap2(mouseno)
suffix = mouseSuffix(mouseno);
currMouse = loadMouse(suffix);
[~, neurons] = neuron_rotclassification3(mouseno);

mix.msn = neurons.mix.msn;
mix.chi = neurons.mix.chi;
mix.fsi = neurons.mix.fsi;

speed.msn = neurons.speed.msn;
speed.chi = neurons.speed.chi;
speed.fsi = neurons.speed.fsi;

rot.msn = neurons.rot.msn;
rot.chi = neurons.rot.chi;
rot.fsi = neurons.rot.fsi;

centroids = allCentroids(currMouse);
centroids = cat(1,centroids.msn,centroids.chi,centroids.fsi)*1.3;
tags = ones(size(centroids,1),1);
mix_all = cat(1,mix.msn,mix.chi,mix.fsi);
rot_all = cat(1,rot.msn,rot.chi,rot.fsi);
spd_all = cat(1,speed.msn,speed.chi,speed.fsi);
tags(~~mix_all) = 2;
tags(~~rot_all) = 3;
tags(~~spd_all) = 4;

colorwheel = {[.5 .5 .5],[0 0 0],[0 0 1],[1 0 0]};
plotCentroidsBySig(centroids, tags,colorwheel);
legend('Non-modulated','mix','rotation','speed');
title(suffix);
savePDF(gcf,sprintf('figures/%s/centroids_speedrotmix_%s.pdf',date,mouseno));
end