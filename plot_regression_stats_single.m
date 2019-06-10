function st = plot_regression_stats_single(c,inttype)
    
    c_mn.pos = mean(c.pos,2);
    c_mn.neg = mean(c.neg,2);
    
    naninds = isnan(c_mn.pos) | isnan(c_mn.neg);
    
    c_mn.pos(naninds) = [];
    c_mn.neg(naninds) = [];
    
    %first, plot for fsi mice. 
    figure
%     if size(c_mn.pos,1) <= 10
      box_err_line([{[c_mn.pos c_mn.neg]}]);
%     else
%         errs = [serrMn(c_mn.pos), serrMn(c_mn.neg)];
%         bar_err(1:2,[nanmean(c_mn.pos) nanmean(c_mn.neg)],...
%             errs, errs);
%     end
    set(gca,'XTickLabels',{'(+) modulated','(-) modulated'});
    set(gca,'XTickLabelRotation',45);
    title(inttype);
    savePDF(gcf,sprintf('figures/%s/regression_bar_%s_split.pdf',date,inttype));
    
    [st.p,st.st] = signtest_explicit(c_mn.pos,c_mn.neg);
    
end