function writeSSToFile(fi, statstruct, t)
    fprintf(fi,'-------------------------------------------------\n');
    fprintf(fi,'%s\n',t);
    fprintf(fi,'\nKruskal-wallis test, over all time periods\n');    
    fprintf(fi,'All df=%d (groups), %d (error); chi2 = %d; p-value=%d, n=%d %d %d\n',statstruct.all.df(1),statstruct.all.df(2),statstruct.all.chi2, statstruct.all.p, statstruct.all.n);
     fprintf(fi,'\nKruskal-wallis test, over hi speed time periods\n');    
    fprintf(fi,'All df=%d (groups), %d (error); chi2 = %d; p-value=%d, n=%d %d %d\n',statstruct.hi.df(1),statstruct.hi.df(2),statstruct.hi.chi2, statstruct.hi.p, statstruct.hi.n);
   fprintf(fi,'\nKruskal-wallis test, over low speed time periods\n');    
    fprintf(fi,'All df=%d (groups), %d (error); chi2 = %d; p-value=%d, n=%d %d %d\n',statstruct.lo.df(1),statstruct.lo.df(2),statstruct.lo.chi2, statstruct.lo.p, statstruct.lo.n);
 
    
    
    labs.col = {'msn','chi','fsi'};
    labs.row = {'msn','chi','fsi'};

    fprintf(fi,'\nPost-hoc, pairwise during all time periods, w/ p-values\n');
    fprintf(fi,sprintf('%s\t',statstruct.pw.labelsbyspeed{:})); fprintf(fi,'\n');
    labels.row = statstruct.pw.labelsbyspeed;
    labels.col = labels.row;
    appendTable(fi,statstruct.pw.all.p, labels);


    labs.col = {'All','Hi','Lo'};
    labs.row = labs.col;
    fprintf(fi,'\nSign test for MSNs, p-values, hi vs low\n');
    fprintf(fi,'p=%d; sign=%d, (hi,lo)=%s, n=(%d), ties=%d\n',statstruct.pw.msn.p, statstruct.pw.msn.stats.sign, statstruct.pw.msn.stats.direction, statstruct.pw.msn.stats.n, statstruct.pw.msn.stats.ties);

    fprintf(fi,'\nSign test for CHIs, p-values, hi vs low\n');
    fprintf(fi,'p=%d; sign=%d, (hi,lo)=%s, n=(%d), ties=%d\n',statstruct.pw.chi.p, statstruct.pw.chi.stats.sign,statstruct.pw.chi.stats.direction, statstruct.pw.chi.stats.n, statstruct.pw.chi.stats.ties);

    fprintf(fi,'\nSign test for FSIs, p-values, hi vs low\n');
    fprintf(fi,'p=%d; sign=%d, (hi,lo)=%s,, n=(%d), ties=%d\n',statstruct.pw.fsi.p, statstruct.pw.fsi.stats.sign,statstruct.pw.fsi.stats.direction, statstruct.pw.fsi.stats.n, statstruct.pw.fsi.stats.ties);
 
    fprintf(fi,'-------------------------------------------------\n');
    
end
