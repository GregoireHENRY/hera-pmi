function data = set_tris(obj)

p1 = []; p2 = []; p3 = []; m = []; n = []; S = []; lo = []; la = [];
points = obj.v;
tri = obj.f.v;
ntri = length(tri);
for ii = 1:ntri
    ind = tri(ii, :);
    p1_ = points(ind(1), :);
    p2_ = points(ind(2), :);
    p3_ = points(ind(3), :);
    p1  = [p1; p1_];
    p2  = [p2; p2_];
    p3  = [p3; p3_];
    m1  = (p1_ + p2_) / 2;
    vm1 = p3_ - m1;
    m_  = m1 + 1/3 * vm1;
    m   = [m; m_];
    v1  = p3_ - p1_;
    v2  = p2_ - p1_;
    n   = [n; -cross(v1, v2) / norm(cross(v2, v1))];
    ang_v1v2 = acos(dot(v1, v2) / (norm(v1) * norm(v2)));
    h = sin(ang_v1v2) * norm(v2);
    S = [S; h * norm(v1) / 2];
    [lo_, la_, ~] = cart2sph(m_(1), m_(2), m_(3));
    lo = [lo; lo_];
    la = [la; la_];
end
data.m = m;
data.n = n;
data.sph = [lo, la];