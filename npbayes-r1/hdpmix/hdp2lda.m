function hdp = hdp2lda(hdp);

hdp = hdp_standardize(hdp);
hdp = rmfield(hdp,{'gammaa','gammab','gamma','totalnt','classnt'});

hdp.beta = ones(hdp.numclass)/hdp.numclass;

hdp.type = 'std';
