% Plot same diode from different samples 
% Plot I-V of S-D/G-D/G-S diodes%

%Take Ap_Area for gate-drain diodes
%and take Gt_Area for gate-source diodes
q = 1.60217646e-19;
Es = 8.9;
Eox = 9; %7.5;
Eo = 8.85E-14;%F / cm^2
dCmin = 5e-13 %F
% FileName_1 = 'R35_T1S1';
% FigureStr = 'B61 R3C4 TLM-T4 - Plot I-V for all TLM pads without p InAlAs';

PlotLineSpec = {'-k', '-b', '-g','-r','--k','--b','--g','--r'};
Width = 100 %in um - Mask Diodev2.1% 
% read device details: name, Lap,Lg,Lgmesa %
DevData = read_mixed_csv('devcode_Diodev2p1.txt','\t');
DevLookup (:,1) =  DevData(3:end,1)  % Device name%
DevLookup (:,2) =  DevData(3:end,2)  % Aperture size in um%
DevLookup (:,3)=  DevData(3:end,3)  % Gate electrode size in um%                 
DevLookup (:,4)=  DevData(3:end,4)  % Mesa size in um%

no_of_files = str2num(input('Number of files in different directories ','s'))    

clear wk_dir;
clear files;
clear i_dir;
i_dir=1;

% no = str2num(no_of_files)
 for i_dir = 1:no_of_files
     wk_dir{i_dir,:} = input('Import Directory: ','s');
     
 end  
 
 length(wk_dir);
 i_file = 1;
