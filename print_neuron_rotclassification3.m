function print_neuron_rotclassification3(fi,stats)

fprintf(fi,'----------------------------------------------\n');
fprintf(fi,'Movement-related ROIs\n\n');
fprintf(fi,'\nProportion speed related\n');
fprintf(fi,'MSN: %d; FSI: %d; CHI: %d\n', stats.mvmt.speed.msn.p, stats.mvmt.speed.fsi.p, stats.mvmt.speed.chi.p);
fprintf(fi,'\nProportion rotation related\n');
fprintf(fi,'MSN: %d; FSI: %d; CHI: %d\n',stats.mvmt.rot.msn.p, stats.mvmt.rot.fsi.p, stats.mvmt.rot.chi.p);
fprintf(fi,'\nProportion mixed\n');
fprintf(fi,'MSN: %d; FSI: %d; CHI: %d\n\n',stats.mvmt.mix.msn.p, stats.mvmt.mix.fsi.p, stats.mvmt.mix.chi.p);
fprintf(fi,'Rotation neurons clustered? ranksum=%d, n(rot)=%d, n(other)=%d, p=%d\n',stats.rot.st.ranksum, stats.rot.st.nx, stats.rot.st.ny, stats.rot.p);
fprintf(fi,'Speed neurons clustered? ranksum=%d, n(spd)=%d, n(other)=%d, p=%d\n',stats.spd.st.ranksum, stats.spd.st.nx, stats.spd.st.ny, stats.spd.p);
fprintf(fi,'Mix neurons clustered? ranksum=%d, n(mix)=%d, n(other)=%d, p=%d\n\n',stats.mix.st.ranksum, stats.mix.st.nx, stats.mix.st.ny, stats.mix.p);
fprintf(fi,'Speed neurons more likely to be rotation neurons (Fisher exact test)?\n');

fnames = fieldnames(stats.test);

for f=1:numel(fnames)
    currfield = fnames{f};
    fprintf(fi,'%ss: p=%d, proportion speed=%d, proportion no speed=%d, odds=%d\n\n',currfield,...
        stats.test.(currfield).p, stats.test.(currfield).proportion.speed,...
        stats.test.(currfield).proportion.nospeed,stats.test.(currfield).st.OddsRatio);

end

fprintf(fi,'Equal proportions of mixed, speed, and rotation neurons (chi2gof test)?\n');
fprintf(fi,'MSNs: chi2(1)=%d, p=%d\n',stats.multinom.msn.all.chi2, stats.multinom.msn.all.p);
fprintf(fi,'CHIs: chi2(1)=%d, p=%d\n',stats.multinom.chi.all.chi2, stats.multinom.chi.all.p);
fprintf(fi,'FSIs: chi2(1)=%d, p=%d\n\n', stats.multinom.fsi.all.chi2, stats.multinom.fsi.all.p);

for i=1:3
    fprintf(fi,'Equal proportions of %s and %s neurons?\n(Bonferroni-corrected, binomial exact test 3 comparisons)\n',stats.multinom.msn.part(i).labels{1}, stats.multinom.msn.part(i).labels{2});
    fprintf(fi,'\tMSNs: p=%d, n=%d, %d\n',stats.multinom.msn.part(i).p, stats.multinom.msn.part(i).n);
    fprintf(fi,'\tCHIs: p=%d, n=%d, %d\n',stats.multinom.chi.part(i).p, stats.multinom.chi.part(i).n);
    fprintf(fi,'\tFSIs: p=%d, n=%d, %d\n', stats.multinom.fsi.part(i).p, stats.multinom.fsi.part(i).n);
end
fprintf(fi,'----------------------------------------------\n\n');


end