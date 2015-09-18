function lik = marglikelihood(qq,ss);

lik = - cat(2,qq.lik);
qq = adddata(qq,ss);
lik = lik + cat(2,qq.lik);
