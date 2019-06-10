function stats = fluor_vs_mvmt_stats(fi,flAll)
    comb_fl = cat(1,flAll.fl);
    nobins = size(comb_fl,2);
    all.msn = [];
    all.chi = [];
    all.fsi = [];
    
    for i=1:nobins
        currmsn = cat(2,comb_fl(:,i).msn);
        currfsi = cat(2,comb_fl(:,i).fsi);
        currchi = cat(2,comb_fl(:,i).chi);
        all.msn = cat(1,all.msn, currmsn);
        all.fsi = cat(1,all.fsi, currfsi);
        all.chi = cat(1,all.chi, currchi);
    end
    
    no.msn = size(all.msn,2);
    no.chi = size(all.chi,2);
    no.fsi = size(all.fsi,2);

    all.msn = all.msn';
    all.chi = all.chi';
    all.fsi = all.fsi';

[stats.chi.all.p, stats.chi.all.tbl, stats.chi.all.st] = friedman(all.chi);
[stats.msn.all.p, stats.msn.all.tbl, stats.msn.all.st] = friedman(all.msn);
[stats.fsi.all.p, stats.fsi.all.tbl, stats.fsi.all.st] = friedman(all.fsi);


%now perform stepwise comparisons
[stats.chi.pw, stats.chi.vals] = rspw(stats.chi.all.st);
[stats.msn.pw, stats.msn.vals] = rspw(stats.msn.all.st);
[stats.fsi.pw, stats.fsi.vals] = rspw(stats.fsi.all.st);

writeStats(fi,stats)
end

function [pval, vals] = rspw(X)
[c,s] = multcompare(X);
labs = unique(c(:,1));
pval = nan(length(labs));
vals = s(:,1);
for j=1:size(c,1)
    n1 = c(j,1);
    n2 = c(j,2);
    pval(n1,n2) = c(j,6);
    pval(n2,n1) = c(j,6);
end
end



function writeStats(fi,stats)
    labs.col = arrayfun(@(x) num2str(x), 1:size(stats.msn.pw,2),'uniformoutput',false);
    labs.row = labs.col;
    
    fnames = fieldnames(stats);
    for f=1:numel(fnames)
        currname = fnames{f};
        fprintf(fi,'%s\n',upper(fnames{f}));
        fprintf(fi,'Friedman, p=%d, df_grps=%d, df_err=%d, chi2=%d\n',stats.(currname).all.p,...
            stats.(currname).all.tbl{2,3}, stats.(currname).all.tbl{3,3}, stats.(currname).all.tbl{2,5}...
    );
        fprintf(fi,'mean ranks: '); fprintf(fi,'%d,',stats.(currname).all.st.meanranks);
        fprintf(fi,'n=');
        for i=1:numel(stats.(currname).all.st.n)
            fprintf(fi,' %d',stats.(currname).all.st.n(i));
        end
        fprintf(fi,'\n');

        fprintf(fi,'\nPair-wise rank-sum, p=:\n');
        addTableToFile(fi,stats.(currname).pw,labs);
        fprintf(fi,'\n');
    end    

end