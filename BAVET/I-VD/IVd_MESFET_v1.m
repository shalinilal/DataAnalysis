% Plot same diode from different samples 
% Plot I-V of S-D/G-D/G-S diodes%
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
% FileName_1 = 'R35_T1S1';
% FigureStr = 'B61 R3C4 TLM-T4 - Plot I-V for all TLM pads without p InAlAs';

PlotLineSpec = {'k', '--r', 'b'};
Width = 100 %in um - Mask Diodev2.1% 
% read device details: name, Lap,Lg,Lgmesa %
DevData = read_mixed_csv('devcode_BAVETv2p4.txt','\t');
DevLookup (:,1) =  DevData(3:end,1)  % Device name%
DevLookup (:,2) =  DevData(3:end,2)  % Aperture length in um%
DevLookup (:,3)=  DevData(3:end,3)  % Gate-CBL overlap in um%                 
DevLookup (:,4)=  DevData(3:end,4)  % Gate-aperture overlap in um%
DevLookup (:,5)=  DevData(3:end,5)  % Gate-Width in um%

clear wk_dir;
clear files;
clear i_dir;
i_dir=1;
clear Ap_Area Gt_Width Gt_Area Ms_Width Ms_Area PlotData FileData sample_info index_sampleinfo i_slashes

     wk_dir = input('Import Directory: ','s');
     wk_dir = strcat(wk_dir,'\')
     filename1 = input('Input file name: ','s')
     %Get device size, width, Lgo, Lga etc of the device 
      for i_devlookup = 1:length(DevLookup)
        if strcmpi(DevLookup(i_devlookup,1), filename1(1:end-7))
            Wap = str2num(DevLookup{i_devlookup,5}) %in um
            Lap = str2num(DevLookup{i_devlookup,2}) %in um
            Ap_Area = (Lap.* Wap.* 10^(-4)).^2 % cm2
            Lgo = str2num(DevLookup{i_devlookup,3}) %in um
            Gt_Area = (Lgo.* Wap.* 10^(-4)).^2 % cm2
            Lga = str2num(DevLookup{i_devlookup,4}) % in um
            
        end
      end
      %Ends - Get device size, width, Lgo, Lga etc of the device 
      
      %Get sample, die, measurement information 
     i_slashes = strfind(wk_dir,filesep())
     sample_info{1,1} = wk_dir((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
     index_sampleinfo = strfind(sample_info{1,1},'_')
     sample_info{1,2} = sample_info{1,1}(1:index_sampleinfo(1)-1)     %sample number
     sample_info{1,3}= sample_info{1,1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %structure info whether p or pi or i InAlAs      
          
     index_dopinginfo = strfind(sample_info{1,1},'InAlAs')  
     sample_info{1,4}= sample_info{1,1}(index_dopinginfo(1)-1) %doping in InAlAs
    
     sample_info{1,5} = wk_dir((i_slashes(6)+1):(i_slashes(7)-1))     %die number
     sample_info{1,6} = wk_dir((i_slashes(7)+1):(i_slashes(8)-1))
     sample_info{1,7} = wk_dir((i_slashes(8)+1):(i_slashes(9)-1))     % measurement technique 
     sample_info{1,8} = wk_dir((i_slashes(9)+1):(i_slashes(10)-1))     % Which diode : G-D or S-D or G-S
     sample_info{1,9} = sample_info{1,1}(index_sampleinfo(3)+1:end)
%      if strcmpi(sample_info{i,7},'C-V')
%         sample_info{1,9} = wk_dir((i_slashes(10)+1):(i_slashes(11)-1))
%      end
    %Ends - Get sample, die, measurement information
    
    
    filename =   strcat(wk_dir,filename1)     
    FileData = read_mixed_csv(filename,'\t') %reading data from the file which includes header and measurements
    [nrows, ncols]=size(FileData)
    header= FileData(4,:)
   
    if FileData{2,1}(1:end-1) == 'VDS'
        Vd_step = str2double(FileData{2,6})
         if str2double(FileData{2,2}) > str2double(FileData{2,4}) % find Vdmax and Vdmin, depends on how the measurement was swept
               Vd_min= str2double(FileData{2,4})
               Vd_max= str2double(FileData{2,2})         
        else
               Vd_min= str2double(FileData{2,2})
               Vd_max= str2double(FileData{2,4})
        end 
    end
       i_PlotData =1;
    for i_FileData=6:1:length(FileData)
        if strcmp(FileData(i_FileData,2), '----------------')== 0
            PlotData(i_PlotData,1) = str2double(FileData(i_FileData,2)); %Vds
            PlotData(i_PlotData,2) = str2double(FileData(i_FileData,3)); %Id
            PlotData(i_PlotData,3) = str2double(FileData(i_FileData,4)); %Vgs
            PlotData(i_PlotData,4) = str2double(FileData(i_FileData,5)); %Ig
            i_PlotData = i_PlotData + 1;   
        end
    end    
    
    if FileData{3,1}(1:end-1) == 'VG'
        Vg_step = str2double(FileData{3,6})
        if str2double(FileData{3,2}) > str2double(FileData{3,4})  % find Vgmax and Vgmin, depends on how the measurement was swept
               Vg_min= str2double(FileData{3,4})
               Vg_max= str2double(FileData{3,2})         
        else
               Vg_min= str2double(FileData{3,2})
               Vg_max= str2double(FileData{3,4})
        end    
    end
    


clear Vd Id Ig Is iVg i_column i_plot p1 i_data count  Vg_old  Vg_new dI dI_max dI_min i_Vdstart i_Vdend V_turnon R_on

i_row =0
 Vg_new = PlotData(1,3)
 l = length(PlotData)
 count = 1;
if Vg_step < 0
    i_column = 1;
    i_row =0;
    for i_data=1:1:length(PlotData)
               Vg_old = Vg_new
               Vg_new = PlotData(i_data,3)      
            if Vg_old == Vg_new
               i_row = i_row+1
               z1=i_data
            else count = count + 1   
                  i_row =1
                  z2=i_data
            end    
            Vd(i_row,count)=  PlotData(i_data,1);
            [VdmaxperVg(count), iVdmaxperVg(count)]= max(Vd(:,count))
            Id(i_row,count)=  PlotData(i_data,2);
            Jd(i_row,count)=  (Id(i_row,count).*(10^3))./(Wap.*(10^-3)); %mA/mm Divide I by two source widths
            
            Ig(i_row,count)=  PlotData(i_data,4);
            Jg(i_row,count)=  (Ig(i_row,count).*(10^3))./(Wap.*(10^-3)); %mA/mm Divide I by two source widths
            
            Is(i_row,count)=  -1*(Id(i_row,count) + Ig(i_row,count));
            Js(i_row,count)=  (Is(i_row,count).*(10^3))./(Wap.*(10^-3)); %mA/mm Divide I by two source widths
    end
           
end 


%

%     p1=plot(Vd(1:iVdmaxperVg(1),1),Jd(1:iVdmaxperVg(1),1),'LineWidth',2,'Color','k');  
%       p2=plot(Vd(1:iVdmaxperVg(1),1),abs(Js(1:iVdmaxperVg(1),1)),'LineWidth',1,'Color','r');  
%       p3=plot(Vd(1:iVdmaxperVg(1),1),abs(Jg(1:iVdmaxperVg(1),1)),'LineWidth',1,'Color','g');  
%       hold on;
%
TitleStr1=[sample_info{1,2},' (',sample_info{1,4},'-InAlAs/InGaAs/',sample_info{1,9},') ',sample_info{1,5},' ', sample_info{1,8},' ',': Lap = ', num2str(Lap),' ',char(0181),'m, Lgo= ',num2str(Lgo),' ',char(0181),'m, Lga= ',num2str(Lga),' ',char(0181),'m, W = ( ', num2str(Wap),char(0181),'m) Vgs =', num2str(Vg_max), ' V to ', num2str(Vg_min), ' V in steps of ', num2str(Vg_step), ' V']
  for i_column=1:1:size(Vd,2)
      x=1;
      %figure settings
        fig1= figure(1);
        title(TitleStr1, 'Units', 'normalized', ...
        'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman')
        set(gcf,'color','w');
        box on;
        Ax1=gca;
        set(Ax1,'LineWidth',2)
        set(Ax1,'XMinorTick','on')
        set(Ax1,'YMinorTick','on')
        set(Ax1,'YMinorTick','on')
%        ylim('auto')
        ylim([0 25])
        set(Ax1,'YTick',[0:5:25]) %mA
%        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])
        set(Ax1,'XLim',[0 VdmaxperVg(1)+1])
        set(Ax1, 'XTick', [0 0.5 1 1.5 2 2.5])
        set(Ax1,'YColor', 'black')
        ylabelC = ['I_{D}, I_{S} (mA/mm)'];
        ylabel(get(Ax1,'Ylabel'),'String',ylabelC,'FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{DS} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
%        Legend_eachC= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
        
%       
      %Ends - figure settings
      hold on; 
      p1=plot(Vd(1:iVdmaxperVg(i_column),i_column),Jd(1:iVdmaxperVg(i_column),i_column),PlotLineSpec{1},'LineWidth',2);  
      p2=plot(Vd(1:iVdmaxperVg(i_column),i_column),abs(Js(1:iVdmaxperVg(i_column),i_column)),PlotLineSpec{2},'LineWidth',1);  
%       p3=plot(Vd(1:iVdmaxperVg(i_column),i_column),abs(Jg(1:iVdmaxperVg(i_column),i_column)),PlotLineSpec{3},'LineWidth',1);  
      hold on;
      %check if Id+Is+Ig =0%
      dI(1:iVdmaxperVg(i_column),i_column) = Id(1:iVdmaxperVg(i_column),i_column)+ Is(1:iVdmaxperVg(i_column),i_column)+ Ig(1:iVdmaxperVg(i_column),i_column)
      dI_max = max(dI)
      dI_min = min(dI)
      %%

         
         
      Legend_name{1}='I_{D}'
      Legend_name{2}='I_{S}'
      PlotLegend1=legend(Legend_name)
      set(PlotLegend1,'YColor',[1 1 1],'XColor',[1 1 1],...
           'FontSize',22,'FontName','Times New Roman');
      
  end
  
  %get Ron, turn-on voltage, output conductance
    for i_column=1:1:2  % for Vg of 0V and -1 V  
        i_Vdstart{i_column} = min(find((Vd(1:iVdmaxperVg(i_column),i_column) > 0.1))); % index when Vd > 1.5V
        i_Vdend{i_column} = min(find((Vd(1:iVdmaxperVg(i_column),i_column) > 0.4))); % index when Vd > 2V
        fitJdVd{i_column} = polyfit(Vd(i_Vdstart{i_column}:i_Vdend{i_column},i_column),Jd(i_Vdstart{i_column}:i_Vdend{i_column},i_column),1);
        x_fit= -2:0.2:5;
        y_fit = fitJdVd{i_column}(2)+x_fit*fitJdVd{i_column}(1); %making a line to get 
         V_turnon(i_column)= -1.*(fitJdVd{i_column}(2)/fitJdVd{i_column}(1));
         R_on(i_column) = (1./fitJdVd{i_column}(1)).*(10^3) %in Ohm-mm
        hold on;
%         p3=plot(Vd(1:iVdmaxperVg(i_column),i_column),Jd(1:iVdmaxperVg(i_column),i_column),PlotLineSpec{1},'LineWidth',2);  
        p4=plot(x_fit,y_fit,PlotLineSpec{3},'LineWidth',1);
    end
    
    V_turnon
    R_on
    
    
    
    