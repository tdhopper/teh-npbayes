function dp = dpGaussianWishart(datass,alphaa,alphab,inittype,...
              relprecision, degfreedom, emean, ecov);
% inittype can be either a number (number of classes), or string '1perdata',
% for 1 class per data item.

% concentration parameter
dp.alpha       = alphaa/alphab;
dp.alphaa      = alphaa;
dp.alphab      = alphab;

% data
dp.numdata     = size(datass,2);
dp.datass      = datass;
dp.datacc      = ones(1,numdata);

% hyperparameters for prior
numdim         = size(datass,1);
if nargin==4
  relprecision = 1;
  degfreedom   = numdim*2;
  emean        = mean(datass,2);
  ecov         = cov(datass');
end
dp.qq0         = Gaussian(10,numdim,repprecision,degfreedom,emean,ecov);

% components
if ischar(inittype) & strcmp(inittype,'1perdata')
  dp.numclass  = numdata;
else
  dp.numclass  = inittype;
end
dp.classnd     = zeros(1,dp.numclass+1);
dp.classqq     = dp.qq0(1,ones(1,dp.numclass+1));

% assign data to components
for ii = randperm(dp.numdata)
  cc               = rem(ii,dp.numclass)+1;
  dp.datacc(ii)    = cc;
  dp.classqq(:,cc) = adddata1(dp.classqq(:,cc),dp.classnd(cc),dp.datass(:,ii));
  dp.classnd(cc)   = dp.classnd(cc) + 1;
end
dp.beta     = randdir([dp.classnd(1:dp.numclass-1) dp.alpha]);


