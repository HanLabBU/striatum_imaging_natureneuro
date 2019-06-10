function plot_bin_vals_peakfluor_rescaled_box(peakfluor,x_lab)
    fnames = fieldnames(peakfluor);
    radius = (size(peakfluor.(fnames{1}),1)-1)/2;
    bins = [-2 -1 0 1 2 3 4];
    taxis = (-radius:radius)*0.0469;
    
    for i=1:numel(fnames)
        binfluor.(fnames{i}) = [];
    end
    vals = [];
    
    for f=1:numel(fnames)    
        for b=1:(length(bins)-1)
           inds = (taxis >= bins(b) & taxis < bins(b+1));
           currfluor = peakfluor.(fnames{f})(inds,:);
           
           binfluor.(fnames{f}) = cat(1,binfluor.(fnames{f}),nanmean(currfluor,1));
        end
        vals = cat(2,vals,num2cell(binfluor.(fnames{f}),2));
    end
    
    [f,l] = box_err(vals);
    legend(l,fnames,'location','northwest');
    set(f,'XTickLabels',cellfun(@num2str, num2cell(bins(1:end-1)),'uniformoutput',false));
    xlabel(x_lab);
    ylabel('\DeltaF/F');
end