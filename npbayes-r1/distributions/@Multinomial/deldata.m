function qq = deldata(qq,ss);

global DistGlobals
id   = qq.id;
glob = DistGlobals{id};

dd            = glob.dd;
numq          = size(qq.ni,2);
nums          = length(ss);
if nums == 0
  return
elseif nums == 1
  sni         = 1;
else
  sni         = sparse(ss,ones(1,nums),ones(1,nums),glob.dd,1);
  [ss j sni]  = find(sni);
end

index       = ss(:,ones(1,numq)) + qq.ni(ss,:)*dd;
lik         = qq.lik - sum(reshape(glob.Zi(index),size(index)),1) ...
                     + glob.ZZ(qq.nn+1);

qq.ni(ss,:) = qq.ni(ss,:) - sni(:,ones(1,numq));
qq.nn       = qq.nn - nums;

index       = ss(:,ones(1,numq)) + qq.ni(ss,:)*dd;
qq.lik      = lik + sum(reshape(glob.Zi(index),size(index)),1) ...
                  - glob.ZZ(qq.nn+1);

