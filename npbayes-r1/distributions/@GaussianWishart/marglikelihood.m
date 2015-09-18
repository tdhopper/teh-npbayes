function lik = marglikelihood(qq,ss);
% calculate log likelihood of data vectors ss given parameter
% distribution qq.  Takes on multiple qq's.  
% Basically calculate difference in log likelihood before and after 
% adding ss into qq.

lik = - cat(2,qq.lik);

for ii = 1:length(qq)
  qq(ii) = adddata(qq(ii),ss);
end

lik = lik + cat(2,qq.lik);
