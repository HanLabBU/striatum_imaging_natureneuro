function b2 = box_err_line(y)
x = 1:size(y{1},2);
boxplot(y{:},'symbol','','colors','k'); % b(i).XOffset is a thing, thanks to https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
hold on;
if numel(y) == 1
    plot_all_samples(x,y{1},[0 0 0]);
else
    for j=1:numel(y)
        plot_all_samples(x, y{j},'k');
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