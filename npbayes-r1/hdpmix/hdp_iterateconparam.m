function hdp = hdp_iterateconparam(hdp,numiter,totiter);
% runs hdp for a number of iterations.

if ~exist('totiter')
  totiter = numiter;
end
prevtime  = 0;
tic

switch hdp.type
case {'beta','std'}
  for iter = 1:numiter
    hdp_beta; hdp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'crf'
  for iter = 1:numiter
    hdp_crf; hdp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'block'
  for iter = 1:numiter
    hdpMultinomial_block; hdp_conparam;
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
otherwise
  error('Unknown HDP type');
end

