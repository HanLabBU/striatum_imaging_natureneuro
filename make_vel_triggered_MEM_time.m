function tbl = make_vel_triggered_MEM_time(peakfluor,mouseid,roiid, eventid)
    radius = (size(peakfluor.msn,1)-1)/2;
    bins = [-2 -1 0 1 2 3 4];
    taxis = (-radius:radius)*0.0469;
    
    fnames = fieldnames(peakfluor);
    
    binfluor = struct('msn',[],'fsi',[],'chi',[]);
    mouseall = struct('msn',[],'fsi',[],'chi',[]);
    roiidall = struct('msn',[],'fsi',[],'chi',[]);
    binidall =  struct('msn',[],'fsi',[],'chi',[]);
    eventidall = struct('msn',[],'fsi',[],'chi',[]);

    for f=1:numel(fnames)    
        for b=1:(length(bins)-1)
           inds = (taxis >= bins(b) & taxis < bins(b+1));
           currfluor = peakfluor.(fnames{f})(inds,:);
           
           binfluor.(fnames{f}) = cat(1,binfluor.(fnames{f}),nanmean(currfluor,1)');
           
           mouseall.(fnames{f}) = cat(1,mouseall.(fnames{f}),mouseid.(fnames{f}));
           
           roiidall.(fnames{f}) = cat(1,roiidall.(fnames{f}),roiid.(fnames{f}));
           
           eventidall.(fnames{f}) = cat(1,eventidall.(fnames{f}),eventid.(fnames{f}));
           
           binidall.(fnames{f}) = cat(1,binidall.(fnames{f}),nominal(ones(size(currfluor,2),1)*b));
        end
    end
    
    CellType = cat(1,repmat(nominal('msn'),length(mouseall.msn),1),...
        repmat(nominal('chi'),length(mouseall.chi),1),...
        repmat(nominal('fsi'),length(mouseall.fsi),1));
    MouseID = cat(1,mouseall.msn,mouseall.chi,mouseall.fsi);
    
    roiidall.chi = roiidall.chi + max(roiidall.msn);
    roiidall.fsi = roiidall.fsi + max(roiidall.chi);
    
    ROIID = nominal(cat(1,roiidall.msn,roiidall.chi,roiidall.fsi));
    assert(length(unique(ROIID)) == 7885);
    EventID = nominal(cat(1,eventidall.msn,eventidall.chi,eventidall.fsi));
    Fluor = cat(1,binfluor.msn,binfluor.chi,binfluor.fsi);
    
    TimeBin = cat(1,binidall.msn,binidall.chi,binidall.fsi);
    
    tbl = table(MouseID, ROIID, Fluor,TimeBin,CellType,EventID);
end