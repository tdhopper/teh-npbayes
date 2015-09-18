% Dirichlet process mixture modellng with auxiliary variables.

numdata  = dp.numdata;
numclass = dp.numclass;
datass   = dp.datass;
datacc   = dp.datacc;
classqq  = dp.classqq;
classnd  = dp.classnd;
beta     = dp.beta;
alpha    = dp.alpha;
qq0      = dp.qq0;

classqq(:,numclass+1) = qq0;
classnd(:,numclass+1) = 0;
for ii = randperm(numdata)
  % sample class associate with each data item

  ss                    = datass(:,ii);
  oldcc                 = datacc(ii);

  % first remove data item from model
  classnd(oldcc)        = classnd(oldcc) - 1;
  classqq(:,oldcc)      = deldata(classqq(:,oldcc),ss);

  % computes conditional likelihood factors for each class
  clik                  = marglikelihood(classqq,ss);
  clik                  = exp(clik-max(clik)).*beta;
  clik                  = clik/sum(clik);

  % samples for a new class
  newcc                 = randmult(clik);

  % adds data item back to model
  datacc(ii)            = newcc;
  classnd(newcc)        = classnd(newcc) + 1;
  classqq(:,newcc)      = adddata(classqq(:,newcc),ss);
  if newcc > numclass
    % add new class.
    numclass            = newcc;
    classnd(newcc+1)    = 0;
    classqq(:,newcc+1)  = qq0;
    bb                  = randdir([1 alpha]); 
    beta(newcc:newcc+1) = beta(newcc)*bb;
  end
end
classqq(:,numclass+1) = [];
classnd(:,numclass+1) = [];


% remove empty classes
for cc = numclass:-1:1
  if classnd(cc) == 0
    numclass      = numclass - 1;
    classnd(cc)   = [];
    classqq(:,cc) = [];
    beta(cc)      = [];
    ii            = find(datacc>cc);
    datacc(ii)    = datacc(ii) - 1;
  end
end
 
% update beta weights
weights             = classnd;
weights(numclass+1) = alpha;
beta                = randdir(weights);

dp.numclass = numclass;
dp.datacc   = datacc;
dp.classqq  = classqq;
dp.classnd  = classnd;
dp.beta     = beta;

