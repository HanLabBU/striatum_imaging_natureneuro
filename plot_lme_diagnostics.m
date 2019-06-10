function plot_lme_diagnostics(mdl,tbl,group)


subplot(2,2,1)
qqplot(mdl.residuals);
title('');
subplot(2,2,2)
plot(fitted(mdl),mdl.residuals,'.');
xlabel('Fitted values');
ylabel('Residuals');

subplot(2,2,3)
boxplot(mdl.residuals,tbl.(group));
ylabel('Residuals');
set(gca,'XTickLabelRotation',90);
xlabel('Mouse ID');

subplot(2,2,4);
histogram(mdl.residuals,50,'normalization','probability');
xlabel('Residual');
ylabel('Probability');
end