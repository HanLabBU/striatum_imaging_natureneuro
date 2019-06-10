e% runmainallmice_laser

% first, hand select the appropriate files
metadata = create_metadata_struct;
metadata(2) = create_metadata_struct;

% now, write the appropriate files to a metadata text file
write_metadata(metadata,'pfgc-modified/matlab_code/src/laserData/metadata_laser_linux.m');

metadata_laser_linux

transfer_tiff_files_to_local(metadata,0); % check to see if copying works okay

%% process the videos using processOnlyManual
%
cd /hdd2/construct_laser
make_metadata_local
%%
for f=1:numel(metadata)
    dr = fileparts(metadata(f).rawtiffs{1});
    cd(dr)
    fi = metadata(f).rawtiffs;
    fi = sort_tiff_files(fi);
    for i=1:numel(fi)
       fi{i} = strrep(fi{i},char(1),''); 
       fprintf('processing %s\n',fi{i});
    end
    processOnlyManual(fi);
end

%% TEST 
clear
metadata_final_gcamp_final
parpool('local',4);
parfor f=1:numel(metadata)
    dr = fileparts(metadata(f).rawtiffs{1});
    cd(dr)
    fi = metadata(f).rawtiffs;
    fi = sort_tiff_files(fi);
    for i=1:numel(fi)
       fi{i} = strrep(fi{i},char(1),''); 
    end
    processOnlyManualTest(fi);
end
delete(gcp('nocreate'));
fprintf('passed all tests!\n');


%%

clearvars -except metadata
%% now, get maxes
for m=1:numel(metadata)
    laser_maxes_all(metadata(m));
end

%% now process TDT videos
for m=1:numel(metadata)
    fi = metadata(m).tdt;
    if iscell(fi)
        for i=1:numel(fi)
           fi{i} = strrep(fi{i},char(1),''); 
        end
    else
        fi = strrep(fi,char(1),'');
    end
    data = processTDTLaser(metadata(m).suffix, fi);
end

%% now align TDT images
make_metadata_local

m = 1;   
    R = select_single_frame_rois_laser(metadata(m));
    find_tdt_shift_laser_rois(metadata(m));

m = 2;    
    R = select_single_frame_rois_laser(metadata(m));
    find_tdt_shift_laser_dummy(metadata(2));

%% label TDT neurons
m = 1;
    identify_tdt_laser(metadata(m));

m = 2;
    identify_tdt_laser_add_rois_from_tdt_map(metadata);


%% now extract traces
for m=1:numel(metadata)
    R = processROIsLaser(metadata(m));
    save(sprintf('processedData/rois-laser/rois_w_traces_%s.mat',metadata(m).suffix),'R');
end


%% now save movement and laser data
for m=1:numel(metadata)
    % load laser data
   load(strrep(strip(metadata(m).laserfi),char(1),''));
   save(sprintf('processedData/movementDataLaser/laser_data_%s.mat',metadata(m).suffix),'laser');
   d = fileparts(metadata(m).mvmt);
   currdir = pwd;
   cd(d)
   load(strrep(strip(metadata(m).mvmt),char(1),''));
   [data,info] = getData(vrffiles);
   cd(currdir)
   save(sprintf('processedData/movementDataLaser/movement_data_%s.mat',metadata(m).suffix),'data','info');
end
% or, you could run::
% extract_movement_laser_data(metadata)

%% now get tiff time stamps. run things for reals
for m=1:numel(metadata)
    t = get_time_stamps(metadata(m));
    save(sprintf('processedData/timestampslaser/timestamps_seconds_%s.mat',metadata(m).suffix),'t');
end



%% make mouse data
clear
metadata_final_gcamp_final
for m=1:numel(metadata)
    if ~isempty(metadata(m).rawtiffs)
        preMouseData = loadAndFormatPreInfusion3(metadata(m));
        save(sprintf('processedData/mouseDataLaser/preMouseData_%s.mat',metadata(m).suffix),'preMouseData');
        activation_state = getActivationStatePreInf(metadata(m).suffix, 3);
        save(['processedData/activityTracesLaser/activation_state_dynamic_' metadata(m).suffix '.mat'],'activation_state');
        activation_state = getActivationStateBroad(metadata(m).suffix, 2);
        save(['processedData/activityTracesLaser/activation_state_broad_' metadata(m).suffix '.mat'],'activation_state')
        activation_state = getActivationStatePreInfLaser(metadata(m).suffix, 2);
        save(['processedData/activityTracesLaser/activation_state_laser_' metadata(m).suffix '.mat'],'activation_state');
    end
end
%%
sortTracesLaser(metadata); % or sortTracesLaser(metadata), used for last one. This is independent of previous stuff, besides loadAndFormatPreInfusion3
clear
