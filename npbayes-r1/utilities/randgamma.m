function r = randgamma(a);
% a can take on multiple values. scale of gamma set at 1.  Do it yourself if
% your scale varies.

[rows columns] = size(a);

% Initialize r to zero.
lth = rows*columns;
r = zeros(lth,1);
a = a(:); 


% If a == 1, then gamma is exponential. (Devroye, page 405).
k = find(a == 1);
if any(k)
   r(k) = - log(rand(size(k)));
end 


k = find(a < 1 & a > 0);
% (Devroye, page 418 Johnk's generator)
if any(k)
  c = zeros(lth,1);
  d = zeros(lth,1);
  c(k) = 1 ./ a(k);
  d(k) = 1 ./ (1 - a(k));
  accept = k;
  while ~isempty(accept)
    u = rand(size(accept));
    v = rand(size(accept));
    x = u .^ c(accept);
    y = v .^ d(accept);
    k1 = find((x + y) <= 1); 
    if ~isempty(k1)
      e = -log(rand(size(k1))); 
      r(accept(k1)) = e .* x(k1) ./ (x(k1) + y(k1));
      accept(k1) = [];
    end
  end
  r(k) = r(k);
end

% Use a rejection method for a > 1.
k = find(a > 1);
% (Devroye, page 410 Best's algorithm)
bb = zeros(size(a));
c  = bb;
if any(k)
  bb(k) = a(k) - 1;
  c(k) = 3 * a(k) - 3/4;
  accept = k; 
  while ~isempty(accept)
    m = length(accept);
    u = rand(m,1);
    v = rand(m,1);
    w = u .* (1 - u);
    y = sqrt(c(accept) ./ w) .* (u - 0.5);
    x = bb(accept) + y;
    k1 = find(x >= 0);
    if ~isempty(k1)
      z = 64 * (w .^ 3) .* (v .^ 2);
      k2 = (z(k1) <= (1 - 2 * (y(k1) .^2) ./ x(k1)));
      k3 = k1(k2);
      r(accept(k3)) = x(k3); 
      k4 = k1(~k2);
      k5 = k4(log(z(k4)) <= (2*(bb(accept(k4)).*log(x(k4)./bb(accept(k4)))-y(k4))));
      r(accept(k5)) = x(k5);
      omit = [k3; k5];
      accept(omit) = [];
    end
  end
  r(k) = r(k);
end

% Return NaN if a or b is not positive.
r(a <= 0) = NaN;

r = reshape(r,rows,columns);
