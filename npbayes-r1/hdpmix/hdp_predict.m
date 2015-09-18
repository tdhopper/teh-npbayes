function lik = hdp_predict(qq0,testdatass,postsample,hdptype,range,...
                           numburnin,numsample);

numgroup      = length(testdatass);
numpostsample = length(postsample);
lik           = zeros(numgroup,numpostsample,numsample);

totiter   = numgroup*numpostsample*(numburnin+numsample);

for pj = 1:numgroup
  for ps = 1:numpostsample
    hdp = hdp_init(testdatass(pj),1,1,1,1,qq0,1,postsample(ps));
    hdp = hdp_specialize(hdp,hdptype,range);

    fprintf(1,'group %d postsample %d burn in:                          \n',...
            pj,ps);
    hdp = hdp_iterate(hdp,numburnin,totiter);
    totiter = totiter - numburnin;

    prevtime  = 0;
    tic
    for samp = 1:numsample
      switch hdp.type
      case {'beta','std'}, hdp_beta;
      case 'crf',          hdp_crf;
      case 'block',        hdpMultinomial_block;
      end

      hdp2 = hdp_standardize(hdp); 
      ll   = 0;
      for cc = 1:hdp2.numclass
        ii = find(hdp2.datacc{1}==cc);
        ss = hdp2.datass{1}(:,ii);
        qq = deldata(hdp2.classqq(:,cc),ss);
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

