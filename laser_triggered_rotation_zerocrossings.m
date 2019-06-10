function rot = laser_triggered_rotation_zerocrossings(metadata,celltype,bymouse)
rot = [];
for m=1:numel(metadata)
   if (strcmp(celltype,'chi') && metadata(m).isCHI) || ...
           (strcmp(celltype,'fsi') && ~metadata(m).isCHI)
       mousedata = loadAndFormatPreMouseDataSpeedOnly(metadata(m));
       curr_rot = compare_zerocrossings(mousedata.rotation(:),mousedata.laser); 
       if bymouse
           curr_rot = mean(squeeze(curr_rot),2);
       end
       rot = cat(2,rot,squeeze(curr_rot));
   end
end




end