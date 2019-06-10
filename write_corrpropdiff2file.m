function write_corrpropdiff2file(fi,st)

fprintf(fi,'----------------------------\n');
fprintf(fi,'Asymmetric correlation coefficients, differences between <100 and >=750/<1500\n');
write_linear_model(fi,st.mdl);
fprintf(fi,'Coefficients for interaction term corresponding to the following correlation types\n');
for f=1:numel(st.pvals_corrected)
    fprintf(fi,'%s: t(%d)=%f, p=%d\n',st.labels{f}, st.df,st.tvals(f),st.pvals_corrected(f));
end
fprintf(fi,'----------------------------\n');

end