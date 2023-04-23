function plotflows(t,j,x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab M-file                Author: Ricardo Sanfelice
%
% Project: Simulation of a hybrid system
%
%
% Name: plotflows.m
%
% Description: plots a hybrid arc in hybrid time domain
%
% Version: 0.6
% Required files: -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% hybrid arc plot

% max (t,j) in simulation
T = t(length(t));
J = j(length(j));

% variables
Xarc = cell(J+1,1);
Tarc = cell(J+1,1);
Jarc = cell(J+1,1);
i = 1;
k = 1;
while i <= length(j),
   jcurrent = j(i);
   l = 0;
   clear xk tk jk;
   if (jcurrent < J)
      while (j(i+l) == jcurrent)
        xk(l+1) = x(i+l);
	tk(l+1) = t(i+l);
	jk(l+1) = j(i+l);
        l = l+1;
      end
   else
      for l=0:length(j)-i,
        xk(l+1) = x(i+l);
	tk(l+1) = t(i+l);
	jk(l+1) = j(i+l);
      end
      l = length(j)-i+1;
   end
   Xarc(jcurrent+1) = {xk};
   Tarc(jcurrent+1) = {tk};
   Jarc(jcurrent+1) = {jk};
   jcurrent;
   i = i+l;
end

%gca = figure(1);
%clf;
hold on

xith = cell2mat(Xarc(1));
tith = cell2mat(Tarc(1));
xprev = xith(length(xith));
tprev = tith(length(tith));
for i = 1:J+1,
   xith = cell2mat(Xarc(i));
   tith = cell2mat(Tarc(i));
   tmax = tith(length(tith));
   jith = cell2mat(Jarc(i));
   jmax = jith(length(jith));
   if(length(jith)==1)
       plot(tith,xith,'b*')
   else
       plot(tith,xith,'b')
   end
   hold on
   if (i>=2) & (i<=J+1)
       xpost = xith(1);
       tpost = tith(1);
       pPrev = [tprev, xprev];
       pPost = [tpost, xpost];
       plot([tprev tprev],[xprev xpost],'r--');
       xprev = xith(length(xith));
       tprev = tith(length(tith));
   end
   hold on
end

%grid on
xlabel('flows [t]')
set(gca,'Box','on')