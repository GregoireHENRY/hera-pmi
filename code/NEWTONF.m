function val = NEWTONF(x0, args)

% Subroutine function of the subroutine NEWTON
% 
% Inputs
%     x0   - surface temperature previous value
%     args - structure containing all the necessary variables:
%                Q    - flux-in
%                u_p1 - temperature value one point deeper in the ground
%                u_p2 - temperature value two points deeper in the ground
%                c3    - flux-out constant: emi*SfBoltz
%                c4    - newton function constant: k/(2*dx)
%
% Outputs
%     val - function value

Q    = args.Q;
u_p1 = args.u_p1;
u_p2 = args.u_p2;
c3   = args.c3;
c4   = args.c4;

val = Q - c3 * x0.^4 + c4 * (-u_p2 + 4*u_p1 -3*x0);