%% revisions all

fi= fopen(sprintf('processedData/statistics/stat_summary_original_data_%s.txt',date),'a');
% before: runMainAllMice
%% Figure 1D
plot_roizoom_example
plot_whole_field('7136AMPH042216');

% cell counts: gets number of rois of all types and standard error of mean
cc = getCellCounts('good');
fi2= fopen(sprintf('processedData/statistics/stat_summary_mousecounts.csv'),'w');
writeCellCounts2CSV(fi2,cc);
writeCellCounts2Fi(fi,cc);

% gets number of movement events. Movement onset, offset, vmax, hi speed,
% and low speed
mc = getMvmtCounts('good');
writeMvmtCounts2Fi(fi,mc);

% mean bout length: newly added
bouts = mean_bout_length(fi,'good');
figure;
bout_len = (diff(bouts,[],2)+1)*0.0469;
hist((diff(bouts,[],2)+1)*0.0469,50);
ylabel('Count');
xlabel('Bout length [s]');
title(sprintf('%0.2f +/- %0.2f (SEM) seconds, N = %d',mean(bout_len), serrMn(bout_len), length(bout_len)));
savePDF(gcf,sprintf('figures/%s/bout_length.pdf',date));

plot_example_traces('good');
close all

makeFigure1('689ACSF092515');
cc = getCellCounts('689ACSF092515');
writeCellCounts2Fi(fi,cc);


%% Figure 2
epsData = compareEPSComboBox('good'); %done 
savePDF(gcf,sprintf('figures/%s/eventsperssecond.pdf',date));
[anstat] = computeSummStatHiLo(epsData);
% plot_hist_differences(epsData,'EventsPerSec');
writeSSToFile(fi,anstat,'Events per second');

aucData = compareAUCComboBox('good',1,5); %entire peak must be in segment
savePDF(gcf,sprintf('figures/%s/area_under_curve.pdf',date));
[anstat] = computeSummStatHiLo(aucData);
% plot_hist_differences(aucData,'AreaUnderCurve');
writeSSToFile(fi,anstat,'Area under the curve');

paData = comparePeakAmpsComboBox('good',1,5);
savePDF(gcf,sprintf('figures/%s/peak_amplitude_box.pdf',date));
[anstat] = computeSummStatHiLo(paData);
% plot_hist_differences(paData,'PeakAmplitude');
writeSSToFile(fi, anstat,'Peak amplitude');
close all;


% now look at rise times
rtData = compareRiseTimesComboBox('good', 1, 5);
savePDF(gcf,sprintf('figures/%s/rise_times_box.pdf',date));
[anstat] = computeSummStatHiLo(rtData);
writeSSToFile(fi, anstat,'Rise Times [s]');

% now look at peak widths
pwData = comparePeakWidthsComboBox('good', 1, 5);
savePDF(gcf,sprintf('figures/%s/peakwidth_boxplot.pdf',date));
[anstat] = computeSummStatHiLo(pwData);
writeSSToFile(fi, anstat,'Peak widths [s]');
close all
%%

makeFigure1('7909BL2');
cc = getCellCounts('7909BL2');
fprintf(fi,'-----------------------------------\n');
fprintf(fi,'Cell counts for false color image with all neurons\n');
fprintf(fi,'Num MSN, all: %d \n', cc.msn);
fprintf(fi,'Num FSIs,all: %d \n', cc.fsi);
fprintf(fi,'-----------------------------------\n');
close all
plotAllMousePaths
close all


%% Figure 3
%% triggered activity with longer windows %DONE WITH WRITEUP
    
[act1, sigInds1] = triggeredActivityAll(@dyTriggeredFluorescence, 'good', 200, 0);
plotMvmtTrigAct(act1,'Time from movement onset [s]')
savePDF(gcf,sprintf('figures/%s/onset_triggered_fluorescence_200.pdf',date));

figure;
[act1, sigInds1] = triggeredActivityAll(@dyTriggeredFluorescence, 'good', 50, 0);
[pv1, stat1, pre, post] = compareEventTriggeredBox(act1,act1,40);
savePDF(gcf,sprintf('figures/%s/onset_triggered_fluorescence_box.pdf',date));
fprintf(fi,'\n-----------------------------------------------------\n');
fprintf(fi,'Event triggered fluorescence\n');
fprintf(fi,'4*0.469 seconds before event vs. 4*0.469 seconds after\n');
fprintf(fi,'Acceleration-triggered\n');
addTriggeredFluorescence(fi,stat1, pv1)

[act3, sigInds3] = triggeredActivityAll(@velTriggeredFluorescence, 'good', 200, 0);
plotMvmtTrigAct(act3,'time from peak velocity [s]');
savePDF(gcf,sprintf('figures/%s/peakvelocity_triggered_fluorescence_200.pdf',date));

%% now look at peak velocity triggered fluorescence more closely
[peakfluor, mouseid,roiid,eventid] = velTriggeredFluorescence2MEM('good', 100);  
tbl = make_vel_triggered_MEM_time(peakfluor,mouseid,roiid, eventid);
mdl = fitlme(tbl,'Fluor~TimeBin*CellType+(1|EventID)+(1|ROIID)+(1|MouseID)'); 
celltypes = {'fsi','msn','chi'};
for m=1:numel(celltypes)
    mdl2.(celltypes{m}) = fitlme(tbl(tbl.CellType == nominal(celltypes{m}),:),'Fluor~TimeBin+(1|ROIID)+(1|MouseID)+(1|EventID)'); 
