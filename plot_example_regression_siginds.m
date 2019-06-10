function plot_example_regression_siginds(X,y,inttype)
fnames = fieldnames(X);

examples = X.(fnames{1});
example2 = X.(fnames{2});

validinds1 = cellfun(@(x) ~isempty(x),examples);
validinds2 = cellfun(@(x) ~isempty(x),example2);

validinds = find(validinds1 & validinds2);

dt = 0.1;
suffix = mouseSuffix('good');
for f=1:numel(fnames)
   for m=1:numel(X.(fnames{f}))
       if ismember(m,validinds)
            b = regress(y.(fnames{f}){m},X.(fnames{f}){m});
            figure;
            taxis = dt*(0:1:(length(y.(fnames{f}){m})-1));
            plot(taxis, y.(fnames{f}){m});
            hold on;
            plot(taxis, X.(fnames{f}){m}*b);
            legend('MSN','Predicted');
            title(sprintf('%s: %s-modulated %s',suffix{m},fnames{f},upper(inttype)));
            savePDF(gcf,sprintf('figures/%s/%s_%s-modulated_%s_msnregression.pdf',date,suffix{m},fnames{f},inttype));
       end
   end
end

end
