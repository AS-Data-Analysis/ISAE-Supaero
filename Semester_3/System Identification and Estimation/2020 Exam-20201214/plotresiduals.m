function plotresiduals(err,yhat)
%Plot the cross correlation of err and the crtoss correlation of err and
%yhat. The two lines shoxs the 2.17/sqrt(N) whiteness criteria interval
subplot(211);
[x,l] = xcorr(err);
n=length(err);
h=stem(l,x/(err*err'));
r = 2.17/sqrt(n);
xlim([-30 30]);
ylim([-r*2 r*2]);
hold on;
line([-n n],[r r]);
line([-n n],[-r -r]);
title('Autocorrelation of residuals');
%crosscorr
subplot(212);
[x,l] = xcorr(err,yhat);
n=length(err);
h=stem(l,x/sqrt(err*err')/sqrt(yhat*yhat'));
r = 2.17/sqrt(n);
xlim([-30 30]);
ylim([-r*2 r*2]);
hold on;
line([-n n],[r r]);
line([-n n],[-r -r]);
title('Cross correlation of residuals and prediction error');
end

