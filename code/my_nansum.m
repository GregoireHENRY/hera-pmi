function S = my_nansum(M, opt)
if nargin < 2
    opt = 1;
end

S = sum(M(logical(1-isnan(M))), opt);