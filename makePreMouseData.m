function preMouseData = makePreMouseData(suffix)
preMouseData = loadAndFormatPreInfusion2(suffix);

save(['processedData/mouseData/preMouseData_' suffix '.mat'], 'preMouseData');
end