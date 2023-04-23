function [K,Gc,gopt] = hinfreg(sys,r,gmax,tol)
%
% [K,Gc,gopt] = hinfreg(sys,r,gmax,tol);
%
% This function is based on hinfsyn.  A regularization step is
% included to make the synthesis plant non singular.
%
% INPUTS:
% -------
%    sys  : synthesis plant in ss format
%    r    : 1x2 vector = [nb of measurements, nb of control inputs]
%    gmax : initial guess for maximum Hinf norm
%    tol  : tolerance level for regularization (optional argument)
%              default = 1d-5
%              tol=[] => no regularization is applied
%
% OUTPUTS:
% --------
%    K    : optimal Hinf controller in ss format
%    Gc   : closed-loop plant
%    gopt : minimized Hinf norm
