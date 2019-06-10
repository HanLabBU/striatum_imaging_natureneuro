function [tbl] = gather_roi_trig_spd_mouse_siginds_single(roi)

% consolidate labels and bin the speed values
[b, labels] = consolidate_roi_triggered_movement_single(roi);
fnames = fieldnames(b);

% assign unique cell ids to every cell. Velocities should by in timebin x
% cell. Also establish velocities matrix
Velocities.pos = cat(1,b.pos{:});
Velocities.neg = cat(1,b.neg{:});
cellids.pos = (1:size(Velocities.pos,2))';
cellids.neg = (1:size(Velocities.neg,2))'+max(cellids.pos);


% number of times output will be repeated
nreps = size(Velocities.pos,1);

for f=1:numel(fnames)
    % repeat n of velocities 5 times
    Y.(fnames{f}) = Velocities.(fnames{f})'; % flip velocities, so cell x timebin
    Y.(fnames{f}) = Y.(fnames{f})(:);
    % replicate animal ids 4 times, once for each velocity value
    Animal.(fnames{f}) = repmat(labels.(fnames{f}),nreps,1);
    % get corresponding time ids
    t = repmat((1:nreps)',1,size(Velocities.(fnames{f}),2));
    t = t';
    T.(fnames{f}) = t(:);
    CellType.(fnames{f}) = repmat(fnames(f),length(Y.(fnames{f})),1);
    cellnos.(fnames{f}) = repmat(cellids.(fnames{f}),nreps,1);
end

% now concatenate across all cell types to create a table for MEM
CellIds = nominal(cat(1,cellnos.pos,cellnos.neg));
Y_all = cat(1,Y.pos,Y.neg);
assert(~isequaln(CellIds,Y_all));
T_all = nominal(cat(1,T.pos,T.neg));
Animal_all = nominal(cat(1,Animal.pos,Animal.neg));
CellTypeAll = nominal(cat(1,CellType.pos, CellType.neg));

% return this table
tbl = table(Y_all, Animal_all, T_all,CellTypeAll,CellIds);

end