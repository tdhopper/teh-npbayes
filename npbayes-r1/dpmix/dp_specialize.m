function dp = dp_specialize(dp,dptype);

switch dptype
case {'crp','kmeans'}
  dp.beta = [];
case 'beta'
  dp.beta = randdir([dp.classnd dp.alpha]);
otherwise
  error('Unknown DP type');
end
dp.type = dptype;
