function laser_act = compare_laser_synchrony_all5(metadata,ninds,roitype)
laser_act = struct('active',[],'inactive',[]);
j = 1;
for m=1:numel(metadata)
    if nargin < 3 || (strcmp(roitype,'chi') && metadata(m).isCHI) || (strcmp(roitype,'fsi') && ~metadata(m).isCHI)
        mousedata = loadMouseLaser(metadata(m));
        act = allRisingLaser(mousedata);
        laser_act(j) = compare_laser_synchrony5(act.msn, mousedata.laserIndices,ninds);
        j = j+1;
    end
end
end