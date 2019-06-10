% function [stats] = compare_glm_siginds(c_all_msnpos, c_all_msnneg, c_all_int, c_sample_msn, c_msn_single, c_int_single, isCHI)
function [st] = compare_glm_siginds_single(c_single_pos, c_single_neg)

% average over all folds
c_int_mn_neg = cellfun(@(x) nanmean(x), c_single_neg.allint);
c_int_mn_pos = cellfun(@(x) nanmean(x), c_single_pos.allint);

% gather all data for friedman test
X = [c_int_mn_neg, c_int_mn_pos];
naninds = isnan(sum(X,2));
X(naninds,:) = [];
[st.p, st.st] = signtest_explicit(X(:,1),X(:,2));

st.labels = {'Int (-)', 'Int (+)', };

% plot bar graph
figure;
% if size(X,1) <= 10
box_err_line([{X}]);
% else
%     bar_err(1:2, [mean(X(:,1)), mean(X(:,2))], ...
%     [mean(X(:,1)), serrMn(X(:,2))]);
% end
set(gca,'XTickLabel',st.labels);
set(gca,'XTickLabelRotation',45);
end