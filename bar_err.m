function bar_err(x,y,xll,xul)
b = bar(x,y); % b(i).XOffset is a thing, thanks to https://www.mathworks.com/matlabcentral/answers/203782-how-to-determine-the-x-axis-positions-of-the-bars-in-a-grouped-bar-chart
hold on;
if nargin == 3
    xul = xll;
end
if numel(b) == 1
    errorbar(x,y,xll,xul,'.k','LineWidth',1);
else
    for j=1:numel(b)
        errorbar(x+b(j).XOffset,y(:,j),xll(:,j),xul(:,j),'.k','LineWidth',1);
    end
end
hold off
end