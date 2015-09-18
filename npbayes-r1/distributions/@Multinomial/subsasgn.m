function qq = subsasgn(qq,S,bb);

if isa(bb,'Multinomial')
  qq.ni   = subsasgn(qq.ni,S,bb.ni);
  qq.nn   = subsasgn(qq.nn,S,bb.nn);
  qq.lik  = subsasgn(qq.lik,S,bb.lik);
else
  qq.ni   = subsasgn(qq.ni,S,bb);
  qq.nn   = sum(qq.ni,1);

  global DistGlobals;
  glob    = incmax(DistGlobals{qq.id},qq);
  DistGlobals{qq.id} = glob;

  [dd cc] = size(qq.ni);
  ix      = (1:dd)';
  index   = ix(:,ones(1,cc)) + qq.ni*dd;
  qq.lik  = sum(reshape(glob.Zi(index),dd,cc),1) - glob.ZZ(qq.nn+1);
end

