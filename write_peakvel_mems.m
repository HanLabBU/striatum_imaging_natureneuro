function write_peakvel_mems(fi,mdl,mdl2)

fprintf(fi,'Velocity triggered fluorescence mixed-effects model\n');
write_linear_model(fi,mdl);
fprintf(fi,'Anova for velocity trigggered fluorescence\n');
write_linear_model(fi,anova(mdl));

p_values = cat(2,mdl2.chi.Coefficients.pValue,mdl2.fsi.Coefficients.pValue,mdl2.msn.Coefficients.pValue);

p_values = posthoc_benjaminihochberg_raw(p_values(2:end,:));
pvals.chi = p_values(:,1);
pvals.fsi = p_values(:,2);
pvals.msn = p_values(:,3);

celltypes = fieldnames(mdl2);
for f=1:numel(celltypes)
    fprintf(fi,'--------------------\n%s\n',celltypes{f});
    fprintf(fi,'Velocity triggered fluorescence mixed-effects model\n');
    write_linear_model(fi,mdl2.(celltypes{f}));
    fprintf(fi,'Anova for velocity trigggered fluorescence\n');
    write_linear_model(fi,anova(mdl2.(celltypes{f})));
    fprintf(fi,'Benjamini-Hochberg corrected p-values (across all cell types)\n');
    for t=1:numel(pvals.(celltypes{f}))
        fprintf(fi,'\tTimeBin %d vs TimeBin1: t(%d)=%f, p=%d\n',t+1,mdl2.(celltypes{f}).Coefficients.DF(t+1), mdl2.(celltypes{f}).Coefficients.tStat(t+1), pvals.(celltypes{f})(t));
    end
    fprintf(fi,'-------------------\n');
end



end