function write_signtest_2_file(fi,p,st)
fprintf(fi,'\nSign-test\n');
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
fprintf(fi,'n: %d\n',st.n);
fprintf(fi,'sign: %d\n',st.sign);
fprintf(fi,'ties: %d\n',st.ties);
if strcmp(st.direction,'>')
    fprintf(fi,'X is greater than Y\n');
elseif strcmp(st.direction,'<')
    fprintf(fi,'Y is greater than X\n');
else
    fprintf(fi,'Y equals X\n');
end


end