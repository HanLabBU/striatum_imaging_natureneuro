function write_opto_synchrony(fi,tbl)
list = {'chi','fsi','msn'};

fprintf(fi,'--------------------------------\n');
fprintf(fi,'Opto triggered synchrony;\n');
for i=1:size(tbl,1)
   fprintf(fi,'n(%s)=%d\n',list{i},tbl(i,5)); 
end
fprintf(fi,'\nPairwise z-tests:\n');
for i=1:size(tbl,1)
   fprintf(fi,'%s vs %s: z=%f, p=%f\n',list{tbl(i,1)},list{tbl(i,2)},tbl(i,4),tbl(i,3));
end

end