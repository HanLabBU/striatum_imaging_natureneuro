% func_handle must be a handle to one of dyTriggeredActivityAll,
% dyTriggeredFluorescenceAll
function [peaksAll, sigInds] = triggeredActivityAll(func_handle, mouse, radius,nosamples)

    BYMOUSE = 0;
    
    suffix = mouseSuffix(mouse);
    
    %initialize output
    peaksAll.mvmt = zeros(radius*2+1, 0);
    peaksAll.rot = zeros(radius*2+1,0);
    peaksAll.msn = zeros(radius*2+1,0);
    peaksAll.chi = zeros(radius*2+1,0);
    peaksAll.fsi = zeros(radius*2+1,0);
    sigInds.pos = struct('msn',[],'chi',[],'fsi',[]);
    sigInds.neg = struct('msn',[],'chi',[],'fsi',[]);
    
    for conditionNo = 1:length(suffix)
        % run function, and concatenate outputs for all fields
        [peakMovement, sigIndsAll] = func_handle(suffix{conditionNo}, radius,nosamples);            
        sigInds.pos.msn = logical(cat(1, sigInds.pos.msn, (sigIndsAll.msn.pos)));
        sigInds.pos.chi = logical(cat(1, sigInds.pos.chi, (sigIndsAll.chi.pos)));
        sigInds.pos.fsi = logical(cat(1, sigInds.pos.fsi, (sigIndsAll.fsi.pos)));
        
        sigInds.neg.msn = logical(cat(1, sigInds.neg.msn, (sigIndsAll.msn.neg)));
        sigInds.neg.chi = logical(cat(1, sigInds.neg.chi, (sigIndsAll.chi.neg)));
        sigInds.neg.fsi = logical(cat(1, sigInds.neg.fsi, (sigIndsAll.fsi.neg)));

        peaksAll.msn = cat(2,peaksAll.msn, peakMovement.msn);
        peaksAll.chi = cat(2,peaksAll.chi, peakMovement.chi);
        peaksAll.fsi = cat(2, peaksAll.fsi, peakMovement.fsi);
        
        peaksAll.mvmt = cat(2,peaksAll.mvmt, peakMovement.mvmt);
        if isfield(peakMovement,'rot')
            peaksAll.rot = cat(2,peaksAll.rot, peakMovement.rot);
        end
    end
end