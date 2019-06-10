suffix = '2565CARB';

load(['roi_pre_' suffix '.mat']);
load(['max_frames_' suffix '.mat']);
load(['max_frames_' suffix '_new.mat']);
maxPre = max(cat(3,stats.max),[],3);
minPre = min(cat(3,stats.min),[],3);
load(['dynamic_indices_' suffix '.mat']);
load(['broad_indices_' suffix '.mat']);

all_indices = sort(cat(1,broadIndices(:), dynamicIndices(:)));

R = R(all_indices);

for r=1:numel(R)
    R(r).isPVI = false;
    R(r).isChI = false;
end

figure
fig1 = plotOverlayContrastAdjustOld(R,maxPre-minPre);
ylim([400.9492 685.4570])
xlim([374.2422 658.7500])

figure
imshow(maxPre-minPre,[0 80]);
ylim([562.4673  648.5976]);
xlim([437.7513  523.8816]);
Rnew = rois_in_area(R, xlim, ylim);
hold on;
[f, ftr] = plot_rois_with_traces(Rnew,gca);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
savePDF(f,sprintf('figures/%s/roi_example_zoomin.pdf',date));
savePDF(ftr,sprintf('figures/%s/roi_example_traces.pdf',date));
figure(fig1);
hold on;
plot_rois_with_traces(Rnew,gca);
set(gca,'XTickLabel',[]);
set(gca,'YTickLabel',[]);
figure(fig1);
xlim([0 1024]); ylim([0 1024]);
savePDF(fig1,sprintf('figures/%s/roi_example_zoomout.pdf',date));