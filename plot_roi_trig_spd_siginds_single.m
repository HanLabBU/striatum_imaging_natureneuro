function [X,Xerr] = plot_roi_trig_spd_siginds_single(roi,mvmttype,roitype)
% group speed and label data by time bin
[bnorm, ~] = consolidate_roi_triggered_movement_single(roi);

X = [];
Xerr = [];

% for each cell type, concatenate mean and standard error in each bin
for i=1:length(bnorm.pos)
    X = cat(1,X,[nanmean((bnorm.pos{i})),nanmean((bnorm.neg{i}))]);
    Xerr = cat(1,Xerr,[serrMn((bnorm.pos{i})'), serrMn((bnorm.neg{i})')]);

end

% plot percentage change from baseline instead of proportion change
figure
bar_err(1:numel(bnorm.pos),X*100, Xerr*100, Xerr*100);
labs = {'Pre','Post 1','Post 2','Post 3','Post 4'};
legend('Positively modulated','Negatively modulated','Location','Southwest');
set(gca,'XTickLabel',labs);
ylabel('Speed [normalized, % change from baseline]');
title(sprintf('%s triggered %s',upper(roitype),mvmttype));
savePDF(gcf,sprintf('figures/%s/roi_triggered_%s_combo_siginds_%s.pdf',date,mvmttype,roitype));

end