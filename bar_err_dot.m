function bar_err_dot(y)
y_mn = cellfun(@(x) nanmean(x,1),y,'uniformoutput',false);
y_mn = cat(1,y_mn{:});
xll = cellfun(@(x) serrMn(x,1),y,'uniformoutput',false);
xll = cat(1,xll{:});
x = 1:length(y_mn);
b = bar(x,y_mn'); % b(i).XOffset is a thing, thanks to https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
hold on;
xul = xll;
if numel(b) == 1
    plot_all_samples(1,y{1},[0 0 0]);
else
    for j=1:numel(b)
        plot_all_samples(x, y{j},b(j).CData(1,:));
    end
end
b2 = bar(x,y_mn'); % b(i).XOffset is a thing, thanks to https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
if numel(b) == 1
    errorbar(x,y_mn',xll',xul','.k','LineWidth',1);
    b2.FaceColor = b.FaceColor;
else
    for j=1:numel(b)
        errorbar(x+b(j).XOffset,y_mn(j,:),xll(j,:),xul(j,:),'.k','LineWidth',1);
        b2(j).FaceColor = b(j).FaceColor;
    end
end

hold off
end

function plot_all_samples(x,y,col)

for i=1:size(y,1)
    plt = plot(x,y(i,:),'color',col);
    plt.Color(4) = 1/(log(size(y,1)+1));
end

end