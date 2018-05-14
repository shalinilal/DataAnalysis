% Plot Vds_on1 Vds_on2 Idmax Vdssat Ron Gout for each device from metric-table 

endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
clear wk_dir FileName Metric_FileName Metric_Data Metric_Data2 w
clear MetricData_device_name MetricData_Vc MetricData_Vds_on1 MetricData_Vds_on2 MetricData_Idmax MetricData_Vdssat MetricData_Ron MetricData_Gout
clear DevData DevLookup_name DevLookup_Lap DevLookup_Lgo DevLookup_Lga DevLookup_W
clear i_DevData i_MetricData i_LapSeries i_Vc
clear LapSeries p1 p2 p3


PlotLineSpec = {'.k', '.r', '.b'};

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
for i_LapSeries=1:1:length(LapSeries)
    for i_Vc = 0:-1:-2
        i_Vc == LapSeries(i_LapSeries,2)
        if i_Vc == LapSeries(i_LapSeries,2)
            hold on;
                p1(i_Vc)=plot(LapSeries(i_LapSeries,1),LapSeries(i_LapSeries,3),PlotLineSpec{1},'LineWidth',3);  
%                 p2=plot(LapSeries(:,1),LapSeries(:,4),PlotLineSpec{2},'LineWidth',3);  
%                 p3=plot(LapSeries(:,1),LapSeries(:,6),PlotLineSpec{3},'LineWidth',3);  
        end          
    end              
end                 