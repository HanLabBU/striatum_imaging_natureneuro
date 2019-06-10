function addTriggeredFluorescence(fi,stats, pv)

fprintf(fi,'\tsign test (pre-vs-post):\n');
fields = fieldnames(stats);
for f=1:numel(fields)
fprintf(fi,'\t %s: stat=%d, p=%d, n=%d, ties=%d, direction (pre %s post)\n',upper(fields{f}), stats.(fields{f}).sign,pv.(fields{f}), stats.(fields{f}).n, stats.(fields{f}).ties, stats.(fields{f}).direction);
end

end