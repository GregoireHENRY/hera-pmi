function ang = angvec2(u, v, do_corr)

if (nargin < 3), do_corr=0; end

unorm = sqrt(sum(u.^2));
vnorm = sqrt(sum(v.^2));
udir = u ./ unorm;
vdir = v ./ vnorm;

% angle computation with the dot product
dotval = sum(udir .* vdir);
ang = real(acos(dotval));

% corrections
if (do_corr)
crossv = crossprod(u, v);
upvdir = crossv(:,2) / sqrt(sum(crossv(:,2).^2));
test = sum(crossv .* upvdir);
indcorr = test < 0;
ang(indcorr) = 2*pi-ang(indcorr);
end

% return in radians
ang = ang * 180/pi;