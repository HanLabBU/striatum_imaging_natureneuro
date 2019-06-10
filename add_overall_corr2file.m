function add_overall_corr2file(fi,stats)
fprintf(fi,'------------------------------\n');
fprintf(fi,'Pairwise chi2 values,  F-F vs M-M vs C-C\n');
labels.row = stats.labels;
labels.col = stats.labels;
addTableToFile(fi,stats.pw.chi2,labels);
fprintf(fi,'Pairwise p values, Holm-bonferroni-corrected\n');
addTableToFile(fi,stats.pw.p,labels);
fprintf(fi,'Pairwise df values\n');
addTableToFile(fi,stats.pw.df,labels);
fprintf(fi,'------------------------------\n');

end