function lik = dp_predict(qq0,testdatass,postsample,dptype,...
                           numburnin,numsample);

numtestdata   = length(testdatass);
numpostsample = length(postsample);
lik           = zeros(numtestdata,numpostsample,numsample);

totiter   = numtestdata*numpostsample*(numburnin+numsample);

for pj = 1:numtestdata
  for ps = 1:numpostsample
    dp = dp_init(testdatass(:,pj),1,1,qq0,length(postsample(ps).classnd),...
         postsample(ps));
    dp = dp_specialize(dp,dptype);

    fprintf(1,'group %d postsample %d burn in:                          \n',...
            pj,ps);
    dp = dp_iterate(dp,numburnin,totiter);
    totiter = totiter - numburnin;

    prevtime  = 0;
    tic
    for samp = 1:numsample
      switch dp.type
      case {'beta','std'}, dp_beta;
      case 'crf',          dp_crf;
      end

      dp2 = dp_standardize(dp); 
      ll   = 0;
      for cc = 1:dp2.numclass
        ii = find(dp2.datacc == cc);
        ss = dp2.datass(:,ii);
        qq = deldata(dp2.classqq(:,cc),ss);
        ll = ll + marglikelihood(qq,ss); 
      end
      lik(pj,ps,samp) = ll;

      if toc - prevtime > 1
        fprintf(1,'group %d postsample %d sample %d ETC %1.1f           \r',...
                pj,ps,samp,toc/samp*totiter);
        prevtime = toc;
      end
    end
    totiter = totiter - numsample;
    fprintf(1,'                                                           \r');
  end
end

