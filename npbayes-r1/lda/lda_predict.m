function lik = lda_predict(qq0,testdatass,postsample,ldatype,...
                           numburnin,numsample);

numgroup      = length(testdatass);
numpostsample = length(postsample);
lik           = zeros(numgroup,numpostsample,numsample);

totiter   = numgroup*numpostsample*(numburnin+numsample);

for pj = 1:numgroup
  for ps = 1:numpostsample
    lda = lda_init(testdatass(pj),1,1,qq0,length(postsample(ps).classqq),...
          postsample(ps));
    lda = lda_specialize(lda,ldatype);

    fprintf(1,'group %d postsample %d burn in:                          \n',...
            pj,ps);
    lda = lda_iterate(lda,numburnin,totiter);
    totiter = totiter - numburnin;

    prevtime  = 0;
    tic
    for samp = 1:numsample
      switch lda.type
      case {'beta','std'}, lda_beta;
      case 'crf',          lda_crf;
      case 'block',        ldaMultinomial_block;
      end

      lda2 = lda_standardize(lda); 
      ll   = 0;
      for cc = 1:lda2.numclass
        ii = find(lda2.datacc{1}==cc);
        ss = lda2.datass{1}(:,ii);
        qq = deldata(lda2.classqq(:,cc),ss);
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

