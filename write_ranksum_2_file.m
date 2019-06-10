function write_ranksum_2_file(fi,p,st)
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
fprintf(fi,'nx: %d, ny: %d\n',st.nx,st.ny);
fprintf(fi,'ranksum: %d\n',st.ranksum);
if strcmp(st.direction,'>')
    fprintf(fi,'X is greater than Y\n');
elseif strcmp(st.direction,'<')
    fprintf(fi,'Y is greater than X\n');
else
    fprintf(fi,'Y equals X\n');
end


end