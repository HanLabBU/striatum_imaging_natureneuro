function [p, stats] = ranksum_explicit(x,y,plt)
if all(isnan(x)) || all(isnan(y))
    p = nan;
    stats.ranksum = nan;
    stats.direction = nan;
    return
end

[pl, ~,stl] = ranksum(x,y,'tail','left');
[pr, ~,str] = ranksum(x,y,'tail','right');
stats.nx = numel(x(~isnan(x)));
stats.ny = numel(y(~isnan(y)));
[p,i] = min([pl,pr]);
[p,~,st] = ranksum(x,y);
stats.ranksum = st.ranksum;
if isfield(st,'zval')
    stats.zval = st.zval;
end
if i == 1
    stats.direction = '<';
elseif i == 2
    stats.direction = '>';
end

if nargin > 2 && plt
if numel(x) < 20
    wid.x = 10;
elseif numel(x) < 100
    wid.x = 30;
elseif numel(x) < 1000
    wid.x = 50;
else
    wid.x = 100;
end
if numel(y) < 20
    wid.y = 10;
elseif numel(y) < 100
    wid.y = 30;
elseif numel(y) < 1000
    wid.y = 50;
else
    wid.y = 100;
end
figure;
histogram(x,wid.x,'displaystyle','stairs','normalization','probability');
hold on
histogram(y,wid.y,'displaystyle','stairs','normalization','probability');
legend('x','y');
end