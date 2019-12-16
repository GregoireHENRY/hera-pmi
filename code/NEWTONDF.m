function val = NEWTONDF(x0, args)

% Subroutine derivative function of the subroutine NEWTON
% 
% Inputs
%     x0   - surface temperature previous value
%     args - structure containing all the necessary variables:
%                c3    - flux-out constant: emi*SfBoltz
%                c4    - newton function constant: k/(2*dx)
%
% Outputs
%     val - function value

c3 = args.c3;
c4 = args.c4;

val = 4 * c3 * x0.^3 - 3 * c4;