% Plot Vds_on1 Vds_on2 Idmax Vdssat Ron Gout for each device from metric-table 

endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
clear wk_dir FileName Metric_FileName Metric_Data w i_slashes sample_info index_sampleinfo index_dopinginfo  Lga_title  Lgo_title
clear MetricData_table
clear DevData DevLookup_name DevLookup_Lap DevLookup_Lgo DevLookup_Lga DevLookup_W
clear i_DevData i_MetricData i_LapSeries i_Vc i_row count i_Xcol i_LapSeriesCol i_no_of_Y_LapSeries i_col_metric
clear LapSeries TitleStr1
clear Legend_eachY1 LegendStrY1 PlotLinesY1 PlotLegendY1
clear Lap_old Lap_new X Y1 Y2 Y3 Y4 Y5 Y6
clear Xmax_percontrol_var iXmax_percontrol_var Y1max_percontrol_var iY1max_percontrol_var Y1min_perVc iY1min_perVc 
clear X_max Y1_max Y1_min
clear Vc_label X_label Y1_label Y1_units
clear no_of_Y_LapSeries no_of_Vc Lap_old_forVc Lap_new_forVc
     


PlotLineSpec = {'+k', 'or', '^b'};

wk_dir{1,:} = input('Import Directory for Metric-table: ','s'); 

