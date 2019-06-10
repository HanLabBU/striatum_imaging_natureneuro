function write_roi_triggered_probability(fi,stats)
fprintf(fi,'---------------------------------\n');
fprintf(fi,'Pairwise statistics:\n');
fprintf(fi,'Probabilities:\n');
fprintf(fi,'FSI:%d,CHI:%d,MSN:%d\n',full(stats.probs));
fprintf(fi,'Counts:\n');
fprintf(fi,'FSI:%d,CHI:%d,MSN:%d\n',stats.n.fsi,stats.n.chi,stats.n.msn);
labels.row = stats.labels;
labels.col = labels.row;
fprintf(fi,'Z-test values, bonferroni corrected:\n');
appendTable(fi,stats.pw, labels)
fprintf(fi,'---------------------------------\n');

end