function transfer_tiff_files_to_local(metadata, copy)

fi = fopen(sprintf('pfgc-modified/matlab_code/src/laserData/make_metadata_local.m'),'w');
    fopen(fi);

for m=1:numel(metadata)
    fprintf(fi,'%%%% %s\n',metadata(m).suffix); % display suffix at top of cell
    curr_pref = sprintf('/hdd1/raw_data_laser/%s/',metadata(m).suffix); %create current location

    if ~exist(curr_pref,'dir') % make folder if it doesn't exist
        fprintf('creating dir: %s\n',curr_pref);
        mkdir(curr_pref);
    end
   
    fprintf(fi,'metadata(%d).suffix = ''%s'';\n',m,metadata(m).suffix); %print current suffix
    %% copy gcamp files
    copy_gcamp_files(m,metadata(m).rawtiffs,curr_pref, copy,fi);
    
    fprintf(fi,'metadata(%d).isCHI = %d;\n',m,metadata(m).isCHI); % cell identity
    
    %% copy movement files
    if copy
        path = fileparts(metadata(m).mvmt);
        rsync_files(path,curr_pref);
    end
    [path, file, ext] = fileparts(metadata(m).mvmt);
    [~,subpath,ext2]= fileparts(path);
    fprintf(fi,'metadata(%d).mvmt = ''%s'';\n',m,[curr_pref subpath ext2 '/' file ext]);
    
    %% copy laser files
    if copy
        path = fileparts(metadata(m).laserfi);
        rsync_files(path,curr_pref);
    end
    [path, file, ext] = fileparts(metadata(m).laserfi);
    [~,subpath,ext2] = fileparts(path);
    fprintf(fi,'metadata(%d).laserfi = ''%s '';\n',m, [curr_pref subpath ext2 '/' file ext]);
    
    %% copy tdt files
    copy_tdt_files(metadata(m).tdt, curr_pref,copy,fi,m);

    fprintf('done with mouse %s\n',metadata(m).suffix);
    fprintf(fi,'\n\n');
end
fclose(fi);
end

function copy_gcamp_files(m,gcampfiles, curr_pref, copy,fi)

   fprintf(fi,'metadata(%d).rawtiffs = { ...\n',m); % start sequence of raw tiffs
   for f=1:numel(gcampfiles) % for each tiff
        if copy
            rsync_files(gcampfiles{f},curr_pref,1); % if copy, copy file
        end
        [~, fname, ext] = fileparts(gcampfiles{f}); % get filename
        fprintf(fi,'''%s%s%s''...\n',curr_pref,fname,ext);% print current filename with its extension
   end

    fprintf(fi,' };\n');% close tiff


end


function copy_tdt_files(tdtfiles, curr_pref,copy,fi,m)

    %% copy over tdt files
    
    if iscell(tdtfiles)
       fprintf(fi,'metadata(%d).tdt = {...\n',m);
       for f=1:numel(tdtfiles)
           if copy
               rsync_files(tdtfiles{f},curr_pref);
           end
           [~,file,ext] = fileparts(tdtfiles{f});
          fprintf(fi,'''%s%s%s''...\n',curr_pref,file,ext);
       end
       fprintf(fi,'};\n');
    else
        if copy
           rsync_files(tdtfiles,curr_pref);
        end
        [~, file, ext] = fileparts(tdtfiles);
        fprintf(fi,'metadata(%d).tdt = ''%s'';\n',m,[curr_pref, file, ext]); % write updated path of metadata
    end

end