wk_dir(1) = strcat(wk_dir(1),'\');
w = wk_dir{1}

FileName = input('Input file name: ','s')
Metric_FileName =   strcat(w,FileName)

DevData = read_mixed_csv('devcode_BAVETv2p4.txt','\t');
Metric_Data = read_mixed_csv(Metric_FileName,'\t');




control_var_label= strcat(Metric_Data{2,2}(1),'_{',Metric_Data{2,2}(2:end),'}')
for i_col_metric = 1:1:size(Metric_Data,2)
    Y1_label{1,i_col_metric} = strcat(Metric_Data{2,i_col_metric}(1:end),'-InAlAs')
    
   % Y1_label{1,i_col_metric} = Metric_Data{2,i_col_metric}(1)
    Y1_units{1,i_col_metric} = Metric_Data{3,i_col_metric}
    
    MetricData_table(:,i_col_metric) = Metric_Data(4:end,i_col_metric);
    %First column is device name, then Vc, etc.    
end    


% % Extract sample info etc. from path
 %Get sample, die, measurement information 
     i_slashes = strfind(wk_dir{1,:},filesep())
     sample_info{1,1} = wk_dir{1,:}((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
     index_sampleinfo = strfind(sample_info{1,1},'_')
     sample_info{1,2} = sample_info{1,1}(1:index_sampleinfo(1)-1)     %sample number b46 for p
     sample_info{1,3}= sample_info{1,1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %sample number b34 for p-i     
     sample_info{1,4}= sample_info{1,1}(index_sampleinfo(2)+1:index_sampleinfo(3)-1) %sample number b23 for i
     index_dopinginfo = strfind(sample_info{1,1},'InAlAs')  
%      sample_info{1,4}= sample_info{1,1}(index_sampleinfo(2)+1:index_dopinginfo(1)-1) %doping in InAlAs
%     
      sample_info{1,5} = wk_dir{1,:}((i_slashes(6)+1):(i_slashes(7)-1))     %BAVET or MESFET
      sample_info{1,6} = strcat(Metric_Data{1,1}(1:3),'_{',Metric_Data{1,1}(4:5),'}') % I-VDS or I-VGS

     
     Y_boxaxislabel = strcat(Metric_Data{1,2}(1:1),'_{',Metric_Data{1,2}(2:end),'} (', Y1_units{1,2},')') % Yaxis label is the metric name
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
     if DevLookup_Lga(i_DevData) == 0  && DevLookup_Lap(i_DevData) >0 % Devices which are split and with Lgo = 1um or 2 or 3um, and an aperture
         z2=1
         Lga_title =DevLookup_Lga(i_DevData)
         Lgo_title =DevLookup_Lgo(i_DevData)
          for i_MetricData=1:1:length(MetricData_table) 
              DevLookup_name(i_DevData)
              MetricData_table(i_MetricData,1)
              z3=1
             if strcmpi(DevLookup_name(i_DevData),MetricData_table(i_MetricData,1)) %choose devices from MetricData which are split, and Lgo =1 and an aperture
                 z4=1
                 LapSeries(i_LapSeries,1) = DevLookup_Lap(i_DevData)
                  for i_col_metric = 2:1:size(Metric_Data,2)
                      LapSeries(i_LapSeries,i_col_metric) = str2double(MetricData_table(i_MetricData,i_col_metric))
                  end
                 i_LapSeries=i_LapSeries+1
                  
             end %if strcmpi DevLookup from DevData and device_name from MetricData
          end %loop on i_Metric_Data   
     end    %if DevLookup_Lgo
  end    %loop on i_DevData
 hold on; 
%  Vc_old=LapSeries(1,2)
%  Vc_new=Vc_old

%Get no_of_Vc
Lap_old_forVc = LapSeries(1,1)              
no_of_Y_LapSeries = size(LapSeries,2)-2
no_of_Vc = 0
for i_LapSeries=1:1:size(LapSeries,1)
    Lap_new_forVc = LapSeries(i_LapSeries,1)      
    if Lap_old_forVc == Lap_new_forVc
        no_of_Vc = no_of_Vc + 1
    end
end    
%    
%Ends Get no_of_Vc

Lap_new = LapSeries(1,1)
count = 0;
i_column = 1;
i_row =1;
%Plot Vds_on1 vs Lap, Vds_on2 vs. Lap, Vdssat vs. Lap, Idmax vs. Lap etc for each Vg

for i_LapSeries=1:1:size(LapSeries,1)
       
    
    for i_no_of_Y_LapSeries =1:1: no_of_Y_LapSeries %creates three column for every Y variable like Vds or Id or Ron etc, and puts data for each Vg in each column
    Y1(i_LapSeries,i_no_of_Y_LapSeries)=  LapSeries(i_LapSeries,2+i_no_of_Y_LapSeries); 
    end
end %end of for i_LapSeries=1:1:length(LapSeries)
% At end of the above For loop Y1 has:First three columns for Vds_on1, next three for Vds_on2, next three for Id_max etc

%    Plot Vds_on1 (or Y1) vs Lap
       
      
        %Plot and figures
        fig1= figure(1);
        set(gcf,'color','w');
        box on;
        Ax1=gca;
        set(Ax1,'LineWidth',2)
        
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
                          
       
        TitleStr1=[sample_info{1,5},'s with L_{GA} = ',num2str(Lga_title),' ',char(0181),'m ',Y_boxaxislabel,' vs. InAlAs doping type for ',control_var_label,' = ',num2str(LapSeries(1,2)),' V']
        
        title(TitleStr1, 'Units', 'normalized', ...
                         'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman', 'interpreter','tex')       
        %Ends - figure settings
        
        hold on; 

%         Legend_eachY1 = [Y1_label{1,2},' = ',num2str(LapSeries(i_Xcol,2)),' V']   
%         LegendStrY1{i_Xcol}=sprintf('%s',Legend_eachY1 ) 
         
  %  m='pInAlas'
    box_O = boxplot(Y1,'widths',0.1);
    %plot(box_O)
    set(Ax1,'xtick',1:1:3)
set(Ax1,'xticklabel',Y1_label(3:5),'FontSize',25,'FontName','Times New Roman')
ylabel(get(Ax1,'Ylabel'),'String',Y_boxaxislabel,'FontSize',25,'FontName','Times New Roman')

        hold on;

   
    
    
 
    
    
    
    
    
    
    
    
    
    
    