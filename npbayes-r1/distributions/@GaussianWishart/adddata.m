function qq = adddata(qq,ss);
% adds data vectors ss into qq

incmaxeval(qq.id,qq.nn+size(ss,2));
global DistGlobals
glob = DistGlobals{qq.id};

nums          = size(ss,2);
n2            = qq.nn+nums;
m2            = qq.mm+sum(ss,2);
SSchol        = qq.SSchol;
for ii = 1:nums
  SSchol      = cholupdate(SSchol,ss(:,ii));
end
SSlogdet      = 2*sum(log(diag(cholupdate(SSchol,m2/sqrt(glob.rr+n2),'-'))));

qq.nn         = n2;
qq.mm         = m2;
qq.SSchol     = SSchol;
qq.SSlogdet   = SSlogdet;
qq.lik        = glob.Z(n2+1) - .5*(glob.vv+n2)*SSlogdet;

