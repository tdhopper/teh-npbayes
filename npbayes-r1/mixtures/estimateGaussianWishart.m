function qq0 = estimateGaussianWishart(datass);

% estimate hyperparameters of Gaussian-Wishart in a dumb way.

numdim       = size(datass,1);
relprecision = 1;
degfreedom   = numdim;
emean        = mean(datass,2);
ecov         = cov(datass');

qq0          = GaussianWishart(10,numdim,relprecision,degfreedom,emean,ecov);

