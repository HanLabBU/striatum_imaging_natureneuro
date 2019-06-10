function [stats, neurons] = neuron_rotclassification3(mouseno,plt)

%maybe redo this block??
% [~, sigIndsRotDY] = triggeredActivityAll(@dyRotTrigFluor,mouseno,50,0);%remove this last guy?
suffix = mouseSuffix(mouseno);
innerstruct = struct('in',[],'out',[]);
clusterdata.spd = innerstruct;
clusterdata.rot = innerstruct;
clusterdata.mix = innerstruct;

innerstruct2 = struct('msn',[],'chi',[],'fsi',[]);
speed_neurons = innerstruct2;
rot_neurons = innerstruct2;
mix_neurons = innerstruct2;

for m=1:numel(suffix)
    mousedata = loadMouse(suffix(m));
    [~, sigIndsDYOnly] = dyTriggeredFluorescence(suffix{m},50,0);
    [~, sigIndsRotOnly] = rotOnlyTriggeredFluorescence(suffix{m},50,0);% get significant neurons from each
    
    spd = identify_speed_neurons(sigIndsDYOnly, sigIndsRotOnly);
    rot = identify_rot_neurons(sigIndsDYOnly, sigIndsRotOnly);
    mix = identify_mix_neurons(sigIndsDYOnly, sigIndsRotOnly); % get significant indices for each roi type
    
    clustertype.spd = spd.msn;
    clustertype.rot = rot.msn;
    clustertype.mix = mix.msn; % designate info to use for clustering
    
    speed_neurons = neurcat(speed_neurons,spd);
    rot_neurons = neurcat(rot_neurons, rot);
    mix_neurons = neurcat(mix_neurons, mix); % concatenate all of this info
    
    centroids = allCentroids(mousedata); % get all centroids for these mice
    
    clusterdata.spd = cat(1,clusterdata.spd,find_prop_close(spd.msn, centroids.msn)); % get clustering info
    clusterdata.rot = cat(1,clusterdata.rot,find_prop_close(rot.msn, centroids.msn));
    clusterdata.mix = cat(1,clusterdata.mix,find_prop_close(mix.msn, centroids.msn));
end

[stats.spd.p,stats.spd.st] = ranksum_explicit(cat(1,clusterdata.spd.in),cat(1,clusterdata.spd.out)); % test each type of neuron for clustering
[stats.rot.p, stats.rot.st] = ranksum_explicit(cat(1,clusterdata.rot.in),cat(1,clusterdata.rot.out));
[stats.mix.p, stats.mix.st] = ranksum_explicit(cat(1,clusterdata.mix.in),cat(1,clusterdata.mix.out));

neurons.speed = speed_neurons; % assign output: significant of each type for plotting
neurons.rot = rot_neurons;
neurons.mix = mix_neurons;

