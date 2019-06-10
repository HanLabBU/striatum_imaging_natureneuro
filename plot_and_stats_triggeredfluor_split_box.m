function [pvals, stat] = plot_and_stats_triggeredfluor_split_box(fun_handle, inttype,tit_le,fi)

[~, sigInds1] = triggeredActivityAll(@dyTriggeredFluorescence, 'good', 50, 0);

[act1] = triggeredActivityAll(fun_handle, 'good', 100, 0);
plotMvmtTrigActSigInds3(act1,inttype,sigInds1,sprintf('Time from %s [s]',tit_le));
savePDF(gcf,sprintf('figures/%s/%striggeredfluorescence_%sonly.pdf',date,strrep(tit_le,' ','_'),inttype));

figure
[act1] = triggeredActivityAll(fun_handle, 'good', 50, 0);
% plot bar graph and acquire statistics
[pvals, stat] = compareEventTriggeredSigIndsBox(act1,act1,sigInds1,inttype,40);
savePDF(gcf,sprintf('figures/%s/%striggeredfluorescence_%sonly_box.pdf',date,strrep(tit_le,' ','_'),inttype));

fprintf(fi,'\n-----------------------------------------------------\n');
fprintf(fi,'Event triggered fluorescence\n');
fprintf(fi,'4*0.469 seconds before event vs. 4*0.469 seconds after\n');
fprintf(fi,'%s-triggered fluorescence, %ss only\n',tit_le,upper(inttype));
addTriggeredFluorescence(fi,stat, pvals)


end