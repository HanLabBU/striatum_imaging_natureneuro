
%computes correlation between columns n_i and n_i, n_(i+1) and n_(i+1), ...
%in X1 and X2. X1 and X2 are matrices with columns = neuron, rows = sample 
function C = corr_fast(X1,X2) %formula from wikipedia
%make each neuron's samples zero mean
X1 = bsxfun(@minus,X1,mean(X1,1));
X2 = bsxfun(@minus,X2,mean(X2,1));

%compute standard deviation of each neuron's samples (column-wise)
sig1 = sqrt(sum(X1.^2,1));
sig2 = sqrt(sum(X2.^2,1));

%compute correlation coefficient by summing the product of zero-mean
%samples at each point in time, and dividing point-wise by standard
%deviation
C = sum(X1.*X2,1)./(sig1.*sig2);
C = C';
if any(isnan(X1 + X2))
   error('found a nan'); 
end
end