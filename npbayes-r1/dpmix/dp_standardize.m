function dp = dp_standardize(dp);

switch dp.type
case {'beta', 'std'}
case {'crp', 'kmeans'}
  dp.beta = randdir([dp.classnd dp.alpha]);
otherwise
  error('Unknown DP type');
end
dp.type = 'std';

