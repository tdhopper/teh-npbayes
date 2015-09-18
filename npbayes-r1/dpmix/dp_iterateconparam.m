function dp = dp_iterateconparam(dp,numiter,totiter);
% runs dp for a number of iterations.

if ~exist('totiter')
  totiter = numiter;
end
prevtime  = 0;
tic

switch dp.type
case {'beta','std'}
  for iter = 1:numiter
    dp_beta; dp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'crf'
  for iter = 1:numiter
    dp_crf; dp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'kmeans'
  for iter = 1:numiter
    dp_kmeans; dp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
otherwise
  error('Unknown DP type');
end

