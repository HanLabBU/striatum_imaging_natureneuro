function print_pairwise_fishertest(fi,st,siginds)

fprintf(fi,'Fisher test results, proportion of neurons positively modulated prior to movement onset (Bonferroni corrected\n');

for f=1:numel(st)
    fprintf(fi,'p=%f, odds ratio = %f, n%s=%d;n%s=%d\n\n',st(f).p,st(f).st.OddsRatio,...
        st(f).comparison{1},sum(~isnan(siginds.(st(f).comparison{1}))),st(f).comparison{2},sum(~isnan(siginds.(st(f).comparison{2})))); 
    close all
end
 fprintf(fi,'\n-----------------------------------------------------\n');


end