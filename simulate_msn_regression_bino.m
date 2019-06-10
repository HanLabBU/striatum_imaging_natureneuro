b_chi = cell(100,1);
c_chi = cell(100,1);
b_fsi = cell(100,1);
c_fsi = cell(100,1);

parfor i=1:100
    [b_chi{i}, test_data_chi] = regression_model_train_bin('good', 1, 'chi',{'intercept','msn'});
    c_chi{i} = regression_model_test(b_chi{i}, test_data_chi,0);
    [b_fsi{i}, test_data_fsi] = regression_model_train_bin('good', 1, 'fsi',{'intercept','msn'});
    c_fsi{i} = regression_model_test(b_fsi{i}, test_data_fsi,0);
    fprintf('done with %d\n',i);
end

save('regression_msn_sim_bino.mat','c_chi','b_chi','b_fsi','c_fsi','-v7.3');