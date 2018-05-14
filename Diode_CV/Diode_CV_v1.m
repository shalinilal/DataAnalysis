q=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
S4 = 'GD10';
S6 = '.txt';
S0 = 'Diode';
char K;
K = {'GD10', 'G2_1M','G3_1M', 'D4_1M','D5_1M','D6_1M','G4_1M','G5_1M'};
V = [75, 125, 125, 75, 75, 100,100,100];
tf=0;
l=0; % will give an error if file name does not have a mapping size in V
Dev_name='Error in getting size';
    clearvars i;
% For loop to find the size of the device from device name
    for i = 1:1:size(K,2)
       tf= strcmp(K{i},S4);
  
            if tf == 1 
                  Dev_name = [S0,' ',num2str(V(i)),' ', char(0181),'m'];    
                Area = ((V(i)*10^(-4))^2); %cm2 
                l=i; %storing location number of the device in V
            end   
    end
T2 = 'Bond 53: pInAlAs 53KeV';
 % Reading data from a file name
Name = [S4,S6];
    S1 = importdata(Name,'\t');
S1;
S2 = importdata(Name,'\t',228);
S2;
 a1 = zeros(201,6);
 dw= zeros(200,1);
  dv= zeros(200,1);
    for j=1:1:201
       a1(j,1) = (S1.data(j,1)); %Voltage%
       a1(j,2) = (S1.data(j,2)); %Capacitance (F)%
       a1(j,4) = (S1.data(j,2)/Area); %Capacitance scaled with area (F/cm2)%
       a1(j,6) = (a1(j,4)^-2); %1/C2 cm4/F2)%
    
       if a1(j,1)== (S2.data(j,1))
            a1(j,3) = (S2.data(j,2)); 
               a1(j,5) = (S2.data(j,2)/Area); %Capacitance scaled with area (F/cm2)%
       else a1(j,3)= 100;a1(j,5)= 100;
       end   
    end
     %Differentiating 1/C2 with V
dy=diff((a1(:,6)));
dx=diff(a1(:,1));
xbase=(a1(2:end,1)+a1(1:end-1,1))/2;
napp=(q*ep*0.5*(dy./dx)).^-1;
w=ep./a1(:,4);
for l=1:1:200   
  dw(:,1)= interp1(w,linspace(1,length(w),200));
     dv(:,1)= interp1(a1(:,1),linspace(1,length(a1(:,1)),200));
end  
%y=linspace(1,length(a1(:,1)))
 
%===============Plot C-V and G-V===============%
% f1 = figure(1);
% grid on;
% hold on;
% set(gcf,'color','w');
% % axes('FontSize',20,'FontName','Calibri'); 
% T1 = ['C-V InAlAs/InGaAs (1MHz 50mV), Area =', num2str(V(l)),' ', char(0181),'m',' x ',num2str(V(l)),' ', char(0181),'m'];
% 
% [AX,A1,A2] = plotyy(a1(:,1),(a1(:,2)*(10^12)),a1(:,1),(a1(:,3)*(10^3)),'plot');
% set(get(AX(1),'Ylabel'),'String','C (pF)','FontSize',25,'FontName','Calibri') 
% set(AX(1),'LineWidth',2)
% set(AX(1),'XMinorTick','on')
% set(AX(1),'YMinorTick','on')
% set(AX(1),'fontsize',25,'FontName','Calibri')
% set(get(AX(2),'Ylabel'),'String','G (mS)','FontSize',25,'FontName','Calibri') 
% set(AX(2),'fontsize',25,'FontName','Calibri')
% set(AX(2),'LineWidth',2)
% set(AX(2),'XMinorTick','on')
% set(AX(2),'YMinorTick','on')
% xlabel('V (V)','FontSize',25,'FontName','Calibri') 
% set(A1,'LineStyle','--')
% set(A2,'LineStyle',':')
% axes(AX(1))
% hold on
% p1=plot(a1(:,1),(a1(:,2)*(10^12)),'--','LineWidth',4);
% L1=['C (',S4,'Hz)'];
% axes(AX(2))
% hold on
% p2=plot(a1(:,1),(a1(:,3)*(10^3)),'o','LineWidth',2);
% L2=['G (',S4,'Hz)'];
% lg1=legend([p1 p2],L1,L2);
% set(lg1, 'Interpreter', 'none');
%  t=title({T1;T2},'FontSize',25);
% %setting position of title
%  pos=get(t,'Position');
% pos(2)=pos(2)-0.0250;
% set(t,...
%    'Position',pos)
% %setting position of plot
% pos2=get(AX(1),'Position');
% pos2(2)=pos2(2)-0.02;
% set(AX(1),...
%    'Position',pos2)
% grid on;
% hold off;

