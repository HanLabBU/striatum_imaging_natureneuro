% write metadata to file

function write_metadata(metadata,fname)
fi = fopen(fname,'w');
for m=1:numel(metadata)
   fprintf(fi,'%%%% %s\n',metadata(m).suffix);
   if m == 1
      fprintf(fi,'metadata(1).suffix = ''%s'';\n',metadata(m).suffix);
   else
       fprintf(fi,'metadata(end+1).suffix = ''%s'';\n',metadata(m).suffix);
   end
   fprintf(fi,'metadata(end).rawtiffs = {...\n');
   for f=1:numel(metadata(m).rawtiffs)
       fprintf(fi,'''%s''...\n',metadata(m).rawtiffs{f});
   end
   fprintf(fi,'};\n');
   fprintf(fi,'metadata(end).mvmt = ''%s'';\n',metadata(m).movementfile);
   if iscell(metadata(m).tdtfile)
       fprintf(fi,'metadata(end).tdt = {...\n');
       for f=1:numel(metadata(m).tdtfile)
          fprintf(fi,'''%s''...\n',metadata(m).tdtfile{f}); 
       end
       fprintf(fi,'};\n');
   else
       fprintf(fi,'metadata(end).tdt = ''%s'';\n',metadata(m).tdtfile);
   end
   fprintf(fi,'metadata(end).isCHI = %d;\n',metadata(m).isCHI);
   fprintf(fi,'metadata(end).laserfi = ''%s'';\n',metadata(m).laserfi);   
   fprintf(fi,'\n\n');
end
fclose(fi);

end