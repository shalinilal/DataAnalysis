% Plot same diode from different samples 
% Plot I-V of S-D/G-D/G-S diodes%
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
% FileName_1 = 'R35_T1S1';
% FigureStr = 'B61 R3C4 TLM-T4 - Plot I-V for all TLM pads without p InAlAs';

PlotLineSpec = {'k', 'r', 'b'};
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
clear Lap Wap Lgo Lga Ap_Area Gt_Area PlotData FileData sample_info index_sampleinfo i_slashes control_columnindex xvar_columnindex
clear  ind_cvar ind_xvar Control_Var_Name X_Var_Name wkdir w filenam1 
clear FileName FileData PlotData Control_Var_Start Control_Var_End

     wk_dir{1,:} = input('Import Directory for I-Vd: ','s');
      
     wk_dir{2,:} = input('Import Directory for I-Vg: ','s');
    
      for i_wkdir = 1:length(wk_dir)
            wk_dir(i_wkdir) = strcat(wk_dir(i_wkdir),'\');
      end
     
     filename1 = input('Input file name: ','s')
     %Get device size, width, Lgo, Lga etc of the device 
      for i_devlookup = 1:length(DevLookup)
        if strcmpi(DevLookup(i_devlookup,1), filename1(1:2))
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
     i_slashes = strfind(wk_dir{1,:},filesep())
     sample_info{1,1} = wk_dir{1,:}((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
     index_sampleinfo = strfind(sample_info{1,1},'_')
     sample_info{1,2} = sample_info{1,1}(1:index_sampleinfo(1)-1)     %sample number
     sample_info{1,3}= sample_info{1,1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %structure info whether p or pi or i InAlAs      
          
     index_dopinginfo = strfind(sample_info{1,1},'InAlAs')  
     sample_info{1,4}= sample_info{1,1}(index_sampleinfo(2)+1:index_dopinginfo(1)-1) %doping in InAlAs
    
     sample_info{1,5} = wk_dir{1,:}((i_slashes(6)+1):(i_slashes(7)-1))     %die number
     sample_info{1,6} = wk_dir{1,:}((i_slashes(7)+1):(i_slashes(8)-1))
     sample_info{1,7} = wk_dir{1,:}((i_slashes(8)+1):(i_slashes(9)-1))     % measurement technique 
     sample_info{1,8} = wk_dir{1,:}((i_slashes(9)+1):(i_slashes(10)-1))     % Which diode : G-D or S-D or G-S
     sample_info{1,9} = sample_info{1,1}(index_sampleinfo(3)+1:end)
     
%       if strcmpi(sample_info{i,7},'I-Vd')
%          
%       end
    %Ends - Get sample, die, measurement information
  clear Ax1 Ax2 X Y1 Y2 Y3 i_column i_plot p1 p2 p3 p1b p2b p3b p4 p5 p6 p7 p8 p9 p10 p11 p12 i_data count  control_Var_old  control_Var_new dI dI_max dI_min i_Vdstart i_Vdend
clear VdminperVg iVdminperVg Legend_name1 PlotLegend1 Legend_name2 PlotLegend2 V_turnon1 V_turnon2 R_on Xmax_percontrol_var iXmax_percontrol_var Y1max_percontrol_var iY1max_percontrol_var
clear Y2min_percontrol_var iY2min_percontrol_var Y3min_percontrol_var iY3min_percontrol_var xlabel xlabelC ylabel ylabelC TitelStr1 TitelStr1 TitelStr2
clear i_X_start1 i_X_end1 fitY3X1 i_X_start2 i_X_end2 fitY3X2 i_X_start3 i_X_end3 fitY3X3 G_out Vds_sat i_column2  
clear i_X_start4 i_X_end4 fitY3X4 i_X_start5 i_X_end5 fitY3X5 i_column3 V_th1 V_th2 gm Jd_max index_Vds_sat
clear i_X_start6 i_X_end6 fitY3X6 i_X_start7 i_X_end7 fitY3X7 i_column4 i_column5 G_out_off V_th1b fitY3X6 fitY3X7
for i=1:length(wk_dir) 
      clear X Y1 Y2 Y3 Y1_density Y2_density Y3_density X_max  Y1_max Y2_min Y3_min xlabelC ylabelC
    w=wk_dir{i}
    clear FileName FileData PlotData 
    FileName =   strcat(w,filename1)     
    FileData = read_mixed_csv(FileName,'\t') %reading data from the file which includes header and measurements
    [nrows, ncols]=size(FileData)
    FileData{2,1}
    
    
    ind_cvar= strfind(FileData{3,1},'=') 
    ind_xvar= strfind(FileData{2,1},'=')
    Control_Var_Name = FileData{3,1}(1:ind_cvar-1) % control variable name
    X_Var_Name = FileData{2,1}(1:ind_xvar-1)     % x axis variable name
    size(FileData,2)
    header= FileData(4,:)
    
     for i_header=1:1:5 % find columns of control variable like Vg and x_variable like Vd for I-Vd
        if(strcmpi(Control_Var_Name, FileData(4,i_header))== 1)
            control_columnindex = i_header
        elseif  (strcmpi(X_Var_Name, FileData(4,i_header))== 1)  
            xvar_columnindex = i_header     
        end    
     end 
    

     control_Var_step = str2double(FileData{3,6})
     X_Var_step = str2double(FileData{2,6})
%          
     Control_Var_Start= str2double(FileData{3,2})
     Control_Var_End = str2double(FileData{3,4})   
    
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
%     
                  
        
    
% 
% 


i_row =0
 control_Var_new = PlotData(1,control_columnindex-1)
 l = length(PlotData)
 count = 1;
    i_column = 1;
    i_row =0;
    for i_data=1:1:length(PlotData)
        
               control_Var_old = control_Var_new
               control_Var_new = PlotData(i_data,control_columnindex-1)      
            if control_Var_old == control_Var_new
               i_row = i_row+1
               z1=i_data
            else count = count + 1   
                  i_row =1
                  z2=i_data
            end    
            X(i_row,count)=  PlotData(i_data,xvar_columnindex-1); % Vd for I-Vd, Vg for I-Vg and DCIM
                if X_Var_step > 0
                    [Xmax_percontrol_var(count), iXmax_percontrol_var(count)]= max(X(:,count))
                else     
                    [Xmin_percontrol_var(count), iXmin_percontrol_var(count)]= min(X(:,count))
                end
            Y1(i_row,count)=  PlotData(i_data,2); %Id for all plots
            Y1_density(i_row,count)=  (Y1(i_row,count).*(10^3))./(1.*Wap.*(10^-3)); %mA/mm Divide I by two source widths
                [Y1max_percontrol_var(count), iY1max_percontrol_var(count)]= max(Y1(:,count))
                
            Y2(i_row,count)=  PlotData(i_data,4); % Ig for all plots
                [Y2min_percontrol_var(count), iY2min_percontrol_var(count)]= min(Y2(:,count))
            Y2_density(i_row,count)=  (Y2(i_row,count).*(10^3))./(1.*Wap.*(10^-3)); %mA/mm Divide I by two source widths
            
            Y3(i_row,count)=  -1*(Y1(i_row,count) + Y2(i_row,count)); % Is for all plots
                [Y3min_percontrol_var(count), iY3min_percontrol_var(count)]= min(Y3(:,count))
            Y3_density(i_row,count)=  (Y3(i_row,count).*(10^3))./(1.*Wap.*(10^-3)); %mA/mm Divide I by two source widths
    end
        if X_Var_step > 0 % for X limits
          
           X_max = max(Xmax_percontrol_var)
           Y1_max = max(Y1max_percontrol_var)
           Y2_min = min(Y2min_percontrol_var) % find highest Ig
           Y3_min = min(Y3min_percontrol_var) % find highest Is
           
          
            for i_column=1:1:size(X,2)
              
            %figure settings
                fig1= figure(i);
            %
                    set(gcf,'color','w');
                    box on;
                    Ax1=gca;
                    set(Ax1,'LineWidth',2)
                    set(Ax1,'XMinorTick','on')
                    set(Ax1,'YMinorTick','on')
                    set(Ax1,'YMinorTick','on')
            %        ylim('auto')
                    ylim([0 (Y1_max.*(10^3))./(1.*Wap.*(10^-3))])
            %         set(Ax1,'YLim',[0 Y1(iXmax_percontrol_var(i_column))])
            %         set(Ax1,'YTick',[0:20:100]) %mA
            %        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])

                    set(Ax1,'XLim',[0 X_max])
            %        set(Ax1, 'XTick', [0 2 4 6 8 10 12])
                    set(Ax1,'YColor', 'black')
                    
                    if strcmpi(X_Var_Name, 'VG')== 1
                        xlabelC = 'V_{GS} (V)'
                        control_label = 'V_{DS}'
                    elseif strcmpi(X_Var_Name, 'VDS') == 1     
                        xlabelC = 'V_{DS} (V)'
                        control_label = 'V_{GS}'
                    end
                    
                    ylabelC = ['I_{D}, I_{S} (mA/mm)'];
                    ylabel(get(Ax1,'Ylabel'),'String',ylabelC,'FontSize',25,'FontName','Times New Roman') 
                    xlabel(xlabelC,'FontSize',25,'FontName','Times New Roman') 
                    set(Ax1,'fontsize',25,'FontName','Times New Roman')
            %        Legend_eachC= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
                    
                    TitleStr1=[sample_info{1,2},' (',sample_info{1,4},'-InAlAs/InGaAs/',sample_info{1,9},') ',sample_info{1,5},' ', sample_info{1,8},' ',': L_{AP} = ', num2str(Lap),' ',char(0181),'m, L_{GO}= ',num2str(Lgo),' ',char(0181),'m, L_{GA}= ',num2str(Lga),' ',char(0181),'m, W =  ', num2str(Wap),' ',char(0181),'m ', control_label,' = ', num2str(Control_Var_Start), ' V to ', num2str(Control_Var_End), ' V in steps of ', num2str(control_Var_step), ' V']
                    %set(TitleStr1,'interpreter','tex') 
                    title(TitleStr1, 'Units', 'normalized', ...
                         'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman', 'interpreter','tex')       
                  %Ends - figure settings
                  
                  hold on; 
                  p1=plot(X(1:iXmax_percontrol_var(i_column),i_column),Y1_density(1:iXmax_percontrol_var(i_column),i_column),PlotLineSpec{1},'LineWidth',3);  
                  p2=plot(X(1:iXmax_percontrol_var(i_column),i_column),abs(Y3_density(1:iXmax_percontrol_var(i_column),i_column)),PlotLineSpec{2},'LineWidth',1.5);  
 %                 p3=plot(X(1:iXmax_percontrol_var(i_column),i_column),abs(Y2_density(1:iXmax_percontrol_var(i_column),i_column)),PlotLineSpec{3},'LineWidth',1);  
                  hold on;
            %       %check if Id+Is+Ig =0%
            %       dI(1:iVdmaxperVg(i_column),i_column) = Y1(1:iVdmaxperVg(i_column),i_column)+ Y3(1:iVdmaxperVg(i_column),i_column)+ Ig(1:iVdmaxperVg(i_column),i_column)
            %       dI_max = max(dI)
            %       dI_min = min(dI)
                  %%


                  
                  %Legend_name1{3}='I_{G}'
                   

              end
% %+++++++++++++++++ Fit I-VD for Vg=0 to -1V +++++++++++++++++++++++++++  
  %get Ron, turn-on voltage, output conductance
    for i_column2=1:1:2  % for Vg of 0V and -1 V  
        z5=1
        
        % Fit for low Vds to get Vturn-on
        i_X_start1{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 0.05)));  % 0.25index when Vd > 1.5V
        i_X_end1{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 0.4))); % 0.85index when Vd > 2V
        fitY3X1{i_column2} = polyfit(X(i_X_start1{i_column2}:i_X_end1{i_column2},i_column2),abs(Y3_density(i_X_start1{i_column2}:i_X_end1{i_column2},i_column2)),1);
        x_fit1= -0.25:0.2:0.75;
        y_fit1 = fitY3X1{i_column2}(2)+x_fit1*fitY3X1{i_column2}(1); %making a line to get 
        V_turnon1(i_column2)= -1.*(fitY3X1{i_column2}(2)/fitY3X1{i_column2}(1));
        hold on;
        p4=plot(x_fit1,y_fit1,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        
        % Ends - Fit for mid Vds to get Vturn-on2
        i_X_start2{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 0.0))); % 2index when Vd > 1.5V
        i_X_end2{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 1.15))); % 3.4index when Vd > 2V
        fitY3X2{i_column2} = polyfit(X(i_X_start2{i_column2}:i_X_end2{i_column2},i_column2),abs(Y3_density(i_X_start2{i_column2}:i_X_end2{i_column2},i_column2)),1);
        x_fit2= -1:0.2:2.4;
        y_fit2 = fitY3X2{i_column2}(2)+x_fit2*fitY3X2{i_column2}(1); %making a line to get 
         V_turnon2(i_column2)= -1.*(fitY3X2{i_column2}(2)/fitY3X2{i_column2}(1));
         R_on(i_column2) = (1./fitY3X2{i_column2}(1)).*(10^3) %in Ohm-mm
        hold on;
        p5=plot(x_fit2,y_fit2,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        % Ends - Fit for mid Vds to get Vturn-on2
        
        % Fit for saturated I-V to get Vdsat and output-conductance
        i_X_start3{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 2.4))); % 6index when Vd > 1.5V
        i_X_end3{i_column2} = min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > 2.9))); % 6.99index when Vd > 2V
        fitY3X3{i_column2} = polyfit(X(i_X_start3{i_column2}:i_X_end3{i_column2},i_column2),abs(Y3_density(i_X_start3{i_column2}:i_X_end3{i_column2},i_column2)),1);
        x_fit3= 1.5:0.2:3;
        y_fit3 = fitY3X3{i_column2}(2)+x_fit3*fitY3X3{i_column2}(1); %making a line to get 
     
        G_out(i_column2) = (fitY3X3{i_column2}(1)) %in mS/mm
        hold on;
        p6=plot(x_fit3,y_fit3,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        Vds_sat(i_column2) = fzero(@(x) polyval(fitY3X2{i_column2}-fitY3X3{i_column2},x),4);
        if Vds_sat(i_column2)<Xmax_percontrol_var(i_column2)
            index_Vds_sat(i_column2) = (min(find((X(1:iXmax_percontrol_var(i_column2),i_column2) > Vds_sat(i_column2))))); 
            Jd_max (i_column2) = Y1_density(index_Vds_sat(i_column2),i_column2);
        end
        hold on;
        % Ends - Fit for saturated I-V to get Vdsat and output-conductance
       
    end
    
%+++++++++++++++++ Fit I-VD for Vg=-2V +++++++++++++++++++++++++++
      % Vdsat, Ron and Gout Fit for Vgs = -2 V
        % Fit for low Vds to get Vturn-on
        i_X_start1{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 0.05))); % 0.4index when Vd > 1.5V
        i_X_end1{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 0.4))); % 2.2index when Vd > 2V
        fitY3X1{3} = polyfit(X(i_X_start1{3}:i_X_end1{3},3),abs(Y3_density(i_X_start1{3}:i_X_end1{3},3)),1);
        x_fit10= -0.25:0.2:0.75;
        y_fit10 = fitY3X1{3}(2)+x_fit10*fitY3X1{3}(1); %making a line to get 
        V_turnon1(3)= -1.*(fitY3X1{3}(2)/fitY3X1{3}(1));
        hold on;
        p12=plot(x_fit10,y_fit10,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        
        i_X_start2{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 0.0))); % 6 or 7.5 index when Vd > 1.5V
        i_X_end2{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 0.7))); % 9.5 or 10index when Vd > 2V
        fitY3X2{3} = polyfit(X(i_X_start2{3}:i_X_end2{3},3),abs(Y3_density(i_X_start2{3}:i_X_end2{3},3)),1);
        x_fit8= -1:0.2:2;
        y_fit8 = fitY3X2{3}(2)+x_fit8*fitY3X2{3}(1); %making a line to get 
         V_turnon2(3)= -1.*(fitY3X2{3}(2)/fitY3X2{3}(1));
         R_on(3) = (1./fitY3X2{3}(1)).*(10^3) %in Ohm-mm
        hold on;
        p10=plot(x_fit8,y_fit8,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
    
        i_X_start3{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 2))); % 10.5index when Vd > 1.5V
        i_X_end3{3} = min(find((X(1:iXmax_percontrol_var(3),3) > 2.9))); % 11.9index when Vd > 2V
        fitY3X3{3} = polyfit(X(i_X_start3{3}:i_X_end3{3},3),abs(Y3_density(i_X_start3{3}:i_X_end3{3},3)),1);
        x_fit9= 1.2:0.2:3;
        y_fit9 = fitY3X3{3}(2)+x_fit9*fitY3X3{3}(1); %making a line to get 
        G_out(3) = (fitY3X3{3}(1)) %in mS/mm
        hold on;
        p11=plot(x_fit9,y_fit9,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        Vds_sat(3) = fzero(@(x) polyval(fitY3X2{3}-fitY3X3{3},x),4);
        index_Vds_sat(3) = (min(find((X(1:iXmax_percontrol_var(3),3) > Vds_sat(3))))); 
        Jd_max (3) = Y1_density(index_Vds_sat(3),3);
        hold on;   
        
      %Ends Vdsat, Ron and Gout Fit for Vgs = -2 V  
    
    
    % Fit for I-Vd when Vg=-5 V 
 
        z5=1
              
        % Fit for saturated I-V to get Vdsat and output-conductance
        i_X_start7{6} = min(find((X(1:iXmax_percontrol_var(6),6) > 1.5))); % 1.5index when Vd > 1.5V
        i_X_end7{6} = min(find((X(1:iXmax_percontrol_var(6),6) > 2.8))); % 2.8index when Vd > 2V
        fitY3X7{6} = polyfit(X(i_X_start7{6}:i_X_end7{6},6),abs(Y3_density(i_X_start7{6}:i_X_end7{6},6)),1);
        x_fit7= 2:0.2:3;
        y_fit7 = fitY3X7{6}(2)+x_fit7*fitY3X7{6}(1); %making a line to get 
     
        G_out_off(6) = (fitY3X7{6}(1)) %in mS/mm
        hold on;
        p9=plot(x_fit7,y_fit7,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
        hold on;
        % Ends - Fit for saturated I-V to get Vdsat and output-conductance
       
    %end
    
    % Fit for I-Vd when Vg=-6, -5 V 
          
    PlotLegend1=legend([p1 p2 p4], {'I_{D}', 'I_{S}', 'Fit'})
    set(PlotLegend1,'YColor',[1 1 1],'XColor',[1 1 1],...
        'FontSize',22,'FontName','Times New Roman');

        else     
            X_min = min(Xmin_percontrol_var)
            Y1_max = max(Y1max_percontrol_var)
            Y2_min = min(Y2min_percontrol_var) % find highest Ig
            Y3_min = min(Y3min_percontrol_var) % find highest Is
            
            for i_column=1:1:size(X,2)
               
            %figure settings
                fig2= figure(i);
            %         title(TitleStr1, 'Units', 'normalized', ...
            %         'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman')
                    set(gcf,'color','w');
                    box on;
                    Ax2=gca;
                    set(Ax2,'LineWidth',2)
                    set(Ax2,'XMinorTick','on')
                    set(Ax2,'YMinorTick','on')
                    set(Ax2,'YMinorTick','on')
            %        ylim('auto')
                    ylim([0 (Y1_max.*(10^3))./(1.*Wap.*(10^-3))])
            %         set(Ax1,'YLim',[0 Y1(iXmax_percontrol_var(i_column))])
            %         set(Ax1,'YTick',[0:20:100]) %mA
            %        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])

                    set(Ax2,'XLim',[X_min 0])
            %        set(Ax1, 'XTick', [0 2 4 6 8 10 12])
                    set(Ax2,'YColor', 'black')
                    
                    if strcmpi(X_Var_Name, 'VG')== 1
                        xlabelC = 'V_{GS} (V)'
                        control_label = 'V_{DS}'
                    elseif strcmpi(X_Var_Name, 'VDS') == 1     
                        xlabelC = 'V_{DS} (V)'
                        control_label = 'V_{GS}'
                    end
                    ylabelC = ['I_{D}, I_{S} (mA/mm)'];
                    ylabel(get(Ax2,'Ylabel'),'String',ylabelC,'FontSize',25,'FontName','Times New Roman') 
                    xlabel(xlabelC,'FontSize',25,'FontName','Times New Roman') 
                    set(Ax2,'fontsize',25,'FontName','Times New Roman')
            %        Legend_eachC= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
                    TitleStr2=[sample_info{1,2},' (',sample_info{1,4},'-InAlAs/InGaAs/',sample_info{1,9},') ',sample_info{1,5},' ', sample_info{1,8},' ',': L_{AP} = ', num2str(Lap),' ',char(0181),'m, L_{GO}= ',num2str(Lgo),' ',char(0181),'m, L_{GA}= ',num2str(Lga),' ',char(0181),'m, W = ', num2str(Wap),' ',char(0181),'m ', control_label,' = ', num2str(Control_Var_Start), ' V to ', num2str(Control_Var_End), ' V in steps of ', num2str(control_Var_step), ' V']
                    %set(TitleStr1,'interpreter','tex') 
                    title(TitleStr2, 'Units', 'normalized', ...
                         'Position', [0.5 1.02],'FontSize',20,'FontName','Times New Roman', 'interpreter','tex')       
            %       
                  %Ends - figure settings
                  hold on; 
                  p1b=plot(X(1:iXmin_percontrol_var(i_column),i_column),Y1_density(1:iXmin_percontrol_var(i_column),i_column),PlotLineSpec{1},'LineWidth',3);  
                  p2b=plot(X(1:iXmin_percontrol_var(i_column),i_column),abs(Y3_density(1:iXmin_percontrol_var(i_column),i_column)),PlotLineSpec{2},'LineWidth',1.5);  
     %             p3b=plot(X(1:iXmin_percontrol_var(i_column),i_column),abs(Y2_density(1:iXmin_percontrol_var(i_column),i_column)),PlotLineSpec{3},'LineWidth',1);  
                  hold on;
            %       %check if Id+Is+Ig =0%
            %       dI(1:iVdmaxperVg(i_column),i_column) = Y1(1:iVdmaxperVg(i_column),i_column)+ Y3(1:iVdmaxperVg(i_column),i_column)+ Ig(1:iVdmaxperVg(i_column),i_column)
            %       dI_max = max(dI)
            %       dI_min = min(dI)
                  %%
