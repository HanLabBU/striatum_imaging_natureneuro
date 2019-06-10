function bino = convert_laser_2_binary(laserstart,laserend,oldtaxis,newtaxis)
bino = zeros(size(newtaxis));
for s=1:numel(laserstart)
   if laserstart(s) > length(oldtaxis)
       return
   end
   if laserend(s) > length(oldtaxis)
      fprintf('laser goes off end of trace!\n'); 
   end
   tstart = oldtaxis(laserstart(s));
   tend = oldtaxis(min(laserend(s),length(oldtaxis)));
   currinds = (newtaxis >= tstart) & (newtaxis <= tend);
   bino(currinds) = 1; 
end

end