end
write_peakvel_mems(fi,mdl,mdl2);
plotMvmtTrigAct(peakfluor,'Time relative to velocity peak')
savePDF(gcf,sprintf('figures/%s/peakvelocity_triggered_fluorescence_event.pdf',date));
plot_bin_vals_peakfluor_rescaled_box(peakfluor,'Time from velocity peak [s]');
savePDF(gcf,sprintf('figures/%s/peakvelocity_triggered_fluor_box.pdf',date));

close all

%% now try it differently
x.msn = cell(0);
x.fsi = cell(0);

suffix = mouseSuffix('good');
for m=1:numel(suffix)
   act1 = dyTriggeredFluorescence(suffix{m}, 50, 0);
   x.msn = cat(2,x.msn,{nanmean(act1.msn,2)});
   x.fsi = cat(2,x.fsi,{nanmean(act1.fsi,2)});
end

t.pv = cellfun(@(q) find(q >= 0.02,1,'first'),x.fsi,'uniformoutput',false);
t.msn = cellfun(@(q) find(q >= 0.02,1,'first'), x.msn,'uniformoutput',false);

diffs = cellfun(@(w,y) w-y,t.msn,t.pv,'uniformoutput',false);
mndiff = cat(1,diffs{:});

fprintf(fi,'Number of sessions where threshold was reached in both\n');
fprintf(fi,'%d sessions\n',numel(mndiff));
fprintf(fi,'mean difference: %0.4f, serrMn: %0.4f seconds\n',mean(mndiff*0.0469), serrMn(mndiff*0.0469));

%% now 

[act1, sigInds1] = triggeredActivityAll(@dyPreOnsetTriggeredFluorescence, 'good', 10, 0);
st = pairwise_fishertest(sigInds1.pos);

mn.fsi = mean(sigInds1.pos.fsi);
mn.msn = mean(sigInds1.pos.msn);
mn.chi = mean(sigInds1.pos.chi);
ser.fsi = sqrt(mn.fsi*(1-mn.fsi)/sum(~isnan(sigInds1.pos.fsi)));
ser.msn = sqrt(mn.msn*(1-mn.msn)/sum(~isnan(sigInds1.pos.msn)));
ser.chi = sqrt(mn.chi*(1-mn.chi)/sum(~isnan(sigInds1.pos.chi)));

bar_err(1:3,[mn.fsi mn.msn mn.chi], [ser.fsi ser.msn, ser.chi]);
set(gca,'XTickLabel',{'FSI','MSN','chi'});
ylabel('Proportion of neurons positive modulated');
savePDF(gcf,sprintf('figures/%s/prop_neurons_pos_modulated_prior_to_movement.pdf',date));
print_pairwise_fishertest(fi,st,sigInds1.pos);

%%
%%%% fluorescence vs movement Kruskal-wallis tests
[flAll] = dff_vs_rotation('good');
savePDF(gcf,sprintf('figures/%s/dff_vs_rot.pdf',date));
fprintf(fi,'\nRotation vs fluorescence\n');
fluor_vs_mvmt_stats(fi,flAll);

[flAll2] = dff_vs_velocity('good');
savePDF(gcf,sprintf('figures/%s/dff_vs_vel.pdf',date));
fprintf(fi,'\nVelocity vs fluorescence\n');
fluor_vs_mvmt_stats(fi,flAll2);

[flAll3] = dff_vs_accel('good');
savePDF(gcf,sprintf('figures/%s/dff_vs_accel.pdf',date));
fprintf(fi,'\nAcceleration vs fluorescence\n');
fluor_vs_mvmt_stats(fi,flAll3);




%% Figure 4

plotMousePSTH({'263ACSF110815'});
plotSigMotionMap('263ACSF110815');
plotSpeedVsRotMap2('2565CARB');
compareRotationValues('good');
savePDF(gcf,sprintf('figures/%s/rotation_distribution_all.pdf',date));

stats = single_neuron_dytrigfluor3('263ACSF110815',1);
fprintf(fi,'-----------------------------------\n');
fprintf(fi,'Cell counts for false color image with positive /negative mouse\n');
fprintf(fi,'Num MSNs, pos-neg: %d \n', sum(stats.cdata.msn.pos | stats.cdata.msn.neg));
fprintf(fi,'Num FSIs, pos-neg: %d \n', sum(stats.cdata.fsi.pos | stats.cdata.fsi.neg));
fprintf(fi,'Num CHIs, pos-neg: %d \n', sum(stats.cdata.chi.pos | stats.cdata.chi.neg));
fprintf(fi,'MSNs all: %d\n',length(stats.cdata.msn.pos));
fprintf(fi,'FSIs all: %d\n',length(stats.cdata.fsi.pos));
fprintf(fi,'CHIs all: %d\n',length(stats.cdata.chi.pos));

fprintf(fi,'-----------------------------------\n');

stats = neuron_rotclassification3('good',1); % neuron_rotclassification4 has different measure for clustering
print_neuron_rotclassification3(fi,stats);

%for next line: need to add line that computes # correlated, etc. may be
%different for different types of neurons.
stats = single_neuron_dytrigfluor3('good',0); %  single_neuron_dytrigfluor4 has different measure for clustering
plot_single_neuron_dytrig2(stats.cdata);
print_single_neuron_trig_fluor2(fi,stats);


