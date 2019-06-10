function traces = jitter_all_traces(traces)
fields = fieldnames(traces);
assert(numel(fields) == 3);
len = size(traces.(fields{1}),1);
for f=1:numel(fields)
   for t=1:size(traces.(fields{f}),2)
      traces.(fields{f})(:,t) = circshift(traces.(fields{f})(:,t),randi(len,1));
   end
end


end