%+++++++++++++++++ Fit I-Vg for Vd of 4,5,6V +++++++++++++++++++++++++++
                                
                  
                    for i_column3=1:1:3  % for Vd of 4,5,6V  
                    z6=1
                     % Fit for low Vgs to get Vth1
                    i_X_start4{i_column3} = min(find((X(1:iXmin_percontrol_var(i_column3),i_column3) < -4.5))); % % -3.3index when Vd > 1.5V
                    i_X_end4{i_column3} = min(find((X(1:iXmin_percontrol_var(i_column3),i_column3) < -5.3))); % -4.5index when Vd > 2V
                    fitY3X4{i_column3} = polyfit(X(i_X_start4{i_column3}:i_X_end4{i_column3},i_column3),abs(Y3_density(i_X_start4{i_column3}:i_X_end4{i_column3},i_column3)),1);
                    x_fit4= -2.:-0.2:-6;
                    y_fit4 = fitY3X4{i_column3}(2)+x_fit4*fitY3X4{i_column3}(1); %making a line to get 
                    V_th1(i_column3)= -1.*(fitY3X4{i_column3}(2)/fitY3X4{i_column3}(1));
                    hold on;
                    p6=plot(x_fit4,y_fit4,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);

                    % Ends - Fit for mid Vds to get Vturn-on2
                    i_X_start5{i_column3} = min(find((X(1:iXmin_percontrol_var(i_column3),i_column3) < -0.9))); % -0.8index when Vd > 1.5V
                    i_X_end5{i_column3} = min(find((X(1:iXmin_percontrol_var(i_column3),i_column3) < -2.1))); % -1.8index when Vd > 2V
                    fitY3X5{i_column3} = polyfit(X(i_X_start5{i_column3}:i_X_end5{i_column3},i_column3),abs(Y3_density(i_X_start5{i_column3}:i_X_end5{i_column3},i_column3)),1);
                    x_fit5= 0:-0.2:-6;
                    y_fit5 = fitY3X5{i_column3}(2)+x_fit5*fitY3X5{i_column3}(1); %making a line to get 
                     V_th2(i_column3)= -1.*(fitY3X5{i_column3}(2)/fitY3X5{i_column3}(1));
                     %gm(i_column3) = (1./fitY3X2{i_column3}(1)).*(10^3) %in Ohm-mm
                    hold on;
                    p7=plot(x_fit5,y_fit5,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
                    % Ends - Fit for mid Vds to get Vturn-on2
                    end
                    
%+++++++++++++++++ Fit low I-Vg for Vd of 4V +++++++++++++++++++++++++++                    
                    % Fit for I-Vg when low Vds (5-7V)
                    for i_column4=1:1:3  % for Vg of 4,5,6V  
                    z7=1
                     % Fit for low Vgs to get Vth1
                    i_X_start6{i_column4} = min(find((X(1:iXmin_percontrol_var(i_column4),i_column4) < -4.5)));  % -3.3index when Vd > 1.5V
                    i_X_end6{i_column4} = min(find((X(1:iXmin_percontrol_var(i_column4),i_column4) < -5.3))); % -4.5index when Vd > 2V
                    fitY3X6{i_column4} = polyfit(X(i_X_start6{i_column4}:i_X_end6{i_column4},i_column4),abs(Y3_density(i_X_start6{i_column4}:i_X_end6{i_column4},i_column4)),1);
                    x_fit6= -2.:-0.2:-6;
                    y_fit6 = fitY3X6{i_column4}(2)+x_fit6*fitY3X6{i_column4}(1); %making a line to get 
                    V_th1(i_column4)= -1.*(fitY3X6{i_column4}(2)/fitY3X6{i_column4}(1));
                    hold on;
                    p8=plot(x_fit6,y_fit6,'color',[0.5 0.5 0.5],'LineStyle','-.','LineWidth',2);
                    
                    end                                    
                    % Ends Fit for I-Vg when low Vds (5-7V)
                    PlotLegend2=legend([p1b p2b p6], {'I_{D}', 'I_{S}', 'Fit'})
                    set(PlotLegend2,'YColor',[1 1 1],'XColor',[1 1 1],...
                        'FontSize',22,'FontName','Times New Roman');
               
            end
    V_turnon1
    V_turnon2
    Vds_sat
    Jd_max
    R_on
    G_out
    G_out_off
    V_th1 
   % V_th1b
    V_th2
    
        end
    
% %
% 
% 

    
 end
    
    