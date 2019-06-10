function plot_corr_bar_2_mdl(mdl)

% now plot
coefcovar = mdl.CoefficientCovariance;
ests = mdl.Coefficients.Estimate;

contrast.msn1 = [1 0 0 0 0 0];
contrast.fsi1 = [1 0 0 1 0 0];
contrast.chi1 = [1 0 1 0 0 0];

contrast.msn2 = [1 1 0 0 0 0];
contrast.fsi2 = [1 1 0 1 0 1];
contrast.chi2 = [1 1 1 0 1 0];

first.msn = ests'*contrast.msn1';
first.chi = ests'*contrast.chi1';
first.fsi = ests'*contrast.fsi1';

second.msn = ests'*contrast.msn2';
second.chi = ests'*contrast.chi2';
second.fsi = ests'*contrast.fsi2';


err1.msn = sqrt(contrast.msn1*coefcovar*contrast.msn1');
err1.chi = sqrt(contrast.chi1*coefcovar*contrast.chi1');
err1.fsi = sqrt(contrast.fsi1*coefcovar*contrast.fsi1');

err2.msn = sqrt(contrast.msn2*coefcovar*contrast.msn2');
err2.chi = sqrt(contrast.chi2*coefcovar*contrast.chi2');
err2.fsi = sqrt(contrast.fsi2*coefcovar*contrast.fsi2');


bar_err(1:2,[first.msn first.chi first.fsi; ...
    second.msn second.chi second.fsi], ...
    [err1.msn, err1.chi, err1.fsi;...
    err2.msn err2.chi err2.fsi]);
set(gca,'XTickLabel',{'<100 um','(750-1500 um)'});
legend({'MSN','CHI','FSI'});
ylabel('Difference in proportion significantly correlated');
savePDF(gcf,sprintf('figures/%s/difference_in_proportion_correlated.pdf',date));
end