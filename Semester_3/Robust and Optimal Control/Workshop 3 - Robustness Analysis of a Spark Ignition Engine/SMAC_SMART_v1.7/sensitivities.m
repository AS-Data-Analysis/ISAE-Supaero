%%
% SENSITIVITIES                         Compute the mu-sensitivities
% ------------------------------------------------------------------
%
% This function computes the mu-sensitivities for an interconnection
% between an LTI system P and a  block-diagonal operator  Delta=diag
% (Delta_1,...,Delta_nblk) using the method  described in J. Douglas
% and M. Athans, The calculation of mu-sensitivities, Proceedings of
% the ACC, 1995.
%
% CALL
% musen=sensitivities(sys,blk,options);
%
% INPUT ARGUMENTS
% - sys: lti object describing the LTI system P.
% - blk: matrix defining the structure  of the block-diagonal opera-
%        tor Delta=diag(Delta_1,...,Delta_nblk). its first 2 columns
%        must be defined as follows for all i=1,...,nblk:
%        * blk(i,1:2)=[-ni 0] => Delta_i=di*eye(ni) with di real
%        * blk(i,1:2)=[ni 0]  => Delta_i=di*eye(ni) with di complex
%        * blk(i,1:2)=[ni ni] => Delta_i is a ni-by-ni LTI system
%        a third column can be used to specify skew uncertainties:
%        * blk(i,3)=0 => svds(Delta_i,1)<=1
%        * blk(i,3)=1 => svds(Delta_i,1)<=1/ubnd with ubnd minimized
%        if none, blk(i,3) is set to 1 for all i.
% - options: optional structured variable with the tuning parameters
%            of the mu upper bound algorithm (same definition as the
%            input argument options of the routine muub_mixed).
%
% OUTPUT ARGUMENT
% - musen: 1 x nblk row vector with the mu-sensitivities of the real
%          and the complex  parametric uncertainties  (musen(k)=0 if
%          Delta_k is not a parametric uncertainty).
%
% SMAC TOOLBOX - SMART LIBRARY
% See http://w3.onera.fr/smac/sensitivities for more info!
