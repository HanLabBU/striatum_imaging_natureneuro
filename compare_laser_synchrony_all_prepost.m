function [laser_act] = compare_laser_synchrony_all_prepost(metadata,roitype)
laser_act = struct('post',[],'pre',[]);
j = 1;
for m=1:numel(metadata)
    if nargin < 2 || (strcmp(roitype,'chi') && metadata(m).isCHI) || (strcmp(roitype,'fsi') && ~metadata(m).isCHI)
        mousedata = loadMouseLaser(metadata(m));
        act = allRisingLaser(mousedata);
        laser_act(j) = compare_laser_synchrony_pre_post(act.msn, mousedata.laserIndices);
        j = j+1;
    end
end
end