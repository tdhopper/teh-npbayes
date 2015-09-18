function beta = randstick(alpha,numclass);

one = ones(1,numclass);
zz = randbeta(one, alpha*one);
beta = zz .* cumprod([1 1-zz(1:numclass-1)]);
