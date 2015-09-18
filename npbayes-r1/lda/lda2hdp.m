function lda = lda2hdp(lda,gammaa,gammab);

lda = lda_standardize(lda);

lda.gammaa  = gammaa;
lda.gammab  = gammab;
lda.gamma   = gammaa/gammab;

lda.classnt = randnumtable(lda.alpha*lda.beta(ones(1,lda.numgroup),:),...
              lda.classnd);
lda.totalnt = sum(lda.classnt,1);

weights                 = lda.totalnt;
weights(lda.numclass+1) = lda.gamma;
lda.beta                = randdir(weights);

lda.type = 'std';

