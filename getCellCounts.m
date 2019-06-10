function cc = getCellCounts(mouseno)
suffix = mouseSuffix(mouseno);
cc = struct('all',[],'msn',[],'chi',[],'fsi',[],'isCHI',[]);

for m=1:numel(suffix)
   mousedata = loadMouse(suffix(m));
   tr = allFluor(mousedata);
   cc(m).msn = size(tr.msn,2);
   cc(m).chi = size(tr.chi,2);
   cc(m).fsi = size(tr.fsi,2);
   cc(m).isCHI = mousedata.isCHI;
   cc(m).all = cc(m).msn + cc(m).chi + cc(m).fsi;
   
end


end