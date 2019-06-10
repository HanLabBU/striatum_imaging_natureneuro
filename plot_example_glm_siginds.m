function plot_example_glm_siginds(samples,inttype)
fnames = fieldnames(samples);

inds1 = cellfun(@(x) ~isempty(x), samples.(fnames{1}));

inds2 = cellfun(@(x) ~isempty(x), samples.(fnames{2}));

validinds = find(inds1 & inds2);

dt = 0.1;
suffix = mouseSuffix('good');
for f=1:numel(fnames)
    currsamples = samples.(fnames{f});
   for m=validinds'
       if ~isempty(currsamples{m})
            for j=1:size(currsamples{m}.int.pred,2)
                figure;
                taxis = dt*(0:1:(length(currsamples{m}.y)-1));
                plot(taxis, currsamples{m}.y);
                hold on;
                plot(taxis, currsamples{m}.int.pred(:,j));
                legend('Speed','Predicted');
                title(sprintf('%s: %s-modulated %s %d',suffix{m},fnames{f},upper(inttype),j));
                savePDF(gcf,sprintf('figures/%s/%s_%s-modulated_%s_speedregression_%d.pdf',date,suffix{m},fnames{f},inttype,j));
            end
       end
   end
end

end
