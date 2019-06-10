function write_slope_posthocs(fi,st,no)
fprintf(fi,'-----------------------------------------------\n');
fprintf(fi,'Slopes for baseline through timepoints up to %f\n',no);
pvals = st.mdl.Coefficients.pValue(2:3);
tstats = st.mdl.Coefficients.tStat(2:3);
names = st.mdl.CoefficientNames(2:3);
for n=1:numel(names)
    names{n} = ['celltype_chi vs ' names{n}];
end

pvals = cat(1,pvals,st.mdl2.Coefficients.pValue(2));
names = cat(2,names,{['celltype_fsi vs ' st.mdl2.CoefficientNames{2}]});
tstats = cat(1,tstats,st.mdl2.Coefficients.tStat(2));

pbh = posthoc_benjaminihochberg_raw(pvals);
pb = pvals*numel(names);

fprintf(fi,'ANOVA:\n');
write_linear_model(fi,anova(st.mdl));

fprintf(fi,'Benjamini-hochberg:\n');
for f=1:numel(names)
    fprintf(fi,'t=%f, %s: %f\n',tstats(f),names{f},pbh(f));
end

fprintf(fi,'Bonferroni:\n');
for f=1:numel(names)
    fprintf(fi,'t=%f, %s: %f\n',tstats(f), names{f},pb(f));
end

fprintf(fi,'-----------------------------------------------\n');
end