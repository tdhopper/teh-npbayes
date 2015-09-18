% hierarchical DP sampling by gibbs sampling using beta and auxillary
% variables.

numgroup = hdp.numgroup;
numclass = hdp.numclass;
gamma    = hdp.gamma;
alpha    = hdp.alpha;
beta     = hdp.beta;
qq0      = hdp.qq0;

classqq  = hdp.classqq;
classnd  = hdp.classnd;
classnt  = hdp.classnt;
totalnt  = hdp.totalnt;

% adds an additional unrepresented class for simplicity.
classqq(:,numclass+1) = qq0;
classnd(:,numclass+1) = 0;
for jj = randperm(numgroup)
  numdata  = hdp.numdata(jj);
  datass   = hdp.datass{jj};
  datacc   = hdp.datacc{jj};

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
    if newcc > numclass
      % add new class.
      numclass           = numclass + 1;
      classqq(:,newcc+1) = qq0;
      classnd(:,newcc+1) = 0;
      bb                 = randdir([1 gamma]); 
      beta(end:end+1)    = beta(end)*bb;
    end
  end

  hdp.datacc{jj}  = datacc;
end
classqq(:,numclass+1) = [];
classnd(:,numclass+1) = [];

% sample number of tables
totalnt  = cat(2,totalnt-sum(classnt,1), zeros(1,numclass-length(totalnt)));
classnt  = randnumtable(alpha*beta(ones(1,numgroup),:),classnd);
totalnt  = totalnt + sum(classnt,1);

% remove empty classes
for cc = numclass:-1:1
  if totalnt(cc) == 0
    numclass             = numclass - 1;
    classqq(:,cc)        = [];
    classnd(:,cc)        = [];
    classnt(:,cc)        = [];
    totalnt(cc)          = [];
    beta(cc)             = [];
    for jj = 1:numgroup
      ii                 = find(hdp.datacc{jj} > cc);
      hdp.datacc{jj}(ii) = hdp.datacc{jj}(ii) - 1;
    end
  end
end

% update beta weights
weights             = totalnt;
weights(numclass+1) = gamma;
beta                = randdir(weights);

hdp.numclass = numclass;
hdp.classqq  = classqq;
hdp.classnd  = classnd;
hdp.classnt  = classnt;
hdp.totalnt  = totalnt;
hdp.beta     = beta;
