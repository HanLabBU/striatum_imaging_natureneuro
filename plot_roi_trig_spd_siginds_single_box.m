function [X] = plot_roi_trig_spd_siginds_single_box(roi,mvmttype,roitype)
% group speed and label data by time bin
[bnorm, ~] = consolidate_roi_triggered_movement_single(roi);

X = {};

% for each cell type, concatenate mean and standard error in each bin
for i=1:length(bnorm.pos)
    X = cat(1,X,[bnorm.pos(i) bnorm.neg(i)]);

end

% plot percentage change from baseline instead of proportion change
figure
[ax,l] = box_err(X);
labs = {'Pre','Post 1','Post 2','Post 3','Post 4'};
legend(l,{'Positively modulated','Negatively modulated'},'Location','Southwest');
set(ax,'XTickLabel',labs);
ylabel('Speed [normalized, prop change from baseline]');
title(sprintf('%s triggered %s',upper(roitype),mvmttype));
savePDF(gcf,sprintf('figures/%s/roi_triggered_%s_combo_siginds_%s_box.pdf',date,mvmttype,roitype));

end