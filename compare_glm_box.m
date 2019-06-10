function [stats] = compare_glm_box(c_all_msn, c_all_int, c_sample_msn, c_msn_single, c_int_single, isCHI)

% compute session-wise statistics for one way
% c_all_msn, c_all_int
c_all_msn = cellfun(@(x) nanmean(x,2), c_all_msn,'uniformoutput',false);
c_int_single = cellfun(@(x) nanmean(x,1), c_int_single,'uniformoutput',false);
c_msn_single = cellfun(@(x) nanmean(x,1), c_msn_single,'uniformoutput',false);


c_allmsn_mn = cellfun(@(x) nanmean(x), c_all_msn);
c_allint_mn = cellfun(@(x) nanmean(x), c_all_int);
c_intsingle_mn = cellfun(@(x) nanmean(x), c_int_single);
c_msnsingle_mn = cellfun(@(x) nanmean(x), c_msn_single);
c_msnsample_mn = cellfun(@(x) nanmean(x), c_sample_msn);

if isCHI
    c_allmsn_mn([20 22]) = c_msnsingle_mn([20 22]);
else
    c_allmsn_mn([11 14 24]) = c_msnsingle_mn([11 14 24]);
end

X = [c_msnsingle_mn, c_allmsn_mn, c_msnsample_mn, c_intsingle_mn, c_allint_mn];
naninds = isnan(sum(X,2));
X(naninds,:) = [];
[stats.sr.p, tbl, stats.sr.st] = friedman(X,1,'off');
stats.sr.df = tbl{2,3};
stats.sr.chi2 = tbl{2,5};

% c = pairwise_signrank(X);
% c.pval = holmbonferroni(c.pval);
ctemp = multcompare(stats.sr.st,'display','off');
c = table(ctemp(:,1),ctemp(:,2),ctemp(:,6),stats.sr.st.meanranks(ctemp(:,1))',...
    stats.sr.st.meanranks(ctemp(:,2))','VariableNames',{'Grp1','Grp2','pval','MnRnk1','MnRnk2'});

stats.pw.labels = {'Single MSN', 'Multiple MSN','All MSN','Single Int','Multiple Int'};
stats.pw.p = c;

figure;
[ax,l] = box_err([{X(:,1)}, {X(:,2)}, {X(:,3)}; {X(:,4)}, {nan}, {X(:,5)}]);
set(ax,'XTickLabel',{'MSN','Interneuron'});
legend(l,{'Single','Sample','All'});

end