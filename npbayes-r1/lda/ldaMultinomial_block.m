% LDA by gibbs sampling, especially for multinomial components.

beta     = lda.beta;
alpha    = lda.alpha;
eta      = lda.eta;

numgroup = lda.numgroup;
numclass = lda.numclass;
numdim   = size(eta,1);

% sample pi, theta
pi       = randdir(lda.classnd + alpha*beta(ones(1,numgroup),:), 2);
theta    = randdir(lda.classss + eta(:,ones(1,numclass)), 1);

classss  = zeros(numdim, numclass);
classnd  = zeros(numgroup, numclass);
for jj = randperm(numgroup)
  numdata        = lda.numdata(jj);
  onedata        = ones(1,numdata);
  datass         = lda.datass{jj};
 
  % sample class associate with each data item
  datacc         = randmult(theta(datass,:) .* pi(jj*onedata,:), 2)';

  % update data structures
  lda.datacc{jj} = datacc;
  datasc         = sparse(datass, datacc, onedata, numdim, numclass);
  [i,j,sc]       = find(datasc(:));
  classss(i)     = classss(i) + sc;
  classnd(jj,:)  = sum(datasc,1);
end

lda.classss = classss;
lda.classnd = classnd;
lda.type    = 'block';
