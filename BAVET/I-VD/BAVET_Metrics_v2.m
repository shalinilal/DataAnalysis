% Plot Vds_on1 Vds_on2 Idmax Vdssat Ron Gout for each device from metric-table 

endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
clear wk_dir FileName Metric_FileName Metric_Data Metric_Data2 w i_slashes sample_info index_sampleinfo index_dopinginfo  Lga_title  Lgo_title
clear MetricData_device_name MetricData_Vc MetricData_Vds_on1 MetricData_Vds_on2 MetricData_Idmax MetricData_Vdssat MetricData_Ron MetricData_Gout
clear DevData DevLookup_name DevLookup_Lap DevLookup_Lgo DevLookup_Lga DevLookup_W
clear i_DevData i_MetricData i_LapSeries i_Vc i_row count i_Xcol
clear LapSeries TitleStr1
clear Legend_eachY1 LegendStrY1 PlotLinesY1 PlotLegendY1
clear Lap_old Lap_new X Y1 Y2 Y3 Y4 Y5 Y6
clear Xmax_percontrol_var iXmax_percontrol_var Y1max_percontrol_var iY1max_percontrol_var Y2max_percontrol_var iY2max_percontrol_var Y3max_percontrol_var iY3max_percontrol_var Y4max_percontrol_var iY4max_percontrol_var Y5max_percontrol_var iY5max_percontrol_var Y6max_percontrol_var iY6max_percontrol_var
clear X_max Y1_max Y2_max Y3_max Y4_max Y5_max Y6_max
clear Vc_label X_label Y1_label Y2_label Y3_label Y4_label Y5_label Y6_label
clear Ax1 fig1 xlabelC ylabelC

PlotLineSpec = {'+k', 'or', '^b'};

wk_dir{1,:} = input('Import Directory for Metric-table: ','s'); 

