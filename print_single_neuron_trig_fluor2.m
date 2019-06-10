function print_single_neuron_trig_fluor2(fi, stats)
fprintf(fi,'-----------------------------------------\n');
fprintf(fi,'Negatively and positively modulated single neurons\n');
fprintf(fi,'MSN clustering by modulation type\n');
fprintf(fi,'Positively modulated: ranksum = %d, n(pos)=%d, n(not pos)=%d, p = %d\n',stats.pos.rs.st.ranksum,stats.pos.rs.st.nx,stats.pos.rs.st.ny, stats.pos.rs.p);
fprintf(fi,'Negatively modulated: ranksum = %d, n(neg)=%d, n(not neg)=%d, p = %d\n\n',stats.neg.rs.st.ranksum, stats.neg.rs.st.nx,stats.neg.rs.st.ny,stats.neg.rs.p);
fprintf(fi,'Proportions modulated\n');
fprintf(fi,'cell type:\tprop. positive\t prop. negative\n');
fprintf(fi,'MSN\t%d\t%d\n',sum(stats.cdata.msn.pos)/length(stats.cdata.msn.pos), sum(stats.cdata.msn.neg)/length(stats.cdata.msn.neg));
fprintf(fi,'CHI\t%d\t%d\n', sum(stats.cdata.chi.pos)/length(stats.cdata.chi.pos), sum(stats.cdata.chi.neg)/length(stats.cdata.chi.neg));
fprintf(fi,'FSI\t%d\t%d\n\n', sum(stats.cdata.fsi.pos)/length(stats.cdata.fsi.pos), sum(stats.cdata.fsi.neg)/length(stats.cdata.fsi.neg));

fprintf(fi,'Comparing proportions within cell types, binomial exact test:\n');
for i=1:3
    fprintf(fi,'Equal proportions of %s and %s neurons?\n(Bonferroni-corrected, 3 comparisons)\n',stats.compare.msn(i).labels{1}, stats.compare.msn(i).labels{2});
    fprintf(fi,'\tMSNs: p=%d, n=%d,%d\n',stats.compare.msn(i).p, stats.compare.msn(i).n);
    fprintf(fi,'\tCHIs: p=%d, n=%d,%d\n',stats.compare.chi(i).p, stats.compare.chi(i).n);
    fprintf(fi,'\tFSIs: p=%d, n=%d,%d\n\n', stats.compare.fsi(i).p, stats.compare.fsi(i).n);
end
fprintf(fi,'----------------------------------------------\n\n');

end