function stats = plotTrigMSNSynchronyProportion(peakmvmt,c,recenter)

fields = fieldnames(peakmvmt);
for f=1:numel(fields)
    n.(fields{f}) = [peakmvmt.(fields{f}).npeaks]*[peakmvmt.(fields{f}).npairs]';
    p.(fields{f}) = sum(cat(2,peakmvmt.(fields{f}).msn),2)/n.(fields{f});
    inds.(fields{f}) = cat(1,peakmvmt.(fields{f}).peakinds);
end
radius = (size(p.(fields{1}),1)-1)/2;

% wald test

% now do bar plot comparing any vs chi vs fsi....

errprop = @(err,errcorr) sqrt((sum(err.^2) + 2*errcorr))/length(err);

errfx = @(p,n) sqrt(p.*(1-p)/n);

% find standard errors for all postinds
p2.chi = [mean(inds.chi,1)];
p2.msn = [mean(inds.msn,1)];
p2.fsi = [mean(inds.fsi,1)];

if nargin < 2 || isempty(c)
    c.chi = cov(inds.chi(:,1),inds.chi(:,2))/(size(inds.chi,1));
    c.msn = sparsecov(inds.msn(:,1),inds.msn(:,2))/(size(inds.msn,1)); % note: could also use p_B-p_1*p_2 (from wikipedia)
    c.fsi = cov(inds.fsi(:,1),inds.fsi(:,2))/(size(inds.fsi,1));
    save('processedData/mousesynchrony_cov_of_mn.mat','c');
end
assert(~any(isnan(inds.msn(:))));
assert(~any(isnan(inds.fsi(:))));
assert(~any(isnan(inds.chi(:))));

% get standard error of mean
e1.chi = std(inds.chi,[],1)/sqrt(size(inds.chi,1));
e1.msn = sqrt([c.msn(1,1) c.msn(2,2)]*size(inds.msn,1))/sqrt(size(inds.msn,1)); % check this line
e1.fsi = std(inds.fsi,[],1)/sqrt(size(inds.fsi,1));

e2.msn = errprop(e1.msn, c.msn(1,2));
e2.chi = errprop(e1.chi, c.chi(1,2));
e2.fsi = errprop(e1.fsi, c.fsi(1,2));

p1.chi = mean(p2.chi,2);
p1.msn = mean(p2.msn,2);
p1.fsi = mean(p2.fsi,2);

e.fsi = errfx(p.fsi,n.fsi);
e.msn = errfx(p.msn,n.msn);
e.chi = errfx(p.chi,n.chi);

if nargin > 2 && recenter
    for f=1:numel(fields)
       p1.(fields{f}) = p1.(fields{f})-p.(fields{f})(radius+1); 
       p.(fields{f}) = p.(fields{f}) - p.(fields{f})(radius+1);
    end
end

c2 = ztestpw([p1.fsi p1.chi p1.msn],[e2.fsi e2.chi e2.msn]);
c2(:,3) = (c2(:,3)*3);
stats.pw = table(c2(:,1),c2(:,2),c2(:,3),c2(:,4),'VariableNames',{'Grp1','Grp2','pval', 'zval'});
stats.labels = {'FSI','CHI','MSN'};

stats.probs = full([p1.fsi p1.chi p1.msn]);
stats.n.fsi = size(inds.fsi,1);
stats.n.chi = size(inds.chi,1);
stats.n.msn = size(inds.msn,1);


%% now plot everything
figure
bar(1:3,([mean(any(inds.chi,2)), mean(any(inds.msn,2)), mean(any(inds.fsi,2))]));
ylabel('Proportion synchronous')
set(gca,'XTickLabel',{'CHI-MSNMSN','MSN-MSNMSN', 'FSI-MSNMSN'});
legend('100 ms post');
savePDF(gcf,sprintf('figures/%s/triggered_synchrony_bar.pdf',date));

taxis = (-50:50)*.0469;

%compute error bars

figure
shadedErrorBar(taxis, p.chi,e.chi,'g');
hold on;
shadedErrorBar(taxis, p.msn,e.msn,'b');
shadedErrorBar(taxis, p.fsi,e.fsi,'r');
ax = gca;
xlabel('Time [s]');
ylabel('Proportion synchronous');
legend([ax.Children(2),ax.Children(6),ax.Children(10)], {'FSI','MSN','CHI'});
savePDF(gcf,sprintf('figures/%s/triggered_synchrony_shadederrorbar_pctchange.pdf',date));


end