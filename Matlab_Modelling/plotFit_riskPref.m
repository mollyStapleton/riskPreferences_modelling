function plotFit_riskPref(dataIn, paramFit, model, dist)

if strcmpi(model, 'RW')
        plotFit_RW_riskPref(dataIn, paramFit, dist);
end

end