%% Figure 5

mouse1 = '6028AMPH021516';
% mouse2 = '7212ACSF050416';
[p_val1,w1] = corr_matrix(mouse1,1); % w is for within 100 um
fprintf(fi,'---------------------------------------------\n');
fprintf(fi,'Figure 5Fi and 5Fii\n');
fprintf(fi,'Difference between near clusters and far clusters\n\n');
fprintf(fi,'Test: Rank-sum\n');
fprintf(fi, '%s, clusters=%d, p-value: %d, w=%d, n=(%d,%d)\n', mouse1,w1,p_val1.pv,p_val1.st.ranksum,p_val1.st.nx,p_val1.st.ny);
fprintf(fi,'---------------------------------------------\n\n');

% simulate: generateShufflesRising2.m
% find corrcoeff: meanPairwiseAssymCorr2.m
% corrcoeff = consolidateACorrData('good','_rp2');
load('acorrdata_consolidated_rp2_cellids.mat');
mice = {'4003SCOP2', '4539BL', '7136ACSF050616'};
plotAllCorrScatter(mice);
plotCorr3dhist(corrcoeff,1,1);
overallCorrBarErr(corrcoeff);
savePDF(gcf,sprintf('figures/%s/overall_significantly_correlated.pdf',date));

d.mm = corrcoeff.mm.d(corrcoeff.mm.p < 0.05);
d.mf = corrcoeff.mf.d(corrcoeff.mf.p < 0.05);
d.mc = corrcoeff.mc.d(corrcoeff.mc.p < 0.05);

fprintf(fi,'Median distance, M-M: %d um\n',nanmedian(d.mm));
fprintf(fi,'Median distance, M-F: %d um\n',nanmedian(d.mf));
fprintf(fi,'Median distance, M-C: %d um\n',nanmedian(d.mc));
[~,y,lbls] = make_dummy_mat(d.mm,d.mf,d.mc);
[st.p,st.tbl,st.st] = kruskalwallis(y,lbls);
st.df = st.tbl{2,3}; st.chi2 = st.tbl{2,5};
fprintf(fi,'Kruskal-Wallis, median distances: X2(2)=%d,p=%d\n',st.chi2,st.p);
c = multcompare(st.st);
c = table(c(:,1),c(:,2),c(:,6),'VariableNames',{'Grp1','Grp2','pval'});
labels.row = {'M-M','M-F','M-C'};
labels.col = labels.row;
appendTable(fi,c,labels);

stats = plotCoefByDistanceBox(corrcoeff, 0);
savePDF(gcf,sprintf('figures/%s/corrcoeff_vs_dist.pdf',date));
fprintf(fi, '-----------------------------------------------\n');
fprintf(fi, 'Comparing correlation coefficients vs distance\n');
writeCorrCoeff2Fi(fi,stats);
fprintf(fi, '-----------------------------------------------\n');


stats = overallCorrBarErr(corrcoeff);
% write these statistics to the file
add_overall_corr2file(fi,stats);

stats = overallCorrCoeffBarBox(corrcoeff);
savePDF(gcf,sprintf('figures/%s/corrcoeffbar_box.pdf',date));
fprintf(fi,'-------------------------------------------------\n');
fprintf(fi,'Comparing correlation coefficients directionally\n');
fprintf(fi,'%sCHI2 = \n',stats.kw.tbl{2,5});
fprintf(fi,'%s\n','Kruskal-Wallis');
fprintf(fi,'df=%d; p-value=%d\n',stats.kw.tbl{2,3},stats.kw.p);
labs.col = stats.labels;
labs.row = stats.labels;
fprintf(fi,'Pairwise comparisons, holm-bonferroni corrected\n');
fprintf(fi,'\npvalues\n');
appendTable(fi,stats.pw.p,labs);
fprintf(fi,'-------------------------------------------------\n');

load('acorrdata_consolidated_rp2_cellids.mat');
[st,mdl] = plotCorrBarGraphErrMdl(corrcoeff);
plot_corr_bar_2_mdl(mdl);
write_corrpropdiff2file(fi,st);

close all

% now do pearson correlation coefficient shuffling
suffix = mouseSuffix('good');
peakmvmt.chi = velTriggeredMSNSimultaneousCorr(suffix,50,'chi',100);
peakmvmt.fsi = velTriggeredMSNSimultaneousCorr(suffix,50,'fsi',100);

% peakmvmt.shuffle = velTriggeredMSNSimultaneousCorrShuffle(suffix, radius,mousetype, cutoff,nreps);
% peakmvmt.shuffle = plot_segmentcorr_combo_shuffles3(1000); changing to
% next line:
peakmvmt.shuffle = plot_segmentcorr_combo_shuffles_bysession(1000);

% edit plot_segment
% st = plot_segmentcorr_combo_zscore3(peakmvmt,peakmvmt.shuffle);
% stats = plot_segmentcorr_combo_bysession(peakmvmt); % need to add shuffling to this
st = plot_segmentcorr_combo_zscore_bysession(peakmvmt,peakmvmt.shuffle);
addCorrStatsCombo2(fi,st,'ALL');

%% Figure 6 %

