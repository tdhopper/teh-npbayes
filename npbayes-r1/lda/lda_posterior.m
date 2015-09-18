function [postsample,lda]=lda_posterior(lda,numburnin,numsample,numspace);

% runs lda, gets samples for classqq, alpha.  These are enough to form
% predictive likelihoods for unseen data.

totiter = numburnin + numsample*numspace;
postsample = repmat(struct('classqq',[],'alpha',[]),1,numsample);

fprintf(1,'Burn in:                                                       \n');
lda = lda_iterateconparam(lda,numburnin,totiter);
totiter = totiter - numburnin;

for samp = 1:numsample
  fprintf(1,'Posterior sample %d:                                    \n',samp);
  lda = lda_iterateconparam(lda,numspace,totiter); 
  totiter = totiter - numspace;

  lda2 = lda_standardize(lda);
  postsample(samp).classqq  = lda2.classqq;
  postsample(samp).alpha    = lda2.alpha;
end

fprintf(1,'                                                               \r');
