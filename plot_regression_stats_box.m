function [p, df, labels] = plot_regression_stats_box(fi,c, c_msnchi, c_msnfsi)
    
    fnames.fsi = fieldnames(c.fsi);
    fnames.chi = fieldnames(c.chi);
    for f=1:numel(fnames.fsi)
        c.fsi.(fnames.fsi{f}) = mean(c.fsi.(fnames.fsi{f}),2);
        c.chi.(fnames.chi{f}) = mean(c.chi.(fnames.chi{f}),2);
    end

    fsi_msn_samples = mean(c_msnfsi,3);
    fsi_msn_mn = mean(fsi_msn_samples,2);
    
    chi_msn_samples = mean(c_msnchi,3);
    chi_msn_mn = mean(chi_msn_samples,2);
    
    %first, plot for fsi mice. 
    figure
    [ax,l] = box_err([{c.fsi.fsi},{c.fsi.speed},{c.fsi.rot}, {fsi_msn_mn}]');
    set(ax,'xticklabel',{'FSI','Speed','Rotation','Random MSN'});
    savePDF(gcf,sprintf('figures/%s/regression_bar_fsi.pdf',date));
    
    figure
    %secondly, plot for chi mice
    [ax,l] = box_err([{(c.chi.chi)},{(c.chi.speed)},{(c.chi.rot)}, {(chi_msn_mn)}]');
    set(ax,'xticklabel',{'CHI','Speed','Rotation', 'Random MSN'});
    savePDF(gcf,sprintf('figures/%s/regression_bar_chi.pdf',date));

    c.fsi.msn = fsi_msn_mn;
    c.chi.msn = chi_msn_mn;
    %test statistics
    
    [p.fsi, df.fsi, labels.fsi, chi2.fsi] = reg_stats(c.fsi);
    [p.chi, df.chi, labels.chi, chi2.chi] = reg_stats(c.chi);
    print_stats(fi, p, df, labels, chi2);    
end

function print_stats(fi, p, df, labels,chi2)
    labs.col = labels.fsi;
    labs.row = labels.fsi;
    fprintf(fi,'Regression statistics, FSI sessions\n');
    fprintf(fi,'Friedman test: chi2=%d, p=%d, df(group)=%d, df(err)=%d\n',chi2.fsi,p.fsi.all,...
        df.fsi.col, df.fsi.err...
);
    fprintf(fi,'Pairwise comparisons:\n');
    appendTable(fi, p.fsi.pw,labs);
    fprintf(fi,'\n');

    labs.col = labels.chi;
    labs.row = labels.chi;
    fprintf(fi,'Regression statistics, CHI sessions\n');
    fprintf(fi,'Friedman test: chi2=%d, p=%d, df(group)=%d, df(err)=%d\n',chi2.chi,p.chi.all,...
        df.chi.col, df.chi.err...
);
    appendTable(fi, p.chi.pw,labs);
    fprintf(fi,'\n');
end

function [p, df, labels, chi2] = reg_stats(c)
labels = fieldnames(c);
grp = [];
for j=1:numel(labels)
    grp = cat(2,grp,c.(labels{j}));
end
%check the next line
naninds = isnan(sum(grp,2));
grp = grp(~naninds,:);
[p.all, tbl, stats] = friedman(grp,1);
chi2 = tbl{2,5};
df.col = tbl{2,3};
df.err = tbl{3,3};
% c = pairwise_signrank(grp);
% c.pval = holmbonferroni(c.pval);
ctemp = multcompare(stats);
c = table(ctemp(:,1),ctemp(:,2),ctemp(:,6),stats.meanranks(ctemp(:,1))',stats.meanranks(ctemp(:,2))',...
    'VariableNames',{'Grp1','Grp2','pval','MnRnk1','MnRnk2'});
p.pw = c;
end