% C and D
% simulate_msn_regression; %%simulate_msn_regression_bino
[c_fsi,X_all.fsi, y_all.fsi] = regression_model_train_fast('good',5000,'fsi');
[c_chi,X_all.chi, y_all.chi] = regression_model_train_fast('good',5000,'chi');
save('processedData/regression_msn_sim_new','c_fsi','c_chi','X_all','y_all','-v7.3');
% plot_example_regression_traces(X_all.fsi{25}, y_all.fsi{25},suffix{25})
% plot_example_regression_traces(X_all.chi{5}, y_all.chi{5},suffix{5})
load('processedData/regression_msn_sim_new');
c = compare_regression('good',1); %7909bl2 and other is 689ACSF092515
fprintf(fi,'Figure 4I and Figure 4J\n');
% [p,df,labels] = plot_regression_stats2(fi,c,c_chi,c_fsi);
[p, df, labels] = plot_regression_stats_box(fi,c,c_chi, c_fsi);

%now do glms
[cfsi_single, fsisamp] = glm_model_train_single('good','fsi'); %need to plot sampinfo
%  [stats, figs] = compare_single_glm(c_single)
plot_sample_glm_single(fsisamp(2),'fsi',suffix(2));
[cchi_single, chisamp] = glm_model_train_single('good','chi'); %need to plot sampinfo
plot_sample_glm_single(chisamp(7),'chi',suffix(7));

% generate some nice figures
% [cout, Xsamp, Ysamp] = glm_model_train('good','fsi',1);
% plot_sample_glm_multi(Xsamp, Ysamp,'fsi');
% [cout, Xsamp, Ysamp] = glm_model_train('good','chi',1);
% plot_sample_glm_multi(Xsamp, Ysamp,'chi');

[cfsi_all] = glm_model_train('good','fsi',5000);
[cchi_all] = glm_model_train('good','chi',5000);

save('processedData/multi_neuron_glm.mat','cchi_all','cfsi_all','-v7.3');

load('processedData/multi_neuron_glm.mat'); % old 1000 version in processed data, new
% one in main repo
[stats] = compare_glm_box(cfsi_all.all, cfsi_single.allint, cfsi_single.all, cfsi_single.ind, cfsi_single.indint,0);

savePDF(gcf,sprintf('figures/%s/glm_fsi_box.pdf',date));
fprintf(fi,'--------------------------------------------\n');
fprintf(fi,'GLM statistics, FSI mice Friedman test: X2(%d)=%d, p=%d\n',stats.sr.df, stats.sr.chi2,stats.sr.p);
% fprintf(fi,'\t Mean signranks:\n\t%s\t%s\t%s\t%s\t%s\n',stats.pw.labels{:});
% fprintf(fi,'\t%d\t%d\t%d\t%d\t%d\n',stats.pw.stats(1),stats.pw.stats(2),stats.pw.stats(3),stats.pw.stats(4),stats.pw.stats(5));
fprintf(fi,'Pairwise comparison p-values\n');
labels.col = stats.pw.labels;
labels.row = labels.col;
appendTable(fi,stats.pw.p,labels);
fprintf(fi,'--------------------------------------------\n');
% [stats] = compare_glm2(cchi_all.all, cchi_single.allint, cchi_single.all, cchi_single.ind, cchi_single.indint,0);
[stats] = compare_glm_box(cchi_all.all, cchi_single.allint, cchi_single.all, cchi_single.ind, cchi_single.indint,1);
savePDF(gcf,sprintf('figures/%s/glm_chi_box.pdf',date));
fprintf(fi,'--------------------------------------------\n');
fprintf(fi,'GLM statistics, CHI mice Friedman test: X2(%d)=%d, p=%d\n',stats.sr.df, stats.sr.chi2,stats.sr.p);
fprintf(fi,'Pairwise comparison p-values\n');
labels.col = stats.pw.labels;
labels.row = labels.col;
appendTable(fi,stats.pw.p,labels);

fprintf(fi,'--------------------------------------------\n');


%% Figure 7
% msnTriggeredInterneuron
% chiTriggeredMSN
% fsiTriggeredMSN
suffix = mouseSuffix('good');
[fluor.chi, stats.chi] = roiTriggeredROIEvents(suffix, 50, 0, 0, 'chi','chi');
[fluor.msn, stats.msn] = roiTriggeredROIEvents(suffix, 50, 0, 0, 'msn','chi'); %maybe subsample this?
st.chi = plotROITriggeredEventFluor(fluor, 'chi', stats);

fprintf(fi,'\nPre-event\n');
write_ranksum_2_file(fi,st.chi.rs.p.pre,st.chi.rs.w.pre);
fprintf(fi,'\nPost-event\n');
write_ranksum_2_file(fi,st.chi.rs.p.post,st.chi.rs.w.post);


[fluor2.fsi, stats2.fsi] = roiTriggeredROIEvents(suffix, 50, 0, 0, 'fsi','fsi');
[fluor2.msn, stats2.msn] = roiTriggeredROIEvents(suffix, 50, 0, 0, 'msn','fsi');
st.fsi = plotROITriggeredEventFluor(fluor2, 'fsi', stats2);

fprintf(fi,'\nPre-event\n');
write_ranksum_2_file(fi,st.fsi.rs.p.pre,st.fsi.rs.w.pre);
fprintf(fi,'\nPost-event\n');
write_ranksum_2_file(fi,st.fsi.rs.p.post,st.fsi.rs.w.post);

