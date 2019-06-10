function stats = overallCorrCoeffBarBox(corrcoeff) % takes as input output of consolidateACorrDataDirectional


corcoef.ff = corrcoeff.ff.r;
corcoef.mm = corrcoeff.mm.r;
corcoef.cc = corrcoeff.cc.r;


figure
[ax,l] = box_err([{corcoef.mm},{corcoef.ff},{corcoef.cc}]');
ylabel('Average ROI Coefficient')
xlabel('Pair type')

set(ax,'XTickLabel',{'M-M','F-F','C-C'});%,'M-F','M-C','F-M','C-M'};

stats = rsStats(corcoef);
stats.labels = {'FSI-FSI','MSN-MSN','CHI-CHI'};
end



function stats = rsStats(corcoef)
 [~,y,grps] = make_dummy_mat(corcoef.ff, corcoef.mm, corcoef.cc);
 [stats.kw.p, stats.kw.tbl, stats.kw.stat] = kruskalwallis(y,grps);
c = multcompare(stats.kw.stat);
c = table(c(:,1),c(:,2),c(:,6),'VariableNames',{'Grp1','Grp2','pval'});
 stats.pw.p = c;
end