%===============Plot C-V (F/cm2) and G-V (S/cm2)===============%
f2 = figure(2);
% grid on;
hold on;
set(gcf,'color','w');
% axes('FontSize',20,'FontName','Calibri'); 
T3 = ['C-V InAlAs/InGaAs (1MHz 50mV)'];
ylabel1 = ['C (',char(0181),'F/cm^{2})'];
[AX,A3,A4] = plotyy(a1(:,1),(a1(:,4)*(10^6)),a1(:,1),(a1(:,5)),'plot');
set(get(AX(1),'Ylabel'),'String',ylabel1,'FontSize',25,'FontName','Calibri') 
set(AX(1),'LineWidth',2)
set(AX(1),'XMinorTick','on')
set(AX(1),'YMinorTick','on')
set(AX(1),'fontsize',25,'FontName','Calibri')
set(get(AX(2),'Ylabel'),'String','G (S/cm^{2})','FontSize',25,'FontName','Calibri') 
set(AX(2),'fontsize',25,'FontName','Calibri')
set(AX(2),'LineWidth',2)
set(AX(2),'XMinorTick','on')
set(AX(2),'YMinorTick','on')
set(AX(1), 'ylim', [0 0.25])
set(AX(2), 'ylim', [0 1])
xlabel('V (V)','FontSize',25,'FontName','Calibri') 
set(A3,'LineStyle','--')
set(A4,'LineStyle',':')
axes(AX(1))
hold on
p3=plot(a1(:,1),(a1(:,4)*(10^6)),'--','LineWidth',4);
L3=['C (',S4,'Hz)'];
axes(AX(2))
hold on
p4=plot(a1(:,1),(a1(:,5)),'o','LineWidth',2);
L4=['G (',S4,'Hz)'];
lg2=legend([p3 p4],L3,L4);
set(lg2, 'Interpreter', 'none');
 t2=title({T3;T2},'FontSize',25);
%setting position of title
 pos3=get(t2,'Position')
pos3(2)=pos3(2)-0.050;
set(t2,...
   'Position',pos3)
%setting position of plot
pos4=get(AX(1),'Position')
pos4(2)=pos4(2)-0.02;
pos4
set(AX(1),...
   'Position',pos4)
grid on;
hold off;
% %===============Plot 1/C2-V (cm4/F2)===============%
f3 = figure(3);

set(gcf,'color','w');
% axes('FontSize',20,'FontName','Calibri'); 
T5 = ['C^{-2}-V InAlAs/InGaAs (1MHz 50mV)'];

axes('FontSize',25,'FontName','Times New Roman');
ax1=gca;
hold on;
box on;
grid on;
p5=plot(a1(:,1),(a1(:,6)),'black','LineWidth',4);
xlabel('V (V)','FontSize',25,'FontName','Calibri')
ylabel2 = ['C^{-2} (',char(0181),'cm^{4}/F^{2})'];
ylabel(ylabel2);
       %Fitting a line to get the built-in voltage, fitting between
       %V=0 to V=1.2
index = (a1(:,1) >= 0) & (a1(:,1) <= 1.2)
p = polyfit(a1(index,1),a1(index,6),1);
x=-2:0.2:2.5;
yfit = p(2)+x*p(1); %making a line to get 
vbi= p(2)/p(1);
hold on;
vbi_text=['Vbi =',num2str(vbi)];
Nd=(q*ep*0.5*(p(1)))^-1
formatSpec = '%10.2e\n';
text(-1.8,(0.2*10^15),vbi_text,'FontSize',25,'FontName','Calibri');
text(-1.8,(0.5*10^15),num2str(Nd,formatSpec),'FontSize',25,'FontName','Calibri');
plot(x,yfit,'r','LineWidth',2);  
axis([-2 3 0 1e15]); 
L5=['C^{-2} 1MHz'];
lg3=legend(p5,L5);
%set(lg3, 'Interpreter', 'none');
 t3=title({T5;T2},'FontSize',25);
%setting position of title
 pos5=get(t3,'Position')
pos5(2)=pos5(2)-0;
set(t3,...
   'Position',pos5)
%setting position of plot
pos6=get(ax1,'Position')
pos6(2)=pos6(2)-0.02;
pos6
set(ax1,...
   'Position',pos6)
hold off;

% 
% % %===============Plot napp-V (cm-3)===============%
f4 = figure(4);