%%
suffix = mouseSuffix('good');
pm.msn = roiTriggeredMSNSynchSum(suffix,50,'msn',52,53);
pm.fsi = roiTriggeredMSNSynchSum(suffix,50,'fsi',52,53);
pm.chi = roiTriggeredMSNSynchSum(suffix,50,'chi',52,53);

stats =  plotTrigMSNSynchronyProportion(pm,'',1);

fprintf(fi,'-------------------------\n');
fprintf(fi,'ROI triggered Synchrony\n');
write_roi_triggered_probability(fi,stats);

%%
cout = synch_trig_velocity('good',100);
stats = plot_synch_trig_velocity_box(cout);
% stats = plot_synch_trig_velocity2(cout);
fprintf(fi,'----------------------------------\n');
fprintf(fi,'Synchrony-triggered velocity\n');
fprintf(fi,'Friedman test\n');
fprintf(fi,'Chi2(%d)=%d, p=%d\n',stats.kw.st.df,stats.kw.st.chi2,stats.kw.p);
fprintf(fi,'Pairwise bar comparison p-vals, Bonferroni post-hoc\n');
labels.col = stats.pw.labels;
labels.row = stats.pw.labels;
appendTable(fi,stats.pw.p,labels);
fprintf(fi,'----------------------------------\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% OPTO FIGURES
%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%


%% laser triggered zero crossings, non-parametric tests
clear metadata

metadata_final_motor_final_double_new
fprintf(fi,'-----------------------------------------\n'); % laser_triggered_rotation_zerocrossings3
fprintf(fi,'Rank Sum Tests\n');
% made new metadata struct
rot = laser_triggered_rotation_zerocrossings(metadata,'fsi',0);
st = plot_laser_zerocrossings_box(rot,'PV');
close
title('PV mice');
fprintf(fi,' \n');
fprintf(fi,'Zero crossings of rotation, FSI animals:\n');
write_ranksum_2_file(fi,st.p,st.st);


rot = laser_triggered_rotation_zerocrossings(metadata,'chi',0); % laser_triggered_rotation_zerocrossings3
st = plot_laser_zerocrossings_box(rot,'ChAT');
close
title('CHI mice');
fprintf(fi,'CHI animals:\n');
write_ranksum_2_file(fi,st.p,st.st);

%% now fsi-triggered zero crossings

[st,rot] = roi_triggered_zerocrossings3('good','fsi');
fprintf(fi,'Zero-crossing density, fsi original animals, signtest\n');
write_signtest_2_file(fi,st.signtest.p,st.signtest.st);
plot_roi_zerocrossings_box(rot,'PV_original');
% 
% % chi-triggered zero crossings vs time
[st,rot] = roi_triggered_zerocrossings3('good','chi');
fprintf(fi,'Zero-crossing density, chi original animals, signtest\n');
write_signtest_2_file(fi,st.signtest.p,st.signtest.st);
plot_roi_zerocrossings_box(rot,'ChAT_original');

%%
formula = 'Velocity ~ TimeBin + (1|Mouse)+(1|EventID) + (TimeBin|EventID) + (Mouse|EventID)';

%% unsigned, normalized speed (tried with big formula)
clearvars -except fi formula
metadata_final_motor_final_double_new
hilo = 0;
absval = 0;
mvmt = 'speed';
genotype = 'fsi';
normalize = 1;
fprintf(fi,'Using formula %s\n',formula);
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula);

genotype = 'chi';
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula);


%% unsigned, normalized speed hilo
clearvars -except fi formula
metadata_final_motor_final_double_new
hilo = 1;
absval = 0;
mvmt = 'speed';
genotype = 'fsi';
normalize = 1;
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula);

genotype = 'chi';
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula);


%% mixed effects models for ROI triggered speed
clearvars -except fi
metadata_final_controlmotor_final
formula = 'Velocity ~ TimeBin + (1|Mouse)+(1|EventID) + (TimeBin|EventID) + (Mouse|EventID)'; % added Mouse|EventID too, but this didn't make a difference
hilo = 0;
absval = 0;
mvmt = 'speed';
genotype = 'fsi';
normalize = 1;
control_string = 'control';
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula, control_string);

hilo = 0;
absval = 0;
mvmt = 'speed';
genotype = 'chi';
normalize = 1;
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula, control_string);

% hi and low speed

clearvars -except fi
metadata_final_controlmotor_final
formula = 'Velocity ~ TimeBin + (1|Mouse)+(1|EventID) + (TimeBin|EventID) + (Mouse|EventID)'; % added Mouse|EventID too, but this didn't make a difference
hilo = 1;
absval = 0;
mvmt = 'speed';
genotype = 'fsi';
normalize = 1;
control_string = 'control';
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula, control_string);

genotype = 'chi';
laser_triggered_movement_box(fi,metadata,genotype,mvmt,hilo,normalize,absval,formula, control_string);

%% laser triggered synchrony
clear
metadata_final_gcamp_final_2
activity = compare_laser_synchrony_all2(metadata);
[peakmvmt] = roiTriggeredMSNSynchronyLaser(metadata, 50, 'msn', 52,53,0);
mn = get_mean_synchrony_laser_individual_nonlaser(metadata,'all');
figure;
st = plot_laser_synchrony_all62(activity,mn, peakmvmt, metadata);
write_opto_synchrony(fi,st);