wk_dir(1) = strcat(wk_dir(1),'\');
w = wk_dir{1}

FileName = input('Input file name: ','s')
Metric_FileName =   strcat(w,FileName)

DevData = read_mixed_csv('devcode_BAVETv2p4.txt','\t');
Metric_Data = read_mixed_csv(Metric_FileName,'\t');

MetricData_device_name = Metric_Data(4:end,1);
MetricData_Vc = str2double(Metric_Data(4:end,2));
MetricData_Vds_on1 = str2double(Metric_Data(4:end,3));
MetricData_Vds_on2 = str2double(Metric_Data(4:end,4));
MetricData_Idmax = str2double(Metric_Data(4:end,5));
MetricData_Vdssat = str2double(Metric_Data(4:end,6));
MetricData_Ron = str2double(Metric_Data(4:end,7));
MetricData_Gout = str2double(Metric_Data(4:end,8));

X_label = 'L_{AP}'
Vc_label = 'V_{GS}'
Y1_label = 'V_{DS-ON1}' 
Y2_label = 'V_{DS-ON2}'
Y3_label = 'I_{D-MAX}'
Y4_label = 'V_{DS-SAT}'
Y5_label = 'R_{ON}'
Y6_label = 'G_{OUT}'

% % Extract sample info etc. from path
 %Get sample, die, measurement information 
     i_slashes = strfind(wk_dir{1,:},filesep())
     sample_info{1,1} = wk_dir{1,:}((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
     index_sampleinfo = strfind(sample_info{1,1},'_')
     sample_info{1,2} = sample_info{1,1}(1:index_sampleinfo(1)-1)     %sample number
     sample_info{1,3}= sample_info{1,1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %structure info whether p or pi or i InAlAs      
          
     index_dopinginfo = strfind(sample_info{1,1},'InAlAs')  
     sample_info{1,4}= sample_info{1,1}(index_dopinginfo(1)-1) %doping in InAlAs
    
     sample_info{1,5} = wk_dir{1,:}((i_slashes(6)+1):(i_slashes(7)-1))     %Transistors
     sample_info{1,6} = Metric_Data{1};                              % measurement technique 
     
% % Ends - Extract sample info etc. from path



% % read device details: name, Lap,Lg,Lgmesa %
 DevData = read_mixed_csv('devcode_BAVETv2p4.txt','\t');
 DevLookup_name  =  DevData(3:end,1)  % Device name%
 DevLookup_Lap  =  str2double(DevData(3:end,2));  % Aperture length in um%
 DevLookup_Lgo =  str2double(DevData(3:end,3));  % Gate-CBL overlap in um%                 
 DevLookup_Lga =  str2double(DevData(3:end,4));  % Gate-aperture overlap in um%
 DevLookup_W =  str2double(DevData(3:end,5));  % Gate-Width in um%
 i_LapSeries=1
 
  for i_DevData=1:1:length(DevLookup_name)
      z1=1
     if DevLookup_Lga(i_DevData) == 0 && DevLookup_Lgo(i_DevData) == 1 && DevLookup_Lap(i_DevData) >0 % Devices which are split and with Lgo = 1um, and an aperture
         z2=1
         Lga_title =DevLookup_Lga(i_DevData)
         Lgo_title =DevLookup_Lgo(i_DevData)
          for i_MetricData=1:1:length(MetricData_device_name) 
              DevLookup_name(i_DevData)
              MetricData_device_name(i_MetricData)
              z3=1
             if strcmpi(DevLookup_name(i_DevData),MetricData_device_name(i_MetricData)) %choose devices from MetricData which are split, and Lgo =1 and an aperture
                 z4=1
             LapSeries(i_LapSeries,1) = DevLookup_Lap(i_DevData)
             LapSeries(i_LapSeries,2) = MetricData_Vc(i_MetricData)
             LapSeries(i_LapSeries,3) = MetricData_Vds_on1(i_MetricData)
             LapSeries(i_LapSeries,4) = MetricData_Vds_on2(i_MetricData)
             LapSeries(i_LapSeries,5) = MetricData_Idmax(i_MetricData)
             LapSeries(i_LapSeries,6) = MetricData_Vdssat(i_MetricData)
             LapSeries(i_LapSeries,7) = MetricData_Ron(i_MetricData)
             LapSeries(i_LapSeries,8) = MetricData_Gout(i_MetricData)
             i_LapSeries=i_LapSeries+1
             end %if strcmpi DevLookup from DevData and device_name from MetricData
          end %loop on i_Metric_Data   
     end    %if DevLookup_Lgo
  end    %loop on i_DevData
 hold on; 
%  Vc_old=LapSeries(1,2)
%  Vc_new=Vc_old

%Plot Vds_on1 vs Lap, Vds_on2 vs. Lap, Vdssat vs. Lap, Idmax vs. Lap etc for each Vg
Lap_new = LapSeries(1,1)
count = 0;
i_column = 1;
i_row =1;


 
                  
                  
for i_LapSeries=1:1:length(LapSeries)
       
    Lap_old = Lap_new
    Lap_new = LapSeries(i_LapSeries,1)      
    if Lap_old == Lap_new
        count = count + 1
             
    else i_row =i_row+1
         count =1   
    end    % end of if Vc_old == Vc_new
    X(i_row,count)=  LapSeries(i_LapSeries,1); % Vd for I-Vd, Vg for I-Vg and DCIM
%     if X_Var_step > 0
         [Xmax_perVc(count), iXmax_perVc(count)]= max(X(:,count))
%     else     
%         [Xmin_percontrol_var(count), iXmin_percontrol_var(count)]= min(X(:,count))
%      end
    Y1(i_row,count)=  LapSeries(i_LapSeries,3); %Vds_on1 for all Lap per Vg
    
                [Y1max_perVc(count), iY1max_perVc(count)]= max(Y1(:,count))
                
    Y2(i_row,count)=  LapSeries(i_LapSeries,4); %Vds_on2 for all Lap per Vg
                    [Y2max_perVc(count), iY2max_perVc(count)]= max(Y2(:,count))
    Y3(i_row,count)=  LapSeries(i_LapSeries,5); %Idmax for all Lap per Vg
                    [Y3max_perVc(count), iY3max_perVc(count)]= max(Y3(:,count))
    Y4(i_row,count)=  LapSeries(i_LapSeries,6); %Vdssat for all Lap per Vg
                    [Y4max_perVc(count), iY4max_perVc(count)]= max(Y4(:,count))
    Y5(i_row,count)=  LapSeries(i_LapSeries,7); %Ron for all Lap per Vg
                    [Y5max_perVc(count), iY5max_perVc(count)]= max(Y5(:,count))
    Y6(i_row,count)=  LapSeries(i_LapSeries,8); %Gout for all Lap per Vg
                    [Y6max_perVc(count), iY6max_perVc(count)]= max(Y6(:,count))
end %end of for i_LapSeries=1:1:length(LapSeries)

X_max = max(Xmax_perVc)
Y1_max = max(Y1max_perVc)
Y2_max = max(Y2max_perVc) 
Y3_max = max(Y3max_perVc)
Y4_max = max(Y4max_perVc)
Y5_max = max(Y5max_perVc)
Y6_max = max(Y6max_perVc)
 

    %Plot Vds_on1 (or Y1) vs Lap
    for i_Xcol= 1:1:size(X,2)              
        %Plot and figures
        fig1= figure(1);
        set(gcf,'color','w');
        box on;
        Ax1=gca;
        set(Ax1,'LineWidth',2)
        set(Ax1,'XMinorTick','on')
        set(Ax1,'YMinorTick','on')
        set(Ax1,'YMinorTick','on')
        ylim([0 round(Y1_max+0.5)])
        set(Ax1,'XLim',[0 X_max+2])
        set(Ax1, 'XTick', [0 2 4 6 8 10 12 14 16])
        set(Ax1,'YColor', 'black')
        %     if strcmpi(X_Var_Name, 'VG')== 1
        %                xlabelC = 'V_{GS} (V)'
        %                control_label = 'V_{DS}'
        %     elseif strcmpi(X_Var_Name, 'VDS') == 1     
        %                xlabelC = 'V_{DS} (V)'
        %                control_label = 'V_{GS}'
        %     end
        xlabelC = ['L_{AP} (',char(0181),'m)']               
        ylabelC = ['V_{DS-ON1}(V)'];
        ylabel(get(Ax1,'Ylabel'),'String',ylabelC,'FontSize',25,'FontName','Times New Roman') 
        xlabel(xlabelC,'FontSize',25,'FontName','Times New Roman') 
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
            %        Legend_eachC= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
                    
        %TitleStr1=[sample_info{1,2},' (',sample_info{1,4},'-InAlAs/InGaAs/) ',sample_info{1,5},' ', sample_info{1,6}]
        TitleStr1=[sample_info{1,2},' (',sample_info{1,4},'-InAlAs/InGaAs/) ',sample_info{1,5}, ' ',sample_info{1,6},' Metrics for devices with L_{GO}= ', num2str(Lgo_title),' ',char(0181),'m', ' and L_{GA}= ', num2str(Lga_title),' ',char(0181),'m',' ',Y1_label,' vs. ',X_label, ' for ', Vc_label,' = ',  num2str(LapSeries(1,2)),' V, ', num2str(LapSeries(2,2)),' V and ',num2str(LapSeries(3,2)),' V']
            %,  num2str(LapSeries{1,2}),' V, ']
                    %set(TitleStr1,'interpreter','tex') 
        title(TitleStr1, 'Units', 'normalized', ...
                         'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman', 'interpreter','tex')       
        %Ends - figure settings
        
        hold on; 
   
 %       p2=plot(X(:,i_Xcol),Y2(:,i_Xcol),PlotLineSpec{i_Xcol},'LineWidth',3);  
 %       p3=plot(X(:,i_Xcol),Y4(:,i_Xcol),PlotLineSpec{i_Xcol},'LineWidth',3);
 %                 p3=plot(X(1:iXmax_percontrol_var(i_column),i_column),abs(Y2_density(1:iXmax_percontrol_var(i_column),i_column)),PlotLineSpec{3},'LineWidth',1);  
       
        Legend_eachY1 = ['V_{G} = ',num2str(LapSeries(i_Xcol,2)),' V']   
        LegendStrY1{i_Xcol}=sprintf('%s',Legend_eachY1 ) 
        PlotLinesY1(i_Xcol)=plot(X(:,i_Xcol),Y6(:,i_Xcol),PlotLineSpec{i_Xcol},'LineWidth',3);
 
        hold on;
    end
    
    PlotLegendY1=legend(PlotLinesY1,LegendStrY1{:})
    set(PlotLegendY1,'YColor',[1 1 1],'XColor',[1 1 1],...
           'FontSize',18,'FontName','Times New Roman');
    
    %Ends Plot Vds_on1 vs Lap
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    