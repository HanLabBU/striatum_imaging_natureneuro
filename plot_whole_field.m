function plot_whole_field(mouseno)
load(['max_frames_' mouseno '.mat']);

load(['max_frames_' mouseno '_new.mat'])
maxPre = max(cat(3,stats.max),[],3);
minPre = min(cat(3,stats.min),[],3);
load(['roi_pre_' mouseno '.mat']);
load(['tdt_shift_' mouseno '.mat'])
maxTDT = imtranslate(maxTDT,[totalXShift totalYShift]);


plotOverlayContrastAdjustOld([],maxPre-minPre);
savePDF(gcf,['figures/' date '/whole_field_example_norois_original_' mouseno '.pdf']);


% plotOverlayContrastAdjustOld(R, maxTDT);
% title([mouseno ' chis labeled']);
% savePDF(gcf,['figures/' date '/whole_field_example_tdt_' mouseno '.pdf']);


plotOverlayContrastAdjustOld(R, maxPre-minPre);
title([mouseno ' msns and chis labeled']);
savePDF(gcf,['figures/' date '/whole_field_example_with_chi_original_' mouseno '.pdf']);

% 
% plotOverlayContrastAdjustOld(R([R.isChI]), maxTDT);
% title([mouseno ' chis labeled']);
% savePDF(gcf,['figures/' date '/whole_field_example_tdt_chionly_' mouseno '.pdf']);

Rtemp = R;
for i=1:numel(Rtemp)
    Rtemp(i).isChI = false;
end

plotOverlayContrastAdjustOld(Rtemp, maxPre-minPre);
title([mouseno ' msns labeled']);
savePDF(gcf,['figures/' date '/whole_field_example_roiselection_processing_original_' mouseno '.pdf']);


end