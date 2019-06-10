function st = plot_segmentcorr_combo_shuffles_bysession(nreps)
suffix = mouseSuffix('good');

X_lo_out = nan(nreps,length(suffix));
X_hi_out = nan(nreps,length(suffix));
X_lo_in = nan(nreps,length(suffix));
X_hi_in = nan(nreps,length(suffix));
X_lo = nan(nreps,length(suffix));
X_hi = nan(nreps,length(suffix));

allMouseData = loadMouse(suffix);
parpool('local',20);
parfor n=1:nreps
    peakmvmt = loadrep(n);
    inner = struct('in',nan(length(suffix),1),'out',nan(length(suffix),1));
    X = struct('hi',inner,'lo',inner);
    X2 = struct('hi',nan(length(suffix),1),'lo',nan(length(suffix),1));
    for m=1:numel(suffix)
        mousedata = allMouseData(m);
        if mousedata.isCHI
            in = peakmvmt.chi(m).msnin;
            out = peakmvmt.chi(m).msnout;
        else
            in = peakmvmt.fsi(m).msnin;
            out = peakmvmt.fsi(m).msnout;
        end
        assert(~isempty(in) && ~isempty(out));
        X.hi.in(m) = mean(in(:,1));
        X.lo.in(m)= mean(in(:,2));
        X.hi.out(m) = mean(out(:,1));
        X.lo.out(m) = mean(out(:,2));
        X2.hi(m) = mean(cat(1,in(:,1),out(:,1)));
        X2.lo(m) = mean(cat(1,in(:,2),out(:,2)));
    end

    X_lo_out(n,:) = X.lo.out;
    X_hi_out(n,:) = X.hi.out;
    X_lo_in(n,:) = X.lo.in;
    X_hi_in(n,:) = X.hi.in;
    X_lo(n,:) = X2.lo;
    X_hi(n,:) = X2.hi;
    fprintf('done with rep %d\n',n);
end
delete(gcp('nocreate'));

st.x_lo_out = mean(X_lo_out,1)';
st.x_hi_out = mean(X_hi_out,1)';
st.x_lo_in = mean(X_lo_in,1)';
st.x_hi_in = mean(X_hi_in,1)';
st.x_hi = mean(X_hi,1)';
st.x_lo = mean(X_lo,1)';

save('pearson_shuffles_processed3.mat','st');
end

function peakmvmt1 = loadrep(n)
    load(sprintf('pearson_shuffles/pearson_shuffle_rep_chi_%d.mat',n),'peakmvmt');
    peakmvmt1.chi = peakmvmt;
    load(sprintf('pearson_shuffles/pearson_shuffle_rep_fsi_%d.mat',n),'peakmvmt');
    peakmvmt1.fsi = peakmvmt;


end