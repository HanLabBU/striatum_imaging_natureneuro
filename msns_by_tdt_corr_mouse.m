function tdtmsns = msns_by_tdt_corr_mouse(corrdata,inttype)
if strcmp(inttype,'chi')
   msnfield = 'mc';
elseif strcmp(inttype,'fsi')
    msnfield = 'mf';
else
    error('not a valid interneuron type');
end

mice = unique(corrdata.(msnfield).mouse);

tdtmsns.sig = cell(0);
tdtmsns.notsig = cell(0);
for m=1:numel(mice)
    currinds = corrdata.(msnfield).mouse == mice(m); % get indices for current mouse
    siginds = corrdata.(msnfield).p(currinds) < 0.05; % of these indices, find the significant p values
    currids = corrdata.(msnfield).ids(currinds,:); % for the id field, get these indices
    tdtinds = unique(currids(:,2)); % find the unique tdt indices
    assert(min(tdtinds) == 1);
    assert(all(diff(sort(tdtinds)) == 1))
    for t=1:numel(tdtinds)
       currind = tdtinds(t);
       curr_subinds = currids(:,2) == tdtinds(t);
       tdtmsns(m).sig{currind} = currids(curr_subinds & siginds,1);
       tdtmsns(m).notsig{currind} = currids(curr_subinds & ~siginds,1);
    end
end


end