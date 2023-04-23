clc;
clear all;
close all;
% 
% % 1.alpha  2.Cl  3.Cd  4.CDp  5.Cm  6.Top Xtr  7.Bot Xtr  8.Cpmin  9.Chinge  10.XCp
% 
% % Storing all files in structures
% 
% A = readfile('Datafiles\Mark I_T1_Re0.175_M0.00_N9.0.txt');
% B = readfile('Datafiles\Mark I_T1_Re0.262_M0.00_N9.0.txt');
% C = readfile('Datafiles\Mark I_T1_Re0.350_M0.00_N9.0.txt');
% Mark1.R1 = A
% Mark1.R2 = B
% Mark1.R3 = C
% 
% A = readfile('Datafiles\NACA 6412_T1_Re0.175_M0.00_N9.0.txt');
% B = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0.txt');
% C = readfile('Datafiles\NACA 6412_T1_Re0.350_M0.00_N9.0.txt');
% NACA6412.R1 = A
% NACA6412.R2 = B
% NACA6412.R3 = C
% 
% A = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop 1%.txt');
% B = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop10%.txt');
% C = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop20%.txt');
% D = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop30%.txt');
% E = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop40%.txt');
% F = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop50%.txt');
% G = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop60%.txt');
% H = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop70%.txt');
% I = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop80%.txt');
% J = readfile('Datafiles\NACA 6412_T1_Re0.262_M0.00_N9.0_XtrTop90%.txt');
% NACA6412.tr1 = A
% NACA6412.tr10 = B
% NACA6412.tr20 = C
% NACA6412.tr30 = D
% NACA6412.tr40 = E
% NACA6412.tr50 = F
% NACA6412.tr60 = G
% NACA6412.tr70 = H
% NACA6412.tr80 = I
% NACA6412.tr90 = J
% 
% % Mark1 vs NACA 6412
% 
% % Endurance factor vs alpha
% EM1 = endurance(Mark1.R1);
% EN1 = endurance(NACA6412.R1);
% EM2 = endurance(Mark1.R2);
% EN2 = endurance(NACA6412.R2);
% EM3 = endurance(Mark1.R3);
% EN3 = endurance(NACA6412.R3);
% plot(Mark1.R1(:,1),EM1,'r',NACA6412.R1(:,1),EN1,'b','Linewidth',2)
% hold on
% plot(Mark1.R2(:,1),EM2,'r--',NACA6412.R2(:,1),EN2,'b--','Linewidth',2)
% plot(Mark1.R3(:,1),EM3,'r-.',NACA6412.R3(:,1),EN3,'b-.','Linewidth',2)
% ylabel('Endurance factor Cl^(3/2)/Cd','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'Re=175e03 Mark1','Re=175e03 NACA6412','Re=262e03 Mark1','Re=262e03 NACA6412','Re=350e03 Mark1','Re=350e03 NACA6412'},'fontsize',15)
% grid on
% 
% % Lift Coefficient
% figure
% plot(Mark1.R1(:,1),Mark1.R1(:,2),'r',NACA6412.R1(:,1),NACA6412.R1(:,2),'b','Linewidth',2)
% hold on
% plot(Mark1.R2(:,1),Mark1.R2(:,2),'r--',NACA6412.R2(:,1),NACA6412.R2(:,2),'b--','Linewidth',2)
% plot(Mark1.R3(:,1),Mark1.R3(:,2),'r-.',NACA6412.R3(:,1),NACA6412.R3(:,2),'b-.','Linewidth',2)
% ylabel('Lift Coefficient Cl','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'Re=175e03 Mark1','Re=175e03 NACA6412','Re=262e03 Mark1','Re=262e03 NACA6412','Re=350e03 Mark1','Re=350e03 NACA6412'},'fontsize',15)
% grid on
% 
% % Drag Coefficient
% figure
% plot(Mark1.R1(:,1),Mark1.R1(:,3),'r',NACA6412.R1(:,1),NACA6412.R1(:,3),'b','Linewidth',2)
% hold on
% plot(Mark1.R2(:,1),Mark1.R2(:,3),'r--',NACA6412.R2(:,1),NACA6412.R2(:,3),'b--','Linewidth',2)
% plot(Mark1.R3(:,1),Mark1.R3(:,3),'r-.',NACA6412.R3(:,1),NACA6412.R3(:,3),'b-.','Linewidth',2)
% ylabel('Drag Coefficient Cd','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'Re=175e03 Mark1','Re=175e03 NACA6412','Re=262e03 Mark1','Re=262e03 NACA6412','Re=350e03 Mark1','Re=350e03 NACA6412'},'fontsize',15)
% grid on
% 
% % Transition point
% figure
% plot(Mark1.R1(:,1),Mark1.R1(:,6),'r',NACA6412.R1(:,1),NACA6412.R1(:,6),'b','Linewidth',2)
% hold on
% plot(Mark1.R2(:,1),Mark1.R2(:,6),'r--',NACA6412.R2(:,1),NACA6412.R2(:,6),'b--','Linewidth',2)
% plot(Mark1.R3(:,1),Mark1.R3(:,6),'r-.',NACA6412.R3(:,1),NACA6412.R3(:,6),'b-.','Linewidth',2)
% ylabel('Top transition point Xtr top','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'Re=175e03 Mark1','Re=175e03 NACA6412','Re=262e03 Mark1','Re=262e03 NACA6412','Re=350e03 Mark1','Re=350e03 NACA6412'},'fontsize',15)
% grid on
% 
% 
% % Effect of Transition on NACA 6412
% 
% % Endurance factor vs alpha
% figure
% E1 = endurance(NACA6412.tr1);
% E10 = endurance(NACA6412.tr10);
% E20 = endurance(NACA6412.tr20);
% E30 = endurance(NACA6412.tr30);
% E40 = endurance(NACA6412.tr40);
% E50 = endurance(NACA6412.tr50);
% plot(NACA6412.tr1(:,1),E1,'r','Linewidth',2)
% hold on
% plot(NACA6412.tr10(:,1),E10,'r--','Linewidth',2)
% plot(NACA6412.tr20(:,1),E20,'r-.','Linewidth',2)
% plot(NACA6412.tr30(:,1),E30,'r:','Linewidth',2)
% plot(NACA6412.tr40(:,1),E40,'b','Linewidth',2)
% plot(NACA6412.tr50(:,1),E50,'b--','Linewidth',2)
% plot(NACA6412.R2(:,1),EN2,'k:','Linewidth',2)
% ylabel('Endurance factor Cl^(3/2)/Cd','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'1%','10%','20%','30%','40%','50%','no trip'},'fontsize',15)
% grid on
% 
% % Lift Coefficient vs alpha
% figure
% plot(NACA6412.tr1(:,1),NACA6412.tr1(:,2),'r','Linewidth',2)
% hold on
% plot(NACA6412.tr10(:,1),NACA6412.tr10(:,2),'r--','Linewidth',2)
% plot(NACA6412.tr20(:,1),NACA6412.tr20(:,2),'r-.','Linewidth',2)
% plot(NACA6412.tr30(:,1),NACA6412.tr30(:,2),'r:','Linewidth',2)
% plot(NACA6412.tr40(:,1),NACA6412.tr40(:,2),'b','Linewidth',2)
% plot(NACA6412.tr50(:,1),NACA6412.tr50(:,2),'b--','Linewidth',2)
% plot(NACA6412.R2(:,1),NACA6412.R2(:,2),'k:','Linewidth',2)
% ylabel('Lift Coefficient Cl','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'1%','10%','20%','30%','40%','50%','no trip'},'fontsize',15)
% grid on
% 
% % Drag Coefficient vs alpha
% figure
% plot(NACA6412.tr1(:,1),NACA6412.tr1(:,3),'r','Linewidth',2)
% hold on
% plot(NACA6412.tr10(:,1),NACA6412.tr10(:,3),'r--','Linewidth',2)
% plot(NACA6412.tr20(:,1),NACA6412.tr20(:,3),'r-.','Linewidth',2)
% plot(NACA6412.tr30(:,1),NACA6412.tr30(:,3),'r:','Linewidth',2)
% plot(NACA6412.tr40(:,1),NACA6412.tr40(:,3),'b','Linewidth',2)
% plot(NACA6412.tr50(:,1),NACA6412.tr50(:,3),'b--','Linewidth',2)
% plot(NACA6412.R2(:,1),NACA6412.R2(:,3),'k:','Linewidth',2)
% ylabel('Drag Coefficient Cd','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'1%','10%','20%','30%','40%','50%','no trip'},'fontsize',15)
% grid on
% 
% % Lift to Drag Ratio vs alpha
% figure
% plot(NACA6412.tr1(:,1),NACA6412.tr1(:,2)./NACA6412.tr1(:,3),'r','Linewidth',2)
% hold on
% plot(NACA6412.tr10(:,1),NACA6412.tr10(:,2)./NACA6412.tr10(:,3),'r--','Linewidth',2)
% plot(NACA6412.tr20(:,1),NACA6412.tr20(:,2)./NACA6412.tr20(:,3),'r-.','Linewidth',2)
% plot(NACA6412.tr30(:,1),NACA6412.tr30(:,2)./NACA6412.tr30(:,3),'r:','Linewidth',2)
% plot(NACA6412.tr40(:,1),NACA6412.tr40(:,2)./NACA6412.tr40(:,3),'b','Linewidth',2)
% plot(NACA6412.tr50(:,1),NACA6412.tr50(:,2)./NACA6412.tr50(:,3),'b--','Linewidth',2)
% plot(NACA6412.R2(:,1),NACA6412.R2(:,2)./NACA6412.R2(:,3),'k:','Linewidth',2)
% ylabel('Lift to Drag Ratio Cl/Cd','fontweight','bold','fontsize',20)
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'1%','10%','20%','30%','40%','50%','no trip'},'fontsize',15)
% grid on

% % Cp vs x
% fid = fopen('Datafiles\Cp_Graph.txt');
% bleh = cell2mat(textscan(fid, '%f %f %f %f %f %f','headerlines',1));
% figure
% plot(bleh(:,1),-bleh(:,2),'k',bleh(:,3),-bleh(:,4),'r',bleh(:,5),-bleh(:,6),'b','Linewidth',2)
% ylabel('Pressure Distribution','fontweight','bold','fontsize',20);
% xlabel('x','fontweight','bold','fontsize',20)
% legend({'alpha=0','alpha=6','alpha=9'},'fontsize',15)
% grid on
% 
% % Wing Design
% 
% % Endurance factor vs alpha
fid1 = fopen('Datafiles\HALE Drone_T1-7_3 m_s-LLT.txt');
NACA_wing = cell2mat(textscan(fid1, '%f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',8));
fid2 = fopen('Datafiles\Mark I Drone_T1-7_3 m_s-LLT.txt');
Mark1_wing = cell2mat(textscan(fid2, '%f %f %f %f %f %f %f %f %f %f %f %f %f','headerlines',8));
% figure
% for i = 1:length(NACA_wing(:,1))
%     if NACA_wing(i,3)<0
%         matrix1(i) = -abs(NACA_wing(i,3))^(3/2)/NACA_wing(i,6);
%     else
%         matrix1(i) = NACA_wing(i,3)^(3/2)/NACA_wing(i,6);
%     end
% end
% for i = 1:length(Mark1_wing(:,1))
%     if Mark1_wing(i,3)<0
%         matrix2(i) = -abs(Mark1_wing(i,3))^(3/2)/Mark1_wing(i,6);
%     else
%         matrix2(i) = Mark1_wing(i,3)^(3/2)/Mark1_wing(i,6);
%     end
% end
% plot(NACA_wing(:,1),matrix1,'b',Mark1_wing(:,1),matrix2,'r','Linewidth',2)
% ylabel('Endurance Factor Cl^(3/2)/Cd','fontweight','bold','fontsize',20);
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'NACA 6412','Mark1'},'fontsize',15)
% grid on

% % Lift Coefficient vs alpha
% figure
% plot(NACA_wing(:,1),NACA_wing(:,3),'b',Mark1_wing(:,1),Mark1_wing(:,3),'r','Linewidth',2)
% ylabel('Lift Coefficient Cl','fontweight','bold','fontsize',20);
% xlabel('alpha','fontweight','bold','fontsize',20)
% legend({'NACA 6412','Mark1'},'fontsize',15)
% grid on

% Viscouc Drag Coefficient vs alpha
figure
plot(NACA_wing(:,1),NACA_wing(:,5),'b',Mark1_wing(:,1),Mark1_wing(:,5),'r','Linewidth',2)
ylabel('Viscous Drag Coefficient Cdv','fontweight','bold','fontsize',20);
xlabel('alpha','fontweight','bold','fontsize',20)
legend({'NACA 6412','Mark1'},'fontsize',15)
grid on