function plot_laser_triggered_mvmt_box(rot,genotype,normalize)
width = size(rot,1);
radius = (width-1)/2;

dt = 0.0469;
tvals = (-radius:radius)*dt;
tval_bins = [-0.001 0:.5:2];
bin = discretize(tvals,tval_bins,'IncludedEdge','right');

nbins = numel(unique(bin(~isnan(bin))));
X = zeros(nbins,size(rot,2));
for i=1:nbins
    X(i,:) = nanmean(rot(bin == i,:),1);
end

% now, plot bar_w_err
if normalize
    X2 = X/abs(nanmean(X(1,:),2))-1;
    X2 = X2*100;
    box_err(num2cell(X2,2))
    ylabel('Pct over baseline');
else
    box_err(num2cell(X,2))
end
xlabel('Time from laser onset');
title(sprintf('Mean +/- SEM, %s, nevents=%d',genotype,size(X,2)));
end