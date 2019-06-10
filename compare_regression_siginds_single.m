function [c,X,y] = compare_regression_siginds_single(mouseno, inttype)

    
% test chi examples
    [~, c.pos,X.pos,y.pos] = regression_model_train_siginds(mouseno, inttype,{'intercept','int'},'pos');
    [~, c.neg,X.neg,y.neg] = regression_model_train_siginds(mouseno, inttype,{'intercept','int'},'neg');

end