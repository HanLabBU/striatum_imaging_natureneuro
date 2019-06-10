function [st, pr] = roi_triggered_zerocrossings3(mouseno,celltype)
suffix = mouseSuffix(mouseno);

pr.active = [];
pr.inactive = [];
for m=1:numel(suffix)
   mousedata = loadMouse(suffix(m));
   traces = allActive(mousedata);
   if isempty(traces.(celltype))
       continue
   end
% now construct output matrix
   zc = find_zerocrossings_threshold(mousedata.rot);
   
   for t=1:size(traces.(celltype),2)
       active = ~~traces.(celltype)(:,t);
       notactive = ~active;
       
       validinds = ~isnan(zc);
       
       pr.active = cat(1,pr.active, nansum(active(validinds) & zc(validinds))/sum(active(validinds)));

       pr.inactive = cat(1,pr.inactive, nansum(notactive(validinds) & zc(validinds))/sum(notactive(validinds)));
    end
end
[st.signtest.p,st.signtest.st] = signtest_explicit(pr.active,pr.inactive);

end