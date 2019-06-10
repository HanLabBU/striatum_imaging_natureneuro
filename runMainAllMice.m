
mouseList = mouseSuffix('good');
mouseTrialTypes = mouseList;
% run this code once you have created files of type/name roi_pre_
% SUFFIX.mat which have ROI traces and their identities as chis or
% msns. Also, you must have created a bad_traces_SUFFIX.mat file for each
for mtrial = 1:length(mouseTrialTypes)
    disp(['starting mouse ' num2str(mtrial)]);
    makePreMouseData(mouseTrialTypes{mtrial});
    activationState = getActivationStatePreInf(mouseList{mtrial}, 3);
    save(['processedData/activityTraces/activation_state_dynamic_' mouseList{mtrial} '.mat'],'activationState');
    activationState = getActivationStateBroad(mouseList{mtrial}, 2);
    save(['processedData/activityTraces/activation_state_broad_' mouseList{mtrial} '.mat'],'activationState');
end

%%
for mtrial = 1:length(mouseTrialTypes)
%     disp(['starting mouse ' num2str(mtrial)]);
%     makePreMouseData(mouseTrialTypes{mtrial});
    activationStateDyn = getActivationStatePreInf(mouseList{mtrial}, 3);
    load('activationStateDynamic_%s.mat',mouselist{mtrial});
    activationStateBro = getActivationStateBroad(mouseList{mtrial}, 2);
    load('activationStateBroad_%s.mat',mouselist{mtrial});

end