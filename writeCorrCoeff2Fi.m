function writeCorrCoeff2Fi(fi,corrstats)
fields = fieldnames(corrstats);
for f=1:length(fields)
    currfield = fields{f};
    currstats = corrstats.(currfield);
    fprintf(fi,'Rank-sum test, %s: p=%d, ranksum=%d, n(bin1)=%d, n(bin2)=%d\n',currfield, currstats.rs.p, ...
            currstats.rs.rs.ranksum,currstats.rs.rs.nx,currstats.rs.rs.ny);
    fprintf(fi,'Sign-test, close %s %s control: p=%d, sign=%d, n=%d, ties=%d\n',currfield,currstats.sn.close.st.direction,currstats.sn.close.p,...
        currstats.sn.close.st.sign, currstats.sn.close.st.n, currstats.sn.close.st.ties);
     fprintf(fi,'Sign-test, far %s %s control: p=%d, sign=%d, n=%d, ties=%d\n',currfield,currstats.sn.far.st.direction, currstats.sn.far.p,...
        currstats.sn.far.st.sign, currstats.sn.far.st.n, currstats.sn.far.st.ties);
    fprintf(fi,'\n\n\n');
end



end