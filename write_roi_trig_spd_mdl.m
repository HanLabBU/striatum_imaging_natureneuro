function write_roi_trig_spd_mdl(fi,st)
fprintf(fi,'-----------------------------------\n');
fprintf(fi,'Mixed effects model for ROI-triggered speed\n');
write_linear_model(fi,st.all.model);
fprintf(fi,'Omnibus test (for reference)\n');
write_linear_model(fi,st.all.omnibus);
fprintf(fi,'\nP-value for interaction term:\n');
fprintf(fi,'F(%d,%d)=%d, p=%0.4f\n',st.all.df1(end),st.all.df2(end),st.all.val(end),st.all.omnibus.pValue(end));
fprintf(fi,'------------------------------------\n');
fprintf(fi,'Reduced model for each cell type');
write_linear_model(fi,st.int(1).mdl.Formula);
fprintf(fi,'-----------\n');
fprintf(fi,'T-tests vs baseline for each cell type d\n');
% correct p values
p.time = posthoc_benjaminihochberg_raw(cat(2,st.time.p)); % here, only comparing to time point 1 (baseline)

p.cell = posthoc_benjaminihochberg_raw(cat(1,st.int.p)'); % compute all pairwise p values

fprintf(fi,'\n\nP-values for time x vs baseline\n');
for i=1:numel(st.time)
    fprintf(fi,'Cell type: %s\n',st.time(i).celltype);
    for j = 1:numel(st.time(i).p)
        fprintf(fi,'Time %d vs baseline: t(%d)=%d, p=%0.4f\n',j+1,st.time(i).df,st.time(i).tstat(j),p.time(j,i));
    end
    fprintf(fi,'\n');
end

fprintf(fi,'\nP-values for pairwise comparisons at each time point\n');
for i=1:numel(st.int)
    fprintf(fi,'Time point: %d\n',i);
    for j = 1:numel(st.int(i).p)
        fprintf(fi,'Comparison: %s: t(%d)=%d, p=%0.4f\n',st.int(i).labels{j},st.int(i).df,st.int(i).tval(j),p.cell(j,i));
    end
    fprintf(fi,'\n');
end


end