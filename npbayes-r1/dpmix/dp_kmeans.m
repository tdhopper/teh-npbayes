% Dirichlet process mixture modellng with auxiliary variables.

numdata  = dp.numdata;
numclass = dp.numclass;
datass   = dp.datass;
datacc   = dp.datacc;
classqq  = dp.classqq;
classnd  = dp.classnd;
alpha    = dp.alpha;
qq0      = dp.qq0;

classqq(:,numclass+1) = qq0;
classnd(:,numclass+1) = 0;
for ii = randperm(numdata)
  % sample class associate with each data item

  ss                    = datass(:,ii);
  oldcc                 = datacc(ii);

  % first remove data item from model
  classqq(:,oldcc)      = deldata(classqq(:,oldcc),ss);
  classnd(oldcc)        = classnd(oldcc) - 1;

  % computes conditional likelihood factors for each class
  clik                  = marglikelihood(classqq, ss);
  weights               = classnd;
  weights(numclass+1)   = alpha;
  clik                  = exp(clik-max(clik)).*weights;
  clik                  = clik/sum(clik);

  % samples for a new class
  [tmp newcc]           = max(clik);

  % adds data item back to model
  datacc(ii)            = newcc;
  classqq(:,newcc)      = adddata(classqq(:,newcc),ss);
  classnd(newcc)        = classnd(newcc) + 1;
  if newcc > numclass
    % add new class.
    numclass            = newcc;
    classnd(newcc+1)    = 0;
    classqq(:,newcc+1)  = qq0;
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
    ii            = find(datacc>cc);
    datacc(ii)    = datacc(ii) - 1;
  end
end

   
dp.numclass = numclass;
dp.datacc   = datacc;
dp.classqq  = classqq;
dp.classnd  = classnd;

