function [logit_x] = logit(x)

% 
% function to transform proportional data to normalize it for statistical analysis such as regressions
% the input data x must be proportions with values between 0-1
% where logit(x) = log(x/(1-x)) (https://en.wikipedia.org/wiki/Logit)
%
% This function uses an epsilon method to truncate the proportion data if there are occurrences of 0 and/or 1 values
% where epsilon is half of the lowest non-zero value of x 
% (if there are 0 values but not 1 values)
% or epsilon is half of the difference between 1 and the highest non-one value of x 
% (if there are 1 values but not 0 values)
% or the min of half of the lowest non-zero value of x and half of the difference between 1 and the highest non-one value of x 
% (if there are 0 and 1 values but not 0 values)
% and epsilon is substituted for the zero values and 1-epsilon is substituted for the 1 values 
% to truncate and maintain symmetry and shape of the logit distribution.
% https://stats.stackexchange.com/questions/109702/empirical-logit-transformation-on-percentage-data/110037#110037
% 
% This function uses the following two other custom matlab functions by Jan Gläscher:
% - nanmin2 find the minimum value from a vector or array that may contain nan values
% - nanmax2 find the maximum value from a vector or array that may contain nan values

% Copyright (c) 2023, Greg Pelletier
% All rights reserved.

% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:

% * Redistributions of source code must retain the above copyright notice, this
  % list of conditions and the following disclaimer.

% * Redistributions in binary form must reproduce the above copyright notice,
  % this list of conditions and the following disclaimer in the documentation
  % and/or other materials provided with the distribution

% * Neither the name of Greg Pelletier nor the names of its
  % contributors may be used to endorse or promote products derived from this
  % software without specific prior written permission.

% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% x = dat1 ./ 100;

if nanmin2(x(:)) < 0 | nanmax2(x(:)) > 1
	error('The range of values for logit(x) must be between 0 and 1');
end

% use epsilon to truncate the 0 and 1 values if there are occurrences of 0 and/or 1 values
if nanmin2(x(:)) == 0 & ~(nanmax2(x(:)) == 1)
	% epsilon is half of the lowest non-zero value of x 
	epsilon = x;
	epsilon(x==0) = nan;
	epsilon = nanmin2(epsilon(:)) ./ 2;
	% substitute zero values with epsilon and 1 values with 1-epsilon
	x(x==0) = epsilon;
	x(x==1) = 1-epsilon;
elseif nanmax2(x(:)) == 1 & ~(nanmin2(x(:)) == 0)
	% epsilon is half of the difference between 1 and the highest non-one value of x 
	epsilon = x;
	epsilon(x==1) = nan;
	epsilon = nanmax2(epsilon(:));
	epsilon = (1-epsilon) ./ 2;
	% substitute zero values with epsilon and 1 values with 1-epsilon
	x(x==0) = epsilon;
	x(x==1) = 1-epsilon;
elseif nanmin2(x(:)) == 0 & nanmax2(x(:)) == 1
	% epsilon1 is half of the lowest non-zero value of x 
	epsilon1 = x;
	epsilon1(x==0) = nan;
	epsilon1 = nanmin2(epsilon1(:)) ./ 2;
	% epsilon2 is half of the difference between 1 and the highest non-one value of x 
	epsilon2 = x;
	epsilon2(x==1) = nan;
	epsilon2 = nanmax2(epsilon2(:));
	epsilon2 = (1-epsilon2) ./ 2;
	% epsilon is the min of epsilon1 and epsilon2
	epsilon = min(epsilon1,epsilon2);
	% substitute zero values with epsilon and 1 values with 1-epsilon
	x(x==0) = epsilon;
	x(x==1) = 1-epsilon;
end

logit_x = log(x ./ (1-x));






