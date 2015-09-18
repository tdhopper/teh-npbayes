% LDA with beta auxiliary variable method.

ldabeta = lda;

numgroup = lda.numgroup;
numclass = lda.numclass;
classqq  = lda.classqq;
classnd  = lda.classnd;
beta     = lda.beta;
alpha    = lda.alpha;

for jj = randperm(numgroup)
  numdata  = lda.numdata(jj);
  datass   = lda.datass{jj};
  datacc   = lda.datacc{jj};

  % sample class associate with each data item
  for ii = randperm(numdata)
    ss                    = datass(:,ii);
    oldcc                 = datacc(ii);

    % first remove data item from model
    classqq(:,oldcc)  = deldata(classqq(:,oldcc), ss);
    classnd(jj,oldcc) = classnd(jj,oldcc) - 1;

    % computes conditional likelihood factors for each class
    clik = marglikelihood(classqq, ss);
    clik = exp(clik-max(clik)).*(classnd(jj,:) + beta*alpha);
    clik = clik/sum(clik);

    % samples for a new class
    newcc = randmult(clik);

    % adds data item back to model
    datacc(ii)         = newcc;
    classqq(:,newcc)   = adddata(classqq(:,newcc), ss);
    classnd(jj,newcc)  = classnd(jj,newcc) + 1;
  end

  lda.datacc{jj}  = datacc;
end
  
lda.classqq = classqq;
lda.classnd = classnd;
lda.type    = 'beta';
