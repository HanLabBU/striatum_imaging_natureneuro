function write_bs_2_file(fi,p,st)
fprintf(fi,'\nClustering-test\n');
fprintf(fi,'p-value: %d',p);
if p < 0.05
    fprintf(fi,'*');
    if p < 0.01
        fprintf(fi,'*');
        if p < 0.001
            fprintf(fi,'*');
        end
    end
end
fprintf(fi,'\n');
fprintf(fi,'Jaccard index: %d\n',st);
end