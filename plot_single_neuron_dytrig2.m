function plot_single_neuron_dytrig2(cdata)
fields = fieldnames(cdata);
X = [];
Xerr = [];
err = @(x) sqrt(mean(x)*(1-mean(x))/length(x));
for f=1:numel(fields)
prop.(fields{f}).pos = sum(cdata.(fields{f}).pos)/length(cdata.(fields{f}).pos);
prop.(fields{f}).neg = sum(cdata.(fields{f}).neg)/length(cdata.(fields{f}).neg);
prop.(fields{f}).non = 1-(prop.(fields{f}).pos + prop.(fields{f}).neg);
X = cat(1,X,[prop.(fields{f}).pos prop.(fields{f}).neg prop.(fields{f}).non]);
Xerr = cat(1,Xerr, [err(cdata.(fields{f}).pos(:)), err(cdata.(fields{f}).neg(:)), err(~(cdata.(fields{f}).pos(:) | cdata.(fields{f}).neg(:)))]);
end

bar_err(1:3,X,Xerr);
set(gca,'XTickLabel',{'MSN','FSI','CHI'});
legend({'Pos-related','Neg-related','Non-related'})
savePDF(gcf,sprintf('figures/%s/pos_neg_related_bar.pdf',date));
end