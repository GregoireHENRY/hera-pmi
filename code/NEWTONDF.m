function val = NEWTONDF(x0, args)

% Subroutine derivative function of the subroutine NEWTON
% 
% Inputs
%     x0   - surface temperature previous value
%     args - structure containing all the necessary variables:
%                c2    - flux-out constant: emi*SfBoltz
%                c3    - newton function constant: k/(2*dx)
%
% Outputs
%     val - function value

c2 = args.c2;
c3 = args.c3;

val = 4 * c2 * x0.^3 - 3 * c3;