function print_laser_vs_pv_correlation(fi,st)
fprintf(fi,'------------------------------------------------------------\n');
fprintf(fi,'MSNs correlated with laser activity (no Bonferroni correction)\n');
fprintf(fi,'number significantly correlated: %d/%d=%f\n',st.nsig,st.n_total,st.nsig/st.n_total);
fprintf(fi,'z statistic (for H0: proportion = 1)=%f, p=%f\n',st.z_1, st.p_1);
fprintf(fi,'z statistic (for H0: proportion = 0)=%f, p=%f\n',st.z_0, st.p_0);
fprintf(fi,'------------------------------------------------------------\n');

end