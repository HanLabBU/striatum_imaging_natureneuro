function plotCorrScatter(corrdata,sigonly)
fields = fieldnames(corrdata);
scaling = 1.3;
for f=numel(fields):-1:1
    if isempty(corrdata.(fields{f}))
        fields(f) = [];
    end
end

for f = 1:numel(fields)
    currfield = fields{f};
    subplot(2,2,f)
    d = cat(1,corrdata.(currfield).d2{:})*scaling;
    d = bsxfun(@times,d, datasample([-1 1], length(d))');
    if sigonly
        p = pvalue(corrdata.(currfield));
        inds = find(p <.05);
    else
        inds = 1:size(d,1);
    end
    scatter(d(inds,1),d(inds,2),2,...
        corrdata.(currfield).rho(inds),'filled','d');
        xlim([-1000 1000]);
    ylim([-1000 1000]);
    title(upper(currfield));
    caxis([0 .8])
%     colorbar
end

end

function p = pvalue(celltype)
    p = 1-sum(bsxfun(@lt, celltype.zval,celltype.rho),2)./size(celltype.zval,2);
end