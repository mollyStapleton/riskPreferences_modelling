function [c, ceq] = constraint_LR(aQ, aS)

c = aQ - aS;  % Inequality constraint: x(1) - x(2) >= 0
ceq = [];    % No equality constraints

end 