function st = plot_segmentcorr_combo_shuffles3(nreps)
X_lo_out = 0;
X_hi_out = 0;
X_lo_in = 0;
X_hi_in = 0;
suffix = mouseSuffix('good');
allMouseData = loadMouse(suffix);
for n=1:nreps
    peakmvmt = loadrep(n);
    inner = struct('in',[],'out',[]);
    X = struct('hi',inner,'lo',inner);
    suffix = mouseSuffix('good');
    for m=1:numel(peakmvmt.fsi)
        mousedata = allMouseData(m);
        if mousedata.isCHI
            in = peakmvmt.chi(m).msnin;
            out = peakmvmt.chi(m).msnout;
            intin = peakmvmt.chi(m).intin;
            intout = peakmvmt.chi(m).intout;
        else
            in = peakmvmt.fsi(m).msnin;
            out = peakmvmt.fsi(m).msnout;
            intin = peakmvmt.fsi(m).intin;
            intout = peakmvmt.fsi(m).intout;
        end
        if ~isempty(in)
            X.hi.in = cat(1,X.hi.in, in(:,1));
            X.lo.in = cat(1,X.lo.in, in(:,2));
        end
        if ~isempty(out)
            X.hi.out = cat(1,X.hi.out, out(:,1));
            X.lo.out = cat(1,X.lo.out, out(:,2));
        end

        if ~isempty(intin)
            X.hi.in = cat(1,X.hi.in, intin(:,1));
            X.lo.in = cat(1,X.lo.in, intin(:,2));
        end
        if ~isempty(intout)
            X.lo.out = cat(1,X.lo.out, intout(:,2));
            X.hi.out = cat(1,X.hi.out, intout(:,1));
        end
    end

    X_lo_out = X.lo.out/nreps+X_lo_out;
    X_hi_out = X.hi.out/nreps+X_hi_out;
    X_lo_in = X.lo.in/nreps+X_lo_in;
    X_hi_in = X.hi.in/nreps+X_hi_in;
    
    fprintf('done with rep %d\n',n);
end
delete(gcp('nocreate'));

st.x_lo_out = X_lo_out;
st.x_hi_out = X_hi_out;
st.x_lo_in = X_lo_in;
st.x_hi_in = X_hi_in;


save('pearson_shuffles_procesed3.mat','st');
end

function peakmvmt1 = loadrep(n)
    load(sprintf('pearson_shuffles/pearson_shuffle_rep_chi_%d.mat',n),'peakmvmt');
    peakmvmt1.chi = peakmvmt;
    load(sprintf('pearson_shuffles/pearson_shuffle_rep_fsi_%d.mat',n),'peakmvmt');
    peakmvmt1.fsi = peakmvmt;


end