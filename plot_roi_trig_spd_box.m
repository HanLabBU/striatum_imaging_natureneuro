function [X,Xerr] = plot_roi_trig_spd_box(chi,fsi,mvmttype)
[bnorm, ~] = consolidate_roi_triggered_movement(chi,fsi);

X = [];
Xerr = [];
for i=1:length(bnorm.msn)

    X = cat(1,X,[bnorm.chi(i), bnorm.msn(i), bnorm.fsi(i)]);
end

figure
[ax,l] = box_err(X);
labs = {'Pre','Post 1','Post 2','Post 3','Post 4'};
legend(l,{'CHI-triggered','MSN-triggered','FSI-triggered','Location','Southwest'});
set(ax,'XTickLabel',labs);
ylabel('Speed [normalized, proportion change from baseline]');
title(sprintf('ROI triggered %s',mvmttype));
savePDF(gcf,sprintf('figures/%s/roi_triggered_%s_combo_box.pdf',date,mvmttype));

end