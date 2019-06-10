function [X, Y, labs] = make_dummy_mat(varargin)
X = [];
Y = [];
labs = [];
numdatapts = 0;
for j=1:nargin
    numdatapts = numdatapts + length(varargin{j});
end

for j=1:nargin;
    Y = cat(1,Y,varargin{j});
    labs = cat(1,labs,j*ones(length(varargin{j}),1));
    newx = zeros(length(varargin{j}),nargin);
    newx(:,j) = deal(1);
    X = cat(1,X,newx);
end
end