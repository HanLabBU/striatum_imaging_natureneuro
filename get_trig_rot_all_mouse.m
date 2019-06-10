function [chi, fsi] = get_trig_rot_all_mouse(mouseno)
suffix = mouseSuffix(mouseno);
mice = cellfun(@(x) regexp(x,'^([0-9]*)','match'),suffix);
radius = 50;

chi.chi = [];
chi.msnchi = [];
chi.labelchi = cell(0);
chi.labelmsn = cell(0);

fsi.msnfsi = [];
fsi.fsi = [];
fsi.labelfsi = cell(0);
fsi.labelmsn = cell(0);


for m=1:numel(suffix)
    currmouse = loadMouse(suffix(m));
    msnfluor = roiTriggeredRot({suffix{m}},radius,'msn');
    msnfluor.rot = squeeze(msnfluor.rot);
    nsamples.msn = size(msnfluor.rot,2);
    
    if currmouse.isCHI
        chifluor = roiTriggeredRot({suffix{m}},radius,'chi');
        chifluor.rot = squeeze(chifluor.rot);
        nsamples.chi = size(chifluor.rot,2);
        
        chi.chi = cat(2,chi.chi,chifluor.rot);
        chi.labelchi = cat(1,chi.labelchi,repmat(mice(m),nsamples.chi,1));
        
        chi.msnchi = cat(2,chi.msnchi, msnfluor.rot);
        chi.labelmsn = cat(1,chi.labelmsn,repmat(mice(m),nsamples.msn,1));
    else
        fsifluor = roiTriggeredRot({suffix{m}},radius,'fsi');
        fsifluor.rot = squeeze(fsifluor.rot);
        nsamples.fsi = size(fsifluor.rot,2);
        
        fsi.fsi = cat(2, fsi.fsi, fsifluor.rot);
        fsi.labelfsi = cat(1,fsi.labelfsi,repmat(mice(m),nsamples.fsi,1));
        
        fsi.msnfsi = cat(2,fsi.msnfsi, msnfluor.rot);
        fsi.labelmsn = cat(1,fsi.labelmsn, repmat(mice(m),nsamples.msn,1));
    end
end



end