% plot laser triggered synchrony
clear
metadata_final_gcamp_final_2

activity = compare_laser_synchrony_all5(metadata,100);

[peakmvmt] = roiTriggeredMSNSynchronyLaserPretty(metadata, 50, 'msn', 52:53,0);

mn = get_mean_synchrony_laser_individual_nonlaser(metadata,'all');

plot_laser_synchrony_all_pretty_nomsn_line(activity,peakmvmt,mn, metadata,100);

[peakmvmt] = roiTriggeredMSNSynchronyLaserPretty(metadata, 100, 'msn', 51:151,0);
save('processedData/peakmvmt_msnsynchopto.mat','peakmvmt','-v7.3');



load('processedData/peakmvmt_msnsynchopto.mat');
mn = get_mean_synchrony_laser_individual_nonlaser(metadata,'all');
plot_laser_synchrony_all_pretty_msn(mn,peakmvmt);


mn = get_mean_synchrony_laser_individual_nonlaser(metadata,'all');

activity = compare_laser_synchrony_all_prepost(metadata);
plot_synchrony_pre_post(metadata,activity,mn);

%% conduct the mixed-effects model for roi triggered speed
[chi, fsi] = get_trig_spd_all_mouse('good');
plot_roi_trig_spd_box(chi, fsi,'speed'); % plot
tbl = plot_roi_trig_spd_mouse_novel(chi,fsi); % using resulting model from model fitting roi-triggered

st.all = fit_roi_trig_spd_lme_novel2(tbl);
int = fit_roi_trig_spd_lme_interactions_novel3(tbl);
time = fit_roi_trig_spd_lme_interactions_time2(tbl);
st.int = int;
st.time = time;
save('processedData/mixed_effects_models/roi_triggered_speed.mat','st','tbl');

load('processedData/mixed_effects_models/roi_triggered_speed.mat');
fprintf(fi,'ROI-triggered speed\n');
write_roi_trig_spd_mdl(fi,st);

%% now do the same for roi triggered rotation (using absolute value).
clear st tbl mdl chi fsi
[chi, fsi] = get_trig_rot_all_mouse('good');
plot_roi_trig_spd_box(chi,fsi,'unsigned-rotation');
[tbl] = plot_roi_trig_spd_mouse_novel(chi, fsi);

[st.all] = fit_roi_trig_spd_lme_novel2(tbl); % here, only the t term is significant
int = fit_roi_trig_spd_lme_interactions_novel3(tbl);
time = fit_roi_trig_spd_lme_interactions_time2(tbl);
st.int = int;
st.time = time;
save('processedData/mixed_effects_models/roi_triggered_rot.mat','st','tbl');

load('processedData/mixed_effects_models/roi_triggered_rot.mat');
fprintf(fi,'ROI-triggered rotation\n');
write_roi_trig_spd_mdl(fi,st);

%% now find slope fluorescence
%% 
[chi, fsi] = get_trig_spd_all_mouse('good');

% run for 2 seconds
[st] = consolidate_roi_triggered_movement_nobin_box(chi,fsi,1.5);
write_slope_posthocs(fi,st,1.5);

%% Figure S9
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% Now do the same for CHIs

inttype = 'chi';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% now split up by positively and negatively modulated CHIS
% plot shaded error bar

[pvals2, stat2] = plot_and_stats_triggeredfluor_split_box(@dyTriggeredFluorescence, inttype,'movement onset',fi);

[pvals2, stat2] = plot_and_stats_triggeredfluor_split_box(@velTriggeredFluorescence, inttype,'peak velocity',fi);

[pvals2, stat2] = plot_and_stats_triggeredfluor_split_box(@decelTriggeredFluorescence, inttype,'deceleration',fi);

% conduct the mixed-effects model for roi triggered speed
close all
[roi.pos] = get_trig_spd_all_mouse_siginds2('good',inttype,inttype,'pos');
[roi.neg] = get_trig_spd_all_mouse_siginds2('good',inttype,inttype,'neg');
[X,Xerr] = plot_roi_trig_spd_siginds_single_box(roi,'speed',inttype); % 

tbl = gather_roi_trig_spd_mouse_siginds_single(roi); % using resulting model from model fitting roi-triggered
st.all = fit_roi_trig_spd_lme_novel2(tbl);
fprintf(fi,'------------------------------\n%s triggered speed\n',upper(inttype));
write_linear_model(fi,st.all.omnibus);
fprintf(fi,'-------------------------------\n');

% now do glms
close all
[roi.pos, sample.pos] = glm_model_train_single_siginds('good',inttype,'pos'); %need to plot sampinfo
[roi.neg, sample.neg] = glm_model_train_single_siginds('good',inttype,'neg');
plot_example_glm_siginds(sample,inttype);
[stats] = compare_glm_siginds_single(roi.pos, roi.neg);
savePDF(gcf,sprintf('figures/%s/glm_%s_siginds.pdf',date,inttype));
fprintf(fi,'---------------------\n');
fprintf(fi,'GLM, %s(-) vs %s(+) (individual)\n',upper(inttype),upper(inttype));
write_signtest_2_file(fi,stats.p,stats.st);
fprintf(fi,'---------------------\n');

