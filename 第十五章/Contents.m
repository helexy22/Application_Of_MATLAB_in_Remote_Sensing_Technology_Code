% IntroAD&OOP is a set of m-files to accompany the article:
%  "Introduction to Automatic Differentiation and MATLAB OOP"
%  preprint by Richard D. Neidinger, 12/11/08.
%
% Files
%   fdf       - takes a scalar and returns the double vector [ f(a), f'(a) ]
%   fgradf    - takes 3 scalars and returns the double vector 
%   FJF       - returns the value and Jacobian of a function F:R^3->R^3.
%   fseries3  - FSERIES returns a vector of Taylor coefficients about a, through order 3.
%   newtonfdf - NEWTON seeks a zero of the function defined in fdf using the initial a
%   newtonFJF - seeks a zero of the function defined in FJF using the initial A
%   series    - class implementing AD to compute series coefficients.
%   valder    - class implementing Automatic Differentiation by operator overloading.
