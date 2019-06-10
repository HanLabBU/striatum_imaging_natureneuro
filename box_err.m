function [ax,l] = box_err(X,scatt)
within_step = 1/(size(X,2)+1);
d = distinguishable_colors(size(X,2),'w');
if size(d,1) == 3
    temp = d(2,:);
    d(2,:) = d(3,:);
    d(3,:) = temp;
end
steps = within_step:within_step:(1-within_step);
widths = 1/(size(X,2)+5);
l = nan(size(X,2),1);
maxval = 0;
minval = 0;
for i=1:size(X,2)
    G = cellfun(@(x) x(:),X(:,i),'uniformoutput',false);
    low_number = find(cellfun(@(x) sum(~isnan(x(:))) < 10, G));
    if any(low_number)
        warning('Low number!');
    end
    if nargin > 1 && scatt
        low_number = 1:numel(G);
    end
    [~,val,grp] = make_dummy_mat(G{:});
    if i == 1
        boxplot(val,grp,'positions',[1:numel(unique(grp))]+steps(i),'colors',d(i,:),'widths',widths,'symbol','');
        hold on
        for q=1:numel(low_number)
            curry = G{low_number(q)};
            positions = jitter_overlaps(low_number(q) + steps(i),curry,widths); 
            plot(positions,curry,'.k','MarkerSize',10);
            maxval = max([maxval, curry(:)']);
            minval = min([minval, curry(:)']);
        end
        ax = gca;
    else
        boxplot(ax,val,grp,'positions',[1:numel(unique(grp))]+steps(i),'colors',d(i,:),'widths',widths,'symbol','');
        for q=1:numel(low_number)
            curry = G{low_number(q)};
            positions = jitter_overlaps(low_number(q) + steps(i), curry,widths);
            plot(positions,curry,'k','MarkerSize',10);
            maxval = max([maxval, curry(:)']);
            minval = min([minval, curry(:)']);
        end
    end
    l(i) = line(0,0,'color',d(i,:));
end
xlim([1 size(X,1)+1])
hold off
h = findobj(gcf,'tag','Upper Whisker');
h2 = findobj(gcf,'tag','Lower Whisker');
ylim([min([h2.YData minval])-.1*abs(nanmedian([h.YData])) max([h.YData maxval])*1.1]);
 % b(i).XOffset is a thing, thanks to https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
ax.XTick = [1:size(X,1)]+.5;
end

function positions = jitter_overlaps(position, yvals, width)
positions = ones(size(yvals))*position;
u = unique(yvals);
for i=1:numel(u)
    relevant_inds = find(yvals == u(i));
    n_inds = length(relevant_inds);
    jitter = width/(n_inds+1);
    curr_positions = position + (1:n_inds)*jitter-mean(1:n_inds)*jitter;
    for j=1:numel(relevant_inds)
        positions(relevant_inds(j)) = curr_positions(j);
    end
end
end