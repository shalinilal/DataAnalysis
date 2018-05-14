
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
S4 = 'D1B24';
S6 = '.txt';
S0 = 'BAVET';
char K;
K = {'D1B24', 'D2B24','D3B24', 'D9B24','D8B24','D7B24', 'C3B24','C4B24','C6B24'};
V = [6, 4, 3, 8, 10, 15, 15, 10, 6];
tf=0;
l=0; % will give an error if file name does not have a mapping size in V
Dev_name='Error in getting size';
    clearvars i;
% For loop to find the size of the device from device name
    for i = 1:1:size(K,2)
       tf= strcmp(K{i},S4);
  
            if tf == 1 
                  Dev_name = [S0,' ',num2str(V(i)),' ', char(0181),'m'];    
                Area = ((V(i)*150*10^(-4))); %cm2 
                l1=i; %storing location number of the device in V
            end   
    end
T2 = 'Bond 35: pInAlAs 53KeV';

 S1 = read_mixed_csv('D1B24.txt','\t');
Vgmax= str2num(S1{3,2})
Vgmin= str2num(S1{3,4})
dVg= str2num(S1{3,6})
Vdmax= round(str2num(S1{2,4}))+1
Vdmin= str2num(S1{2,2})

  [nrows, ncols]=size(S1)
  nrows-5;
   a1= cell(1800,4);
j=6;
  for i=1:1:nrows-5 
   
          a1(i,1) = {str2num((S1{j,2}))}; %Drain Voltage%
        a1(i,2) = {str2num((S1{j,3}))}; %Drain Current%
        a1(i,3) = {str2num((S1{j,4}))}; %Gate Voltage%
        a1(i,4) = {str2num((S1{j,5}))}; %Gate Current%
   j=j+1;
   
%        if a1(j,1)== (S2.data(j,1))
%             a1(j,3) = (S2.data(j,2)); 
%                a1(j,5) = (S2.data(j,2)/Area); %Capacitance scaled with area (F/cm2)%
%        else a1(j,3)= 100;a1(j,5)= 100;
%        end   
  end
b1=cell2mat(a1);
b1(1,3)
f1 = figure(1);
                % % grid on;
             hold on;
             set(gcf,'color','w');
             box on;
             ax1=gca;
             set(ax1,'LineWidth',2)
              set(ax1,'XMinorTick','on')
              set(ax1,'YMinorTick','on')
              set(ax1,'YMinorTick','on')
              set(ax1,'YLim',[0 30])
              set(ax1,'YTick',[0:5:30])
              set(ax1,'XTick',[0:2:8])
              set(ax1,'YColor', 'black')
              ylabel('I (mA)','FontSize',25,'FontName','Calibri') 
             xlabel('V (V)','FontSize',25,'FontName','Calibri') 
              set(ax1,'fontsize',25,'FontName','Calibri')
% % axes('FontSize',20,'FontName','Calibri'); 
 T1 = ['I-V BAVET, Area =', num2str(V(l1)),' ', char(0181),'m',' x ',num2str(V(l1)),' ', char(0181),'m'];
 
 
  for iVg=Vgmin:1:0 
    for ib1=1:1:size(b1) 
         if b1(ib1,3)==iVg 
               
             hold on
            p1=plot(b1(ib1,1),(b1(ib1,2)*(10^3)),'LineWidth',4,'Color','k');      
         end
    end
    
  end 
 L1=['ID (',S4,'mA)'];
 
 lg1=legend(p1,L1);
 set(lg1, 'Interpreter', 'none');
  t=title(T1,'FontSize',25);
%====
%  a1 = zeros(201,6);
%  dw= zeros(200,1);
%   dv= zeros(200,1);
%     for j=1:1:201
%        a1(j,1) = (S1.data(j,1)); %Voltage%
%        a1(j,2) = (S1.data(j,2)); %Capacitance (F)%
%        a1(j,4) = (S1.data(j,2)/Area); %Capacitance scaled with area (F/cm2)%
%        a1(j,6) = (a1(j,4)^-2); %1/C2 cm4/F2)%
%     
%        if a1(j,1)== (S2.data(j,1))
%             a1(j,3) = (S2.data(j,2)); 
%                a1(j,5) = (S2.data(j,2)/Area); %Capacitance scaled with area (F/cm2)%
%        else a1(j,3)= 100;a1(j,5)= 100;
%        end   
%     end
%      %Differentiating 1/C2 with V
% dy=diff((a1(:,6)));
% dx=diff(a1(:,1));
% xbase=(a1(2:end,1)+a1(1:end-1,1))/2;
% napp=(q*ep*0.5*(dy./dx)).^-1;
% w=ep./a1(:,4);
% for l=1:1:200   
%   dw(:,1)= interp1(w,linspace(1,length(w),200));
%      dv(:,1)= interp1(a1(:,1),linspace(1,length(a1(:,1)),200));
% end  
% %y=linspace(1,length(a1(:,1)))
%  
% %===============Plot C-V and G-V===============%
% f1 = figure(1);
% % grid on;
% hold on;
% set(gcf,'color','w');
% box on;
% ax1=gca;
% % axes('FontSize',20,'FontName','Calibri'); 
% T1 = ['C-V InAlAs/InGaAs (1MHz 50mV), Area =', num2str(V(l1)),' ', char(0181),'m',' x ',num2str(V(l1)),' ', char(0181),'m'];
% set(ax1,'LineWidth',2)
% set(ax1,'XMinorTick','on')
% set(ax1,'YMinorTick','on')
% set(ax1,'YMinorTick','on')
%  set(ax1,'YLim',[0 20])
%  set(ax1,'YTick',[0:5:20])
%   set(ax1,'XTick',[0:2:6])
% % set(ax1,'YColor', 'black')
% ylabel('Capacitance (pF)','FontSize',25,'FontName','Calibri') 
% xlabel('V (V)','FontSize',25,'FontName','Calibri') 
% set(ax1,'fontsize',25,'FontName','Calibri')
% 
% hold on
% p1=plot(a1(:,1),(a1(:,2)*(10^12)),'LineWidth',2,'Color','k');
% L1=['C (',S4,'Hz)'];
% 
% lg1=legend(p1,L1);
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