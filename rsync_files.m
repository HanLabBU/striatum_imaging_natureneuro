

function rsync_files(currfilename,destination, nameonly)
            original_name = currfilename; % get name with spaces and parentheses
            currfilename = format_for_bash(currfilename); % prefix spaces and parentheses with \
          
            [~, fname, ext] = fileparts(original_name);
             if ~isempty(ext) && strcmp(ext(end),'')
                ext = ext(1:(end-1));
            end
          
          if exist([destination fname ext]) % check if desired filename exists at destination
              if nargin > 2 && nameonly % if it does and this is what we care about, return
                  return
              end
             [status,output] = system(sprintf('diff -qr %s %s',[destination format_for_bash(fname) ext], currfilename)); % if they have the same name, look for differences between files
             if status == 1
                 warning(output)
             end
             if isempty(output) % if no differences between files at source and destination, return without rsyncing
                 return
             else % else
                 [status, output] = system(sprintf('rsync -avr %s %s',currfilename,destination)); % rsync the file to the destination folder
                 if status == 1
                     error(output)
                 end
                 fprintf('Tried copying %s to %s\n', original_name, destination);
                 fprintf(output); 
             end
          else % if name of file doesn't exist at destination...
             [status, output] = system(sprintf('rsync -avr %s %s',currfilename,destination));
             if status == 1
                error(output)
             end
             fprintf('Copying %s to %s\n', original_name, destination);
             fprintf(output);
          end
end

function currfilename = format_for_bash(currfilename)
    if strcmp(currfilename(end),'')
        currfilename = currfilename(1:end-1);
    end
    currfilename = strrep(currfilename,' ','\ ');
    currfilename = strrep(currfilename,'(','\(');
    currfilename = strrep(currfilename,')','\)');
end