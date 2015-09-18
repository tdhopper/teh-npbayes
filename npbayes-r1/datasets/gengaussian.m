function datass=gengaussian(numdim,numgroup,nummu,numdata,alpha,musigma,sigma);

beta = ones(1,nummu)/nummu;
pi = randdir(alpha*beta(ones(1,numgroup),:),2);

means = randn(numdim,nummu)*musigma;

datass = cell(numgroup,1);
for jj = 1:numgroup
  cc = randmult(pi(jj*ones(1,numdata),:),2);
  datass{jj} = randn(numdim,numdata)*sigma + means(:,cc);
end