close all
[c,X,y] = compare_regression_siginds_single('good', inttype);
st = plot_regression_stats_single( c,inttype);
plot_example_regression_siginds(X,y,inttype);
fprintf(fi,'---------------------\n');
fprintf(fi,'Regression, %s(+) vs %s(-)\n',upper(inttype),upper(inttype));
write_signtest_2_file(fi,st.p,st.st);
fprintf(fi,'---------------------\n');

%
load('acorrdata_consolidated_rp2_cellids.mat')
% st = msn_clustering_by_tdt_modulation('good', corrcoeff,1);

fprintf(fi,'Clustering tests for MSNs correlated with CHI\n');
fprintf(fi,'Table is negatively modulated (rows) x positively modulated (columns)');
st = msn_clustering_by_tdt_modulation7('good',corrcoeff,5000); % 5000 bootstrap samples
p = [st.p];
currind = 1;
for i=1:numel(st)
    if ~isempty(st(i).p)
        fprintf(fi,'\n%s\n',st(i).suffix);
        write_bs_2_file(fi,p(currind),st(i).true);
        currind = currind+1;
    end
end

%% figure S10
clear metadata
metadata_final_gcamp_final_2

% first, plot laser triggered fluorescence % maybe

radius = 20;

ltf = laser_triggered_fluorescence(metadata,200,'chi');
[p,st] = plot_laser_triggered_average(ltf,'ChAT-cre',radius);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered fluorescence for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered fluorescence for CHIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');

ltf = laser_triggered_fluorescence(metadata,200,'fsi');
[p,st] = plot_laser_triggered_average(ltf,'PV-cre',radius);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered fluorescence for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered fluorescence for FSIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');

% plot laser triggered activity/probability % maybe....
radius = 20;
ltf = laser_triggered_activity(metadata,200,'chi');
mean_activity = get_mean_activity_laser2(metadata,'chi');
[p,st,st2] = plot_laser_triggered_average(ltf,'ChAT-cre',radius,1,mean_activity);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered activity for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered activity for CHIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');


ltf = laser_triggered_activity(metadata,200,'fsi');
mean_activity = get_mean_activity_laser2(metadata,'fsi');
[p,st,st2] = plot_laser_triggered_average(ltf,'PV-cre',radius,1,mean_activity);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered activity for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered activity for FSIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');

% laser triggered fluorescence, control mice

metadata_laser_control
mta = laser_triggered_fluorescence(metadata,200,'fsi');
radius = 20;
[p,st] = plot_laser_triggered_average(mta,'fsi',radius); % no significant difference using these two sessions
ylim([-0.2 .8])
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered fluorescence, control mice\n');
fprintf(fi,'Laser-triggered fluorescence for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered fluorescence for FSIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');
fprintf(fi,'-----------------------------------------\n');

mta = laser_triggered_fluorescence(metadata,200,'chi');
radius = 20;
[p,st] = plot_laser_triggered_average(mta,'chi',radius); % no significant difference using these two sessions
ylim([-0.2 .8])
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered fluorescence, control mice\n');
fprintf(fi,'Laser-triggered fluorescence for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered fluorescence for CHI, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');
fprintf(fi,'-----------------------------------------\n');

% now laser-triggered probability
ltf = laser_triggered_activity(metadata,200,'chi');
mean_activity = get_mean_activity_laser2(metadata,'chi');
[p,st] = plot_laser_triggered_average(ltf,'chi',radius,1,mean_activity);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered activity for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered activity for CHIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');

% now laser-triggered probability
ltf = laser_triggered_activity(metadata,200,'fsi');
mean_activity = get_mean_activity_laser2(metadata,'fsi');
[p,st] = plot_laser_triggered_average(ltf,'fsi',radius,1,mean_activity);
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Laser-triggered activity for MSNs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.msn,st.msn)
fprintf(fi,'Laser-triggered activity for FSIs, %d timepoints pre vs post laser\n',radius);
write_signtest_2_file(fi,p.tdt,st.tdt)
fprintf(fi,'\n\n');


%% Figure S11

inttype = 'fsi';

[pvals, stat] = plot_and_stats_triggeredfluor_split(@dyTriggeredFluorescence, inttype,'movement onset',fi);

[pvals, stat] = plot_and_stats_triggeredfluor_split(@velTriggeredFluorescence, inttype,'peak velocity',fi);

[pvals, stat] = plot_and_stats_triggeredfluor_split(@decelTriggeredFluorescence, inttype,'deceleration',fi);


%
[roi.pos] = get_trig_spd_all_mouse_siginds2('good',inttype,inttype,'pos');
[roi.neg] = get_trig_spd_all_mouse_siginds2('good',inttype,inttype,'neg');
[X,Xerr] = plot_roi_trig_spd_siginds_single(roi,'speed',inttype); % 

tbl = gather_roi_trig_spd_mouse_siginds_single(roi); % using resulting model from model fitting roi-triggered
st.all = fit_roi_trig_spd_lme_novel2(tbl);
fprintf(fi,'------------------------------\n%s triggered speed\n',upper(inttype));
write_linear_model(fi,st.all.omnibus);
fprintf(fi,'-------------------------------\n');
%
close all
[roi.pos, sample.pos] = glm_model_train_single_siginds('good',inttype,'pos'); %need to plot sampinfo
[roi.neg, sample.neg] = glm_model_train_single_siginds('good',inttype,'neg');
plot_example_glm_siginds(sample,inttype);
[stats] = compare_glm_siginds_single(roi.pos, roi.neg);
savePDF(gcf,sprintf('figures/%s/glm_%s_siginds.pdf',date,inttype));
fprintf(fi,'---------------------\n');
fprintf(fi,'GLM, %s(-) vs %s(+) (individual)\n',upper(inttype),upper(inttype));
write_signtest_2_file(fi,stats.p,stats.st);
fprintf(fi,'---------------------\n');

