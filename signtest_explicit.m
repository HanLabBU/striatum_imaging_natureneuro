function [p, stats] = signtest_explicit(x,y,threshold,plt)
if nargin > 2 && threshold
   a = abs(x-y);
   m = mean(abs([x y]),2);
   a = a./m;
   f = find((x ~= y) & a < 10e-17);
   x(f) = 0; y(f) = 0;
   fprintf('Removing %d indices from test\n',numel(f));
end
[pr, ~,str] = signtest(x,y,'tail','right');
[pl,~,stl] = signtest(x,y,'tail','left');
[p,i] = min([pr,pl]);
p = p*2;
if i == 1
    st = str;
    stats.direction = '>';
else
    st = stl;
    stats.direction = '<';
end

n = length(x(~isnan(y-x) & ~((y-x) == 0)));
stats.n = n;
stats.sign = st.sign;
stats.ties = sum(y == x);

if nargin > 3 && plt
    figure;
    if numel(x) < 20
        wid.x = 10;
    elseif numel(x) < 100
        wid.x = 30;
    else
        wid.x = 50;
    end

    histogram(x,wid.x,'displaystyle','stairs','normalization','probability');
    hold on
    histogram(y,wid.x,'displaystyle','stairs','normalization','probability');
    legend('x','y');
end
end