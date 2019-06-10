function [st] = fit_roi_trig_spd_lme_interactions_time2(tbl)
% have significant effects for
% T_all:CellTypeAll. So, remake the model independently for each time point
% now, go time point by timepoint
st = struct('tstat','p','low','high','mdl1','labels');
cellvals = unique(tbl.CellTypeAll); % get unique time indices

reduced_model = 'Y_all~T_all+(1|CellIds)+(1|Animal_all)';
try
    parpool('local',3);
catch
    parpool('local',2);
end
parfor t=1:numel(cellvals)
   currcell = cellvals(t);
   st(t).celltype = currcell;
    % shrink the table so that it is just the current time
   currtbl1 = tbl(tbl.CellTypeAll == currcell,:);
   
   % only one time stamp now. fit model
   mdl1 = fitlme(currtbl1,reduced_model);
   % store these two models
   st(t).mdl1 = mdl1;
   
   st(t).anova = anova(mdl1);
   
   % store analytical p values
   st(t).p = [mdl1.Coefficients.pValue(2:end)];
   
   % store t statistics
   st(t).tstat = [mdl1.Coefficients.tStat(2:end)];
   
   % store comparison labels
   st(t).labels = {'baseline','Time1', 'Time2', 'Time3', 'Time4'};
   
   % get df for these t tests
   st(t).df = mdl1.DFE;
   fprintf('done with iteration %d\n',t);
  
end
delete(gcp('nocreate'));

end