if nargin > 1 && plt % plot everything (speed neurons, rot_neurons and mix neurons

    figure
    ax = plot_bar_err(speed_neurons, rot_neurons, mix_neurons);
    ylim([0 .85])
    legend('Speed-related','Rotation-related','Mixed')
    ax.XTickLabel = {'MSN','FSI','CHI'};
    title('Pct. of neurons movement-related')
    savePDF(gcf,sprintf('figures/%s/speed_rotation_bar.pdf',date));
end
stats.mvmt.speed = arrange_stats(speed_neurons);
stats.mvmt.rot = arrange_stats(rot_neurons);
stats.mvmt.mix = arrange_stats(mix_neurons);

%add chi2 test: original proportion = total neurons and total speed, second
%pop is total rot related, and then prop of those that are speed related
%basically, of neurons that are speed related, are a higher proportion
%rotation related?
fields = fieldnames(speed_neurons);
for f=1:length(fields)
    [tbl, stats.test.(fields{f}).proportion] = mktbl(speed_neurons.(fields{f}), rot_neurons.(fields{f}),mix_neurons.(fields{f})); 

    [~,stats.test.(fields{f}).p,stats.test.(fields{f}).st] = fishertest(tbl);
    
    %now, we ask: pr(rotation) = pr(speed) = pr(mix)?
    stats.multinom.(fields{f}).all = chi2gof([sum(speed_neurons.(fields{f})), sum(rot_neurons.(fields{f})),sum(mix_neurons.(fields{f}))]);
    stats.multinom.(fields{f}).part = pw_binotest([sum(speed_neurons.(fields{f})), sum(rot_neurons.(fields{f})),sum(mix_neurons.(fields{f}))],{'speed','rot','mix'},1);
end
end

function [tbl, prop] = mktbl(speed, rot, mix)
tbl = zeros(2);
%speed no rotation, speed rotation
tbl(1,1) = sum(speed);
tbl(1,2) = sum(mix);

%no speed no rotation, no speed rotation
tbl(2,1) = sum(~speed & ~mix & ~rot);
tbl(2,2) = sum(rot);
prop.speed = sum(mix)/(sum(speed) + sum(mix));
prop.nospeed = sum(rot)/(sum(~speed & ~mix & ~rot) + sum(rot));
end


function stats = arrange_stats(cat1)
f = fieldnames(cat1);
for i=1:numel(f)
    currf = f{i};
    stats.(currf).n = sum(cat1.(currf));
    stats.(currf).ntot = length(cat1.(currf));
    stats.(currf).p = stats.(currf).n/stats.(currf).ntot;
end
end

function ax = plot_bar_err(cat1, cat2, cat3)
err = @(x) sqrt(mean(x)*(1-mean(x))/length(x));
%plot bar graph
X = [sum(cat1.msn)/length(cat1.msn), sum(cat2.msn)/length(cat2.msn), sum(cat3.msn)/length(cat3.msn);...
    sum(cat1.fsi)/length(cat1.fsi), sum(cat2.fsi)/length(cat2.fsi), sum(cat3.fsi)/length(cat3.fsi);...
    sum(cat1.chi)/length(cat1.chi), sum(cat2.chi)/length(cat2.chi), sum(cat3.chi)/length(cat3.chi)...    
    ];
Xerr = [err(cat1.msn), err(cat2.msn), err(cat3.msn); ...
    err(cat1.fsi), err(cat2.fsi), err(cat3.fsi); ...
    err(cat1.chi), err(cat2.chi), err(cat3.chi)];
bar_err(1:3,X,Xerr);
ax = gca;

end


function ax = plot_bar(cat1, cat2, cat3)
%plot bar graph
X = [sum(cat1.msn)/length(cat1.msn), sum(cat2.msn)/length(cat2.msn), sum(cat3.msn)/length(cat3.msn);...
    sum(cat1.fsi)/length(cat1.fsi), sum(cat2.fsi)/length(cat2.fsi), sum(cat3.fsi)/length(cat3.fsi);...
    sum(cat1.chi)/length(cat1.chi), sum(cat2.chi)/length(cat2.chi), sum(cat3.chi)/length(cat3.chi)...    
    ];
bar(X);
ax = gca;

end

function rel = identify_speed_neurons(dy, rot)
fnames = fieldnames(dy);
for f=1:length(fnames)
   rel.(fnames{f}) =  ((dy.(fnames{f}).pos | dy.(fnames{f}).neg) &...
       (~rot.(fnames{f}).pos & ~rot.(fnames{f}).neg)); % get positively or negatively modulated by movement, and not positively/not negatively modulated by rotation
end
end

function rel = identify_rot_neurons(dy, rot)
fnames = fieldnames(dy);
for f=1:length(fnames)
   rel.(fnames{f}) =  ((~dy.(fnames{f}).pos & ~dy.(fnames{f}).neg) &...
       (rot.(fnames{f}).pos | rot.(fnames{f}).neg)); % get nto positivel and not negatively modulated by movement, modulated positively or negatively by rotation
end
end

function rel = identify_mix_neurons(dy, rot)
fnames = fieldnames(dy);
for f=1:length(fnames)
   rel.(fnames{f}) =  ((dy.(fnames{f}).pos | dy.(fnames{f}).neg) &...
       (rot.(fnames{f}).pos | rot.(fnames{f}).neg)); % modulated by speed (pos or neg) and modulated by rotation (pos or neg)
end

end

