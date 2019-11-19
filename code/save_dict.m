clear;

r = 1.7557;
U = containers.Map('KeyType', 'double', 'ValueType', 'any');
for g = [30 50 100 200 400 600 1000 2000]
    load(sprintf('u_r%.4f_g%d.mat', r, g));
    U(g) = u;
end

save(sprintf('U_r%.4f.mat', r), 'U');