function [tbl] = plot_roi_trig_spd_mouse_novel(chi, fsi)

[b, labels] = consolidate_roi_triggered_movement(chi,fsi);
fnames = fieldnames(b);
% now, concatenate everything
% construct table for chis
Velocities.chi = cat(1,b.chi{:});
cellids.chi = (1:size(Velocities.chi,2))';
Velocities.fsi = cat(1,b.fsi{:});
cellids.fsi = (1:size(Velocities.fsi,2))'+size(Velocities.chi,2);
Velocities.msn = cat(1,b.msn{:});
cellids.msn = (1:size(Velocities.msn,2))'+size(Velocities.fsi,2)+size(Velocities.chi,2);

% number of times output will be repeated
nreps = size(Velocities.chi,1);

for f=1:numel(fnames)
    % repeat n of velocities 5 times
    Y.(fnames{f}) = Velocities.(fnames{f})';
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


CellIds = nominal(cat(1,cellnos.chi, cellnos.msn,cellnos.fsi));
Y_all = cat(1,Y.chi,Y.msn,Y.fsi);
T_all = nominal(cat(1,T.chi,T.msn,T.fsi));
Animal_all = nominal(cat(1,Animal.chi, Animal.msn, Animal.fsi));
CellTypeAll = nominal(cat(1,CellType.chi, CellType.msn, CellType.fsi));

tbl = table(Y_all, Animal_all, T_all,CellTypeAll,CellIds);

end