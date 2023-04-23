na=2;
nb=1;
nc=6;
d=2;

%RLS
[A,B] = rls( y2, u2, na, nb, d );
%valid
[err,yhat] = errpred_rls(y2,u2,A,B);
%autocorr
figure;
plotresiduals(err,yhat)

%ELS
[A,B,C] = els( y2, u2, na, nb, nc,d );
%valid
[err,yhat] = errpred_els(y2,u2,A,B,C);
%autocorr
figure;
plotresiduals(err,yhat)