function dp = dp_mix(datass,alphaa,alphab,qq0,initcc,initpost);

% concentration parameter
dp.alpha       = alphaa/alphab;
dp.alphaa      = alphaa;
dp.alphab      = alphab;

% data
dp.numdata     = size(datass,2);
dp.datass      = datass;
dp.datacc      = zeros(1,dp.numdata);

% components
dp.qq0         = qq0;
if ischar(initcc) & strcmp(initcc,'1perdata')
  dp.numclass  = dp.numdata;
  dp.datacc    = 1:dp.numdata;
elseif length(initcc) == 1
  dp.numclass  = initcc;
  dp.datacc    = rem(randperm(dp.numdata),dp.numclass)+1;
else
  dp.datacc    = initcc;
  dp.numclass  = max(dp.datacc);
end

if ~exist('initpost')
  dp.classnd   = zeros(1,dp.numclass);
  dp.classqq   = dp.qq0(:,ones(1,dp.numclass));
else
  dp.alpha     = initpost.alpha;
  dp.classnd   = initpost.classnd;
  dp.classqq   = initpost.classqq;
  postnc       = length(dp.classnd);
  if dp.numclass > postnc
    dp.classnd(dp.numclass) = 0;
    dp.classqq(:,postnc+1:dp.numclass) = qq0(:,ones(1,dp.numclass-postnc));
  else
    dp.numclass = postnc;
  end
end

% assign data to components
for cc = 1:dp.numclass
  ii = find(dp.datacc == cc);
  dp.classqq(:,cc) = adddata(dp.classqq(:,cc),dp.datass(:,ii));
  dp.classnd(cc)   = dp.classnd(cc) + length(ii);
end

dp.beta = randdir([dp.classnd dp.alpha]);
dp.type = 'beta';
