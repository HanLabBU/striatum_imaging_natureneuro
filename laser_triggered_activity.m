function mta = laser_triggered_activity(metadata, radius,genotype)
   mta.msn = cell(0);
    mta.tdt = cell(0);
    currind = 1;
   for m=1:numel(metadata)
       if (metadata(m).isCHI && strcmp(genotype,'chi')) || ...
               (~metadata(m).isCHI && strcmp(genotype,'fsi')) || strcmp(genotype,'all')
           % get peak triggered average
           mousedata = loadMouseLaser(metadata(m));
           fluor = allRisingLaser(mousedata);
           traces.msn = fluor.msn;
           traces.tdt = cat(2,fluor.chi,fluor.fsi);
           laser_starts = diff([0;mousedata.laserIndices]) == 1;
           mta.msn{currind} = peakTriggeredAverage(traces.msn, laser_starts,radius,0);
           mta.tdt{currind} = peakTriggeredAverage(traces.tdt, laser_starts,radius,0);
           currind = currind + 1;
       end   
   end
end