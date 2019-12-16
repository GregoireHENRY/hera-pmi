function x = NEWTON(x0, args, err)

% Subroutine to find the temperature at the surface using the newton method
% 
% Inputs
%     x0   - surface temperature previous value
%     args - structure containing all the necessary variables:
%                Q    - flux-in
%                u_p1 - temperature value one point deeper in the ground
%                u_p2 - temperature value two points deeper in the ground
%                c3    - flux-out constant: emi*SfBoltz
%                c4    - newton function constant: k/(2*dx)
%     err  - next value error threshold
%
% Outputs
%     x - surface temperature next value

if (nargin < 3), err = 1e-5; end

ii = 1;
while (true)
    a = NEWTONF(x0, args);
    b = NEWTONDF(x0, args);
    x = x0 - a ./ b;
    if (abs(x - x0) < err), break; end
    x0 = x;
    ii = ii + 1;
end