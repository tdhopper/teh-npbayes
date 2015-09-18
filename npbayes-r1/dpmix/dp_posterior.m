function [postsample,dp]=dp_posterior(dp,numburnin,numsample,numspace);
% runs dp, gets samples for classqq, totalnt.  These are enough to form
% predictive likelihoods for unseen data.

totiter = numburnin + numsample*numspace;
postsample = repmat(struct('classqq',[],'classnd',[],'alpha',[]),1,numsample);

fprintf(1,'Burn in:                                                       \n');
dp = dp_iterateconparam(dp,numburnin,totiter);
totiter = totiter - numburnin;

for samp = 1:numsample
  fprintf(1,'Posterior sample %d:                                    \n',samp);
  dp = dp_iterateconparam(dp,numspace,totiter); 
  totiter = totiter - numspace;

  dp2 = dp_standardize(dp);
  postsample(samp).classqq  = dp2.classqq;
  postsample(samp).classnd  = dp2.classnd;
  postsample(samp).alpha    = dp2.alpha;
end

fprintf(1,'                                                               \r');
