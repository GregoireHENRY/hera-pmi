clear;

R_occ = 3;
R_tar = 1;

r_obs = [0; 0; 0];
r_occ = [0; 10; 0];
r_pos = [10; 10; 0] + R_tar*[cos(0); sin(0); 0];

ax = gca;
create_sphere(r_pos, R_tar);
ax.View = [0 90];

function S = create_sphere(r, R)
[X, Y, Z] = sphere();
S = surf(r(1)+X*R, r(2)+Y*R, r(3)+Z*R, 'EdgeAlpha', 0);
end