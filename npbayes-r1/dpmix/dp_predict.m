function lik = dp_predict(qq0,alldatass,postsample);

numpostsample = length(postsample);
allnumdata    = size(alldatass,2);
lik           = zeros(allnumdata,numpostsample);

for ps = 1:numpostsample
  classqq          = postsample(ps).classqq;
  classqq(:,end+1) = qq0;
  pi               = [postsample(ps).classnd postsample(ps).alpha];
  pi               = pi'/sum(pi);

  for ii = 1:allnumdata
    ll         = marglikelihood(classqq, alldatass(:,ii));
    mm         = max(ll);
    ll         = exp(ll - mm);
    lik(ii,ps) = log(ll*pi) + mm;
  end
end

