function qq = deldata(qq,ss);

global DistGlobals
glob = DistGlobals{qq.id};
if qq.nn == size(ss,2)
  qq = glob.qq0;
  return
end

nums          = size(ss,2);
n0            = qq.nn-nums;
m0            = qq.mm-sum(ss,2);
SSchol        = qq.SSchol;
for ii = 1:nums
  SSchol      = cholupdate(SSchol,ss(:,ii),'-');
end
SSlogdet      = 2*sum(log(diag(cholupdate(SSchol,m0/sqrt(glob.rr+n0),'-'))));

qq.nn         = n0;
qq.mm         = m0;
qq.SSchol     = SSchol;
qq.SSlogdet   = SSlogdet;
qq.lik        = glob.Z(n0+1) - .5*(glob.vv+n0)*SSlogdet;
