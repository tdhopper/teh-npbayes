function lda = lda_iterate(lda,numiter,totiter);
% runs lda for a number of iterations.

if ~exist('totiter')
  totiter = numiter;
end
prevtime  = 0;
tic

switch lda.type
case {'beta','std'}
  for iter = 1:numiter
    lda_beta; 
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'crf'
  for iter = 1:numiter
    lda_crf; 
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
case 'block'
  for iter = 1:numiter
    ldaMultinomial_block; 
    if toc - prevtime > 1
      fprintf(1,'iter %d time %f ETC %f numclass %d               \r',...
        iter,toc,toc/iter*totiter,numclass);
      prevtime = toc;
    end
  end
otherwise
  error('Unknown LDA type');
end

