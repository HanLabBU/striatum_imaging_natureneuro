function addTableToFile(fi, tbl,labs)
col = size(tbl,1);
row = size(tbl,2);
for r=1:numel(labs.row)
    fprintf(fi,'\t%s',labs.row{r});
end
fprintf(fi,'\n');
for i=1:col
    fprintf(fi, '%s\t', labs.col{i});
    for j=1:row
        fprintf(fi,'\t%.2d',tbl(i,j));
    end
    fprintf(fi,'\n');
end

end