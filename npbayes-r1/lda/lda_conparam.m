% Prior updates 

if strcmp(lda.type,'crf')==0
  classnt=randnumtable(lda.alpha*lda.beta(ones(1,lda.numgroup),:),lda.classnd);
  lda.alpha = randconparam(lda.alpha,lda.numdata,sum(classnt,1),...
              lda.alphaa,lda.alphab,10);
else
  lda.alpha = randconparam(lda.alpha,lda.numdata,sum(lda.classnt,1),...
              lda.alphaa,lda.alphab,10);
end

