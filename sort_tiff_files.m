function fi = sort_tiff_files(fi)
n = nan(numel(fi),1);
for f=1:numel(fi)
    fi{f} = strrep(fi{f},char(1),'');
  [~,nm] = fileparts(fi{f});
 [~,tok] = regexp(nm,'^.*\(([0-9]+)\).*$','match','tokens');
 n(f) = str2double(tok{1});
end
[~,i] = sort((n));
fi = fi(i);

end