close all
[c,X,y] = compare_regression_siginds_single('good', inttype);
st = plot_regression_stats_single( c,inttype);
plot_example_regression_siginds(X,y,inttype);
fprintf(fi,'---------------------\n');
fprintf(fi,'Regression, %s(+) vs %s(-)\n',upper(inttype),upper(inttype));
write_signtest_2_file(fi,st.p,st.st);

% find laser-related MSNs in PV mice
clear metadata
metadata_final_gcamp_final_2
generateShufflesRising2Laser(metadata);
for m=1:numel(metadata)
    meanPairwiseAssymCorr2LaserEpochs(metadata(m));
end
corrcoeff = consolidateACorrData_small_cellids_laser_epochs(metadata,'_rp2_laser_epochs');
clearvars -except fi
metadata_final_gcamp_final_2
load('acorrdata_consolidated_rp2_laser_epochs_cellids.mat')
st = msn_clustering_by_tdt_modulation_laser_plot3(metadata,corrcoeff); % 5000 bootstrap samples
print_laser_vs_pv_correlation(fi,st)



%% Figure S12
% construct the large GLM
tbl = glm_model_gather2('good');

mdl = fitlme(tbl,'speeds~roi_type:traces+traces+speedlag1+speedlag2+(1|mouseno)+(traces|roi_no)');
tbl.roi_type = reorderlevels(tbl.roi_type,{'fsi','msn','chi'});
mdl2 = fitlme(tbl,'speeds~roi_type:traces+traces+speedlag1+speedlag2+(1|mouseno)+(traces|roi_no)');

fprintf(fi,'Linear model, predicting speed\n');
write_linear_model(fi,mdl2);
fprintf(fi,'Anova for linear model, predicting speed\n');
write_linear_model(fi,anova(mdl2));
fprintf(fi,'Benjamini-Hochberg corrected p-values:\n');

tstats = cat(1,mdl.Coefficients.tStat(5:6),mdl2.Coefficients.tStat(6));
pvals = cat(1,mdl.Coefficients.pValue(5:6),mdl2.Coefficients.pValue(6));
df = mdl2.Coefficients.DF;
comparisons = cat(1,{[mdl.CoefficientNames{5} ' vs traces:roi_type_msn']},...
    {[ mdl.CoefficientNames{6} ' vs traces:roi_type_msn']},...
    {[mdl2.CoefficientNames{6} ' vs traces:roi_type_fsi' ]});

pvals = posthoc_benjaminihochberg_raw(pvals);
fprintf(fi,'Post hoc values, benjamini-hochberg corrected:\n');
for i=1:numel(pvals)
   fprintf(fi,'%s, t(%f)=%f, p=%d\n',comparisons{i},df(1),tstats(i),pvals(i));
end


%% plotting for figure s12
tbl = glm_model_gather2('good');
tbl.roi_type = reorderlevels(tbl.roi_type,{'msn','fsi','chi'});

mdl = fitlme(tbl,'speeds~roi_type:traces+traces+speedlag1+speedlag2+(1|mouseno)+(traces|roi_no)');
roi_types = {'msn','fsi','chi'};
mdl3 = {};
suffix = mouseSuffix('good');
for m=1:numel(suffix)
    tic
    tbl2 = tbl((tbl.mouseno == nominal(suffix{m})),:);
    for i = 1:numel(roi_types)
        if sum(find(tbl2.roi_type == roi_types{i})) == 0
            tbl2.roi_type = removecats(tbl2.roi_type,roi_types{i});
        end
    end
    for s=1:numel(suffix)
        if sum(find(tbl2.mouseno == nominal(suffix{s}))) == 0
           tbl2.mouseno = droplevels(tbl2.mouseno,suffix{s});
        end
        
    end
    mdl3{end+1} = fitlme(tbl2,'speeds~roi_type:traces+traces+speedlag1+speedlag2+(traces|roi_no)');
    toc
end

ischi = [];
for m=1:numel(suffix)
    mousedata = loadMouse(suffix(m));
    ischi(m) = mousedata.isCHI;    
end

chicoeffs = [];
for m=1:numel(suffix)
    if ischi(m)
        if length(mdl3{m}.Coefficients.Estimate) == 5
        chicoeffs = cat(1,chicoeffs,mdl3{m}.Coefficients.Estimate(end));    
        end
    end
end

fsicoeffs = [];
for m=1:numel(suffix)
    if ~ischi(m)
        if length(mdl3{m}.Coefficients.Estimate) == 5
        fsicoeffs = cat(1,fsicoeffs,mdl3{m}.Coefficients.Estimate(end));    
        end
    end
end

[~,y,grp] = make_dummy_mat(chicoeffs,fsicoeffs);

bar_err_dot(cat(1,{fsicoeffs},{chicoeffs}),1);

set(gca,'xticklabel',{'PV','CHI'});
ylabel('Estimate of interaction term relative to MSN');
savePDF(gcf,sprintf('figures/%s/big_glm.pdf',date))



