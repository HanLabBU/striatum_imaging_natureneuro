function stats = computeSummStatHiLo(statstruc)

[~,y,grp1] = make_dummy_mat(statstruc.msn.all(:), statstruc.chi.all(:), statstruc.fsi.all(:));
[stats.all.p, tbl, kwstat.all] = kruskalwallis(y,grp1);
stats.all.df = cat(1,tbl{2:3,3});
stats.all.chi2 = tbl{2,5};
stats.all.n = kwstat.all.n;

[~,y,grp1] = make_dummy_mat(statstruc.msn.hi(:), statstruc.chi.hi(:), statstruc.fsi.hi(:));
[stats.hi.p, tbl, kwstat.hi] = kruskalwallis(y,grp1);
stats.hi.df = cat(1,tbl{2:3,3});
stats.hi.chi2 = tbl{2,5};
stats.hi.n = kwstat.hi.n;


[~,y,grp1] = make_dummy_mat(statstruc.msn.lo(:), statstruc.chi.lo(:), statstruc.fsi.lo(:));
[stats.lo.p, tbl, kwstat.lo] = kruskalwallis(y,grp1);
stats.lo.df = cat(1,tbl{2:3,3});
stats.lo.chi2 = tbl{2,5};
stats.lo.n = kwstat.lo.n;

%now compute mann u whitney
%all vs hi vs lo
fnames = fieldnames(statstruc);
for f=1:numel(fnames)
    currcell = fnames{f};
    [stats.pw.(currcell).p,tmp] = signtest_explicit(statstruc.(currcell).hi(:), statstruc.(currcell).lo(:));
    stats.pw.(currcell).stats = tmp;
end
stats.pw.labelsbycelltype = {'all','hi','lo'};
stats.pw.labelsbyspeed = {'msn','chi','fsi'};


%msn vs chi vs fsi
fnames = fieldnames(statstruc.msn);
for f=1:numel(fnames)
    currnm = fnames{f};
    stats.pw.(currnm).p = nan(3,3);
    stats.pw.(currnm).lbl = nan(3,1);
    [c] = multcompare(kwstat.(currnm));
    c = table(c(:,1),c(:,2),c(:,6),kwstat.(currnm).meanranks(c(:,1))', kwstat.(currnm).meanranks(c(:,2))','VariableNames',{'Grp1','Grp2','pval','meanrnk1','meanrnk2'});
    stats.pw.(currnm).p = c;
end
end