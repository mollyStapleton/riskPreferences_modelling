function [R] = simulate_rewDist(distType)

R = [];


if distType == 1
    % Gaussian

    for irew = 1:60

        R1(irew) = abs(round(randn*5+40));
        R2(irew) = abs(round(randn*15+40));
        R3(irew) = abs(round(randn*5+60));
        R4(irew) = abs(round(randn*15+60));

    end

    R = {[R1 NaN], [R2 NaN], [R3 NaN], [R4 NaN]};

else

    R = bimodal_distr;
    R = {R(:, 1), R(:, 2), R(:, 3), R(:, 4)};
    


end



    
end