set(gcf,'color','w');
% axes('FontSize',20,'FontName','Calibri'); 
T5 ='n_apparent  - V - InAlAs/InGaAs (1MHz 50mV)';

[AX,A5,A6] = plotyy(a1(:,1),(a1(:,6)),dv,napp,'plot');
set(get(AX(1),'Ylabel'),'String','C (F/cm^{2})','FontSize',25,'FontName','Calibri') 
set(AX(1),'LineWidth',2)
set(AX(1),'XMinorTick','on')
set(AX(1),'YMinorTick','on')
set(AX(1),'fontsize',25,'FontName','Calibri')
set(get(AX(2),'Ylabel'),'String','n_app (cm^{-3})','FontSize',25,'FontName','Calibri') 
set(AX(2),'fontsize',25,'FontName','Calibri')
set(AX(2),'LineWidth',2)
set(AX(2),'XMinorTick','on')
set(AX(2),'YMinorTick','on')
xlabel('V (V)','FontSize',25,'FontName','Calibri') 
set(A5,'LineStyle','--')
 set(AX(1),'XLim',[0 6])
  set(AX(1),'YLim',[0 20])
set(AX(2),'XLim',[0 6])
%   set(AX(2),'YLim',[0 6e17])
axes(AX(1))
hold on
p6=plot(a1(:,1),(a1(:,6)),'--','LineWidth',2);
L6=['C (',S4,'Hz)'];

axes(AX(2))
hold on
p7=plot(dv,napp,'LineWidth',2);
L7='n_app (1 MHz)';
lg4=legend([p6 p7],L6,L7);
set(lg4, 'Interpreter', 'none');
t4=title({T5;T2},'FontSize',25);
set(t4, 'Interpreter', 'none');
% %setting position of title
pos6=get(t4,'Position')
pos6(2)=pos6(2)- (1.0e+018*0.08);
set(t4,...
  'Position',pos6)
% %setting position of plot
pos7=get(AX(1),'Position')
pos7(2)=pos7(2)-0.02;
pos7
set(AX(1),...
   'Position',pos7)
grid on;
hold off;
%   
% %===============Plot napp-x (cm-3)===============%
f5 = figure(5);

set(gcf,'color','w');
% axes('FontSize',20,'FontName','Calibri'); 
T6 ='n_apparent - x - InAlAs/InGaAs (1MHz 50mV)';
box on;
ax3=gca;
set(ax3,'LineWidth',2)
set(ax3,'XMinorTick','on')
set(ax3,'YMinorTick','on')
ylabel('n_app (cm^{-3})','FontSize',25,'FontName','Calibri') 
xlabel('x (nm)','FontSize',25,'FontName','Calibri') 
set(ax3,'fontsize',25,'FontName','Calibri')
hold on
p8=plot((dw*(10^7)),napp,'LineWidth',2);
 axis([0 250 0 3e17]); 
L8='n_app (1 MHz)';
lg5=legend(p8,L8);
set(lg5, 'Interpreter', 'none');
t5=title({T6;T2},'FontSize',25);
set(t5, 'Interpreter', 'none');
% %setting position of title
pos8=get(t5,'Position')
pos8(2)=pos8(2)- (4e+017*0.04);
set(t5,...
  'Position',pos8)
% %setting position of plot
pos9=get(ax3,'Position')
pos9(2)=pos9(2)-0.02;
pos9
set(ax3,...
   'Position',pos9)
grid on;
hold off;

%
% ax1=gca;
% axes(ax1);
% hold on;
% plot(a1(:,1),a1(:,2),' ','LineWidth',4,'Color',[0.5,0.5,0.5]);
% xlabel(ax1,'V (V)','FontSize',25,'FontName','Calibri');
% ylabel(ax1,'C (F)','FontSize',25,'FontName','Calibri');
% 
% ax2 = axes('Position',get(ax1,'Position'),...
%            'XAxisLocation','top',...
%            'YAxisLocation','right',...
%            'Color','none',...
%            'XColor','k','YColor','k');
% axes(ax2);
% hold on;
% plot(a1(:,1),a1(:,3),' ','-o','LineWidth',2,'Color',[0.5,0.5,0.5]);
% 
% % hl2 = line(a1(:,1),a1(:,3),'-o','LineWidth',2,'Color','k','Parent',ax2);
% % xlabel(ax1,'V (V)','FontSize',25,'FontName','Calibri');
% ylabel(ax2,'G (S)','FontSize',25,'FontName','Calibri');
