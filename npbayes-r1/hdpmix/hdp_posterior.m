function [postsample,hdp]=hdp_posterior(hdp,numburnin,numsample,numspace);

% runs hdp, gets samples for classqq, totalnt.  These are enough to form
% predictive likelihoods for unseen data.

totiter = numburnin + numsample*numspace;
postsample = repmat(struct('classqq',[],'totalnt',[],'gamma',[],'alpha',[]),...
                    1,numsample);

fprintf(1,'Burn in:                                                       \n');
hdp = hdp_iterateconparam(hdp,numburnin,totiter);
totiter = totiter - numburnin;

for samp = 1:numsample
  fprintf(1,'Posterior sample %d:                                    \n',samp);
  hdp = hdp_iterateconparam(hdp,numspace,totiter); 
  totiter = totiter - numspace;

  hdp2 = hdp_standardize(hdp);
  postsample(samp).classqq  = hdp2.classqq;
  postsample(samp).totalnt  = hdp2.totalnt;
  postsample(samp).gamma    = hdp2.gamma;
  postsample(samp).alpha    = hdp2.alpha;
end

fprintf(1,'                                                               \r');