%       files = dir(fullfile('wk_dir{1}', 'wk_dir{2}', 'wk_dir{3}', 'R34_SD3.txt'))    
 for i_wkdir = 1:length(wk_dir)
            wk_dir(i_wkdir) = strcat(wk_dir(i_wkdir),'\');
 end
 wk_dir
 
   filename1 = input('Input file name: ','s')
   for i_devlookup = 1:length(DevLookup)
        if strcmpi(DevLookup(i_devlookup,1), filename1(1:end-4))
            Ap_Width = str2num(DevLookup{i_devlookup,2}) %in um
            Ap_Area = (str2num(DevLookup{i_devlookup,2}).* 10^(-4)).^2 % cm2
            Gt_Width = str2num(DevLookup{i_devlookup,3}) %in um
            Gt_Area = (str2num(DevLookup{i_devlookup,3}).* 10^(-4)).^2 % cm2
            Ms_Width = str2num(DevLookup{i_devlookup,4}) % in um
            Ms_Area = (str2num(DevLookup{i_devlookup,4}).* 10^(-4)).^2 % cm2
        end
    end
%  PlotData= cell(201,(2*no_of_files)); %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
 i_padinfo=1;
 k=1;
 clear i l;
 clear i_f;
 clear sample_info PlotData;
 for i=1:length(wk_dir)   
 clear FileData;
 clear files;
 
    w=wk_dir{i}
    
    
    i_slashes = strfind(wk_dir{i},filesep())
    sample_info{i,1} = wk_dir{i}((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
    index_sampleinfo = strfind(sample_info{i,1},'_')
    sample_info{i,2} = sample_info{i,1}(1:index_sampleinfo(1)-1)     %sample number
      sample_info{i,3}= sample_info{i,1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %structure info whether p or pi or i InAlAs      
      sample_info{i,4} = sample_info{i,1}(index_sampleinfo(2)+1:index_sampleinfo(3)-1) %structure info whether InGaN or GaN didoes
      index_dopinginfo = strfind(sample_info{i,1},'InAlAs')  
      sample_info{i,5}= sample_info{i,1}(index_sampleinfo(1)+1:index_dopinginfo(1)-1) %doping in InAlAs
    
    sample_info{i,6} = wk_dir{i}((i_slashes(6)+1):(i_slashes(7)-1))     %die number
    sample_info{i,7} = wk_dir{i}((i_slashes(8)+1):(i_slashes(9)-1))     % measurement technique 
    sample_info{i,8} = wk_dir{i}((i_slashes(9)+1):(i_slashes(10)-1))     % Which diode : G-D or S-D or G-S
    if strcmpi(sample_info{i,7},'C-V')
    sample_info{i,9} = wk_dir{i}((i_slashes(10)+1):(i_slashes(11)-1))     % Which diode : G-D or S-D or G-S
    end
    files = dir(wk_dir{i})
    l=length(files)
       for i_f=1:length(files)
          
            if ~files(i_f).isdir && strcmpi(files(i_f).name, filename1)
                
                filename=files(i_f).name
                filename =   strcat(w,filename)

  
   
                 FileData = readCV(filename) %reading data from the file which includes header and measurements
                 [nrows, ncols]=size(FileData)
                 
                 for i_tracea=1:length(FileData) 
                     iscellstr(FileData{i_tracea,1})
                     if (strcmpi(FileData{i_tracea,1},'"TRACE: A"'))==1 
                        index_traceA= i_tracea;
                     else i_tracea=i_tracea+1                             
                     end     
                     
                 end
                 index_traceA
                for i_traceb=1:length(FileData) 
                     iscellstr(FileData{i_traceb,1})
                     if (strcmpi(FileData{i_traceb,1},'"TRACE: B"'))==1 
                        index_traceB= i_traceb;
                     else i_traceb=i_traceb+1                             
                     end     
                     
                end
                  index_traceB
                  CV=FileData(index_traceA+4:index_traceA+204,1)
                  GV=FileData(index_traceB+4:index_traceB+204,1)
%                   CV{10,1}(2)
%                   GV{10,1}(2)
                 
                 for i_PlotData=1:1:length(CV) %read each filedata row into plotdata for each TLM pad or file
                      PlotData(i_PlotData,k) = (CV{i_PlotData,1}(1)); % Voltage%
                      PlotData(i_PlotData,k+1) = CV{i_PlotData,1}(2); % Current%
                      PlotData(i_PlotData,k+2) = GV{i_PlotData,1}(2);
%                     j_FileDataRow=j_FileDataRow+1; %next row from each filedata
%                   
                 end                                 

            end
                       

        end
          k=k+3;
          i=i+1;
    end

TitleStr1=['Frequency-dependent ',sample_info{1,7},' of ',sample_info{1,8},' diodes with ', sample_info{1,5}, '-InAlAs']   ;
TitleStr2=['Frequency-dependent G-V',' of ',sample_info{1,8},' diodes with ', sample_info{1,5}, '-InAlAs']   ;
TitleStrCinv2=['Frequency-dependent 1/C^{2}-V',' of ',sample_info{1,8},' diodes with ', sample_info{1,5}, '-InAlAs']   ;
TitleStrNV=['Frequency-dependent n-V',' of ',sample_info{1,8},' diodes with ', sample_info{1,5}, '-InAlAs']   ;
TitleStrNX=['Frequency-dependent n-x',' of ',sample_info{1,8},' diodes with ', sample_info{1,5}, '-InAlAs']   ;
% 
m=1;
[V_maxlim V_maxlim_i] = max(str2double(PlotData(:,1)));
[I_max I_max_i]=max(str2double(PlotData(:,2)));
I_maxlim = (I_max)./Gt_Area; %A/cm-2
[V_minlim V_minlim_i] = min(str2double(PlotData(:,1)));
[I_min I_min_i]=min(str2double(PlotData(:,2)));
I_minlim = I_min*(10^3)./Gt_Area;  %A/cm-2
I_step=10;
       

       clear PlotLinesC PlotLinesG PlotLinesCinv2 PlotLinesNV PlotLinesNX;
       clear LegendStrC LegendStrG LegendStrCinv2 LegendStrNV LegendStrNX;
clear x Vbi Nd ;
x=1;
% y=length(PadInfo)
while m <= (3*no_of_files) && x <= (no_of_files) 
        clear N dN x_fit y_fit;
        V=str2double(PlotData(:,m));
        C=str2double(PlotData(:,m+1))*10^6/(Gt_Area);
        Cm=str2double(PlotData(:,m+1));
        G=str2double(PlotData(:,m+2))/(Gt_Area);      
        Gm=str2double(PlotData(:,m+2));      
        dV = interp1(V,linspace(1,length(V),1000));
        dC = interp1(Cm,linspace(1,length(Cm),1000));
        dG = interp1(Gm,linspace(1,length(Gm),1000));
        
%         [C2,V2] = smoother(Cm,V,dCmin);
        Cinv2 = (Gt_Area ./ Cm).^2; %cm4/F-1
        

        dCinv2 = diff(Cinv2) ./ diff(V);
        N = (2 / (q*Es*Eo))./dCinv2;
        dN = interp1(N,linspace(1,length(N),1000));
         
        X = 1e7*Es*Eo*Ap_Area./Cm; %nm
        dX = interp1(X,linspace(1,length(X),1000));
         
         
         
     %Plot CV%       
        fig1= figure(1);
        title(TitleStr1, 'Units', 'normalized', ...
        'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(gcf,'color','w');
        box on;
        Ax1=gca;
        set(Ax1,'LineWidth',2)
        set(Ax1,'XMinorTick','on')
        set(Ax1,'YMinorTick','on')
        set(Ax1,'YMinorTick','on')
%        ylim('auto')
        ylim([0 0.2])
%        set(Ax1,'YTick',[1e-6:100:100]) %mA
%        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])
        set(Ax1,'XLim',[-1 V_maxlim])
        set(Ax1, 'XTick', [-1 0 1 2 3 4 5 6])
        set(Ax1,'YColor', 'black')
        ylabelC = ['C (',char(0181),'F/cm^{2})'];
        ylabel(get(Ax1,'Ylabel'),'String',ylabelC,'FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
%         Legend_eachC=[sample_info{x,9},' (',(sample_info{x,5}),'-InAlAs ' ,num2str((sample_info{x,2})),' ',filename1(1:end-4),')']        
%         LegendStrC{x}=sprintf('%s',Legend_eachC )
%         hold on;
%         PlotLinesC(x)=plot(V,C,PlotLineSpec{x},'LineWidth',2); 
      %ends - Plot CV%   
      
      %Plot GV% 
        fig2= figure(2);
        title(TitleStr2, 'Units', 'normalized', ...
        'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(gcf,'color','w');
        box on;
        Ax2=gca;
        set(Ax2,'LineWidth',2)
        set(Ax2,'XMinorTick','on')
        set(Ax2,'YMinorTick','on')
        set(Ax2,'YMinorTick','on')
%        ylim('auto')
       ylim([10.^-3 10.^2])
%        set(Ax1,'YTick',[1e-6:100:100]) %mA
        set(Ax2, 'YTick', [10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])
        set(Ax2,'XLim',[-1 V_maxlim])
        set(Ax2, 'XTick', [-1 0 1 2 3 4 5 6])
        set(Ax2,'YColor', 'black')
        ylabel('G (Scm^{-2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax2,'fontsize',25,'FontName','Times New Roman')

%         Legend_eachG = [sample_info{x,9},' (',(sample_info{x,5}),'-InAlAs ' ,num2str((sample_info{x,2})),' ',filename1(1:end-4),')']        
%         LegendStrG{x}=sprintf('%s',Legend_eachG ) 
% 
%          PlotLinesG(x)=semilogy(V,abs(G),PlotLineSpec{x},'LineWidth',2); 
%          hold on;% hold on should come after semilogy

         %ends - Plot GV% 
         
         %Plot Cinv2
         fig3= figure(3);
         title(TitleStrCinv2, 'Units', 'normalized', ...
        'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(gcf,'color','w');
        box on;
        Ax3=gca;
        set(Ax3,'LineWidth',2)
        set(Ax3,'XMinorTick','on')
        set(Ax3,'YMinorTick','on')
        set(Ax3,'YMinorTick','on')
%        ylim('auto')
        ylim([0 (6*(10^14))])
%        set(Ax3,'YTick',[1e-6:100:100]) %mA
%        set(Ax3, 'YTick', [10.^-2 10.^-1 10.^0 10.^1])
        set(Ax3,'XLim',[-1 V_maxlim])
        set(Ax3, 'XTick', [-1 0 1 2 3 4 5 6])
        set(Ax3,'YColor', 'black')
        ylabel('1/C^{2} (cm^{4}/F^{2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax3,'fontsize',25,'FontName','Times New Roman')

        Legend_eachCinv2= [sample_info{x,9},' (',(sample_info{x,5}),'-InAlAs ' ,num2str((sample_info{x,2})),' ',filename1(1:end-4),')']        
        LegendStrCinv2{x}=sprintf('%s',Legend_eachCinv2 )
        hold on;
        PlotLinesCinv2(x)=plot(V,Cinv2,PlotLineSpec{x},'LineWidth',2);
         
         index_1V = find((V > 0.5)); % Voltage range over which doping is constant for gate-drain diodes only, will change for gate-source and source-drain
         index_2p5V = find((V > 1.7)); % Voltage range over which doping is constant for gate-drain diodes only, will change for gate-source and source-drain
         p = polyfit(V(index_1V:index_2p5V),Cinv2(index_1V:index_2p5V),1);
  x_fit=-2:0.2:3;
 y_fit = p(2)+x_fit*p(1); %making a line to get 
 Vbi(x)= p(2)/p(1);
 hold on;
%  vbi_text=['Vbi =',num2str(vbi)];
 Nd(x)=(q*Es*Eo*0.5*(p(1)))^-1;
%  formatSpec = '%10.2e\n';
%  text(-1.8,(0.2*10^15),vbi_text,'FontSize',25,'FontName','Calibri');
%  text(-1.8,(0.5*10^15),num2str(Nd,formatSpec),'FontSize',25,'FontName','Calibri');
%  plot(x_fit,y_fit,PlotLineSpec{x},'LineWidth',1);
%  fprintf((sample_info{x,5}),'-InAlAs Vbi: %d and doping : %6.4e\n', Vbi(x),Nd(x));
fprintf('%s-InAlAs Vbi: %d and doping : %6.4e\n',(sample_info{x,5}),Vbi(x),Nd(x));
%         
         %ends Plot Cinv2
         
         %Plot N vs. V
         fig4= figure(4); 
         title(TitleStrNV, 'Units', 'normalized', ...
         'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
         set(gcf,'color','w');
         box on;
         Ax4=gca;
         set(Ax4,'LineWidth',2)
         set(Ax4,'XMinorTick','on')
         set(Ax4,'YMinorTick','on')
         set(Ax4,'YMinorTick','on')
%         ylim('auto')
        ylim([10.^16 10.^19])
%        set(Ax4,'YTick',[1e-6:100:100]) %mA
        set(Ax4, 'YTick', [10.^16 10.^17 10.^18 10.^19])
         set(Ax4,'XLim',[-1 V_maxlim])
        set(Ax4, 'XTick', [-1 0 1 2 3 4 5 6])
         set(Ax4,'YColor', 'black')
         ylabel('n (cm^{-3})','FontSize',25,'FontName','Times New Roman') 
         xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
         set(Ax4,'fontsize',25,'FontName','Times New Roman')
%         Legend_eachNV= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
         Legend_eachNV=[sample_info{x,9},' (',(sample_info{x,5}),'-InAlAs ' ,num2str((sample_info{x,2})),' ',filename1(1:end-4),')']        
         LegendStrNV{x}=sprintf('%s',Legend_eachNV ) 
           
         PlotLinesNV(x)=semilogy(dV,dN,PlotLineSpec{x},'LineWidth',2);
          hold on; 
         %ends Plot N vs. V
         
         %Plot N vs. X
         fig5= figure(5);
         title(TitleStrNX, 'Units', 'normalized', ...
         'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
         set(gcf,'color','w');
         box on;
         Ax5=gca;
         set(Ax5,'LineWidth',2)
         set(Ax5,'XMinorTick','on')
         set(Ax5,'YMinorTick','on')
         set(Ax5,'YMinorTick','on')
%         ylim('auto') 
          ylim([10.^16 10.^19])
%        set(Ax4,'YTick',[1e-6:100:100]) %mA
        set(Ax5, 'YTick', [10.^16 10.^17 10.^18 10.^19])

         set(Ax5,'XLim',[40 200])
         set(Ax5,'YColor', 'black')
         
         ylabel('n (cm^{-3})','FontSize',25,'FontName','Times New Roman') 
         xlabel('x (nm)','FontSize',25,'FontName','Times New Roman') 
         set(Ax5,'fontsize',25,'FontName','Times New Roman')  
%         Legend_eachNX= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
         Legend_eachNX=[sample_info{x,9},' (',(sample_info{x,5}),'-InAlAs ' ,num2str((sample_info{x,2})),' ',filename1(1:end-4),')']        
         LegendStrNX{x}=sprintf('%s',Legend_eachNX ) 
         
         PlotLinesNX(x)=semilogy(dX,dN,PlotLineSpec{x},'LineWidth',2);
         hold on;
         
         %======================================
         % Fit to get doping
        i_X_start1{x} = min(find(dX > 80)); % 0.4index when Vd > 1.5V
        i_X_end1{x} = min(find(dX > 92))
        fitdNdX{x} = polyfit(dX(i_X_start1{x}:i_X_end1{x}),abs(dN(i_X_start1{x}:i_X_end1{x})),1);
        x_fit1= 50:0.02:200;
        y_fit1 = fitdNdX{x}(2)+x_fit1*fitdNdX{x}(1); %making a line to get 
        %V_turnon1(x)= -1.*(fitY3X1{x}(2)/fitY3X1{x}(1));
        hold on;
        p4=plot(x_fit1,y_fit1,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        
        % Ends - Fit for mid Vds to get Vturn-on2
         
         
         %========================================
         
        m=m+3;
        x=x+1
   
end
 % PlotLegend=legend(PlotLinesC,LegendStrC{:})
%   PlotLegend2=legend(PlotLinesG,LegendStrG{:})
   PlotLegend3=legend(PlotLinesCinv2,LegendStrCinv2{:})
  PlotLegend4=legend(PlotLinesNV,LegendStrNV{:})
  PlotLegend5=legend(PlotLinesNX,LegendStrNX{:})
%          set(PlotLegend,'YColor',[1 1 1],'XColor',[1 1 1],...
%            'FontSize',18,'FontName','Times New Roman');
%         set(PlotLegend2,'YColor',[1 1 1],'XColor',[1 1 1],...
%            'FontSize',18,'FontName','Times New Roman');
     set(PlotLegend3,'YColor',[1 1 1],'XColor',[1 1 1],...
          'FontSize',18,'FontName','Times New Roman');
    set(PlotLegend4,'YColor',[1 1 1],'XColor',[1 1 1],...
          'FontSize',18,'FontName','Times New Roman');
set(PlotLegend5,'YColor',[1 1 1],'XColor',[1 1 1],...
          'FontSize',18,'FontName','Times New Roman');