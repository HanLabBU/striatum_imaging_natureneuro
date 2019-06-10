function [st] = fit_roi_trig_spd_lme_interactions_novel3(tbl)
% have significant effects for
% T_all:CellTypeAll. So, remake the model independently for each time point
% now, go time point by timepoint
st = struct('val','p','low','high','mdl','all');
timevals = unique(tbl.T_all); % get unique time indices

reduced_model = 'Y_all~CellTypeAll+(1|Animal_all)';
try
    parpool('local',4)
catch
    parpool('local',2)
end
parfor t=1:numel(timevals)
   currt = timevals(t);
   
    % shrink the table so that it is just the current time
   currtbl = tbl(tbl.T_all == currt,:);
   
   % only one time stamp now. fit model
   mdl = fitlme(currtbl,reduced_model);
   
   % make a new table 
   currtbl2 = currtbl;
   
   % reorder the levels to compare different reference variable
   currtbl2.CellTypeAll = reorderlevels(currtbl2.CellTypeAll,{'msn','fsi','chi'});
   mdl2 = fitlme(currtbl2,reduced_model);
   
   % store these two models
   st(t).mdl = mdl;
   st(t).mdl2 = mdl2;
   

   % store analytical p values
   st(t).p = [mdl.Coefficients.pValue(2:end); mdl2.Coefficients.pValue(2)]';
   
   % store t statistics
   st(t).tval = [mdl.Coefficients.tStat(2:end); mdl2.Coefficients.tStat(2)];
   
   % store comparison labels
   st(t).labels = {'PV-CHI','MSN-CHI','PV-MSN'};
   % get df for these t tests
   st(t).df = mdl.DFE;
   % create struct to store 3 comparisons
   fprintf('done with loop %d\n',t);
end
delete(gcp('nocreate'));
end

