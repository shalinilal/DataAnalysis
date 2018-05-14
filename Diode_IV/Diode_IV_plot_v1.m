% Plot I-V of S-D/G-D/G-S diodes%
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
% FileName_1 = 'R35_T1S1';
FigureStr = 'B61 R3C4 TLM-T4 - Plot I-V for all TLM pads without p InAlAs';
FileName_2 = {'S1', 'S2','S3','S4','S5', 'S6','S7','S8'};
Spacing = [5, 8, 11, 14, 17, 20, 23, 26]; %in um%
PlotLineSpec = {'-k', '-b', '-g','-r','--k','--b','--g','--r'};
Width = 100 %in um - Mask Diodev2.1% 

no_of_files = str2num(input('Number of files in different directories ','s'))    

clear wk_dir;
clear files;
clear i_dir;
i_dir=1;

% no = str2num(no_of_files)
 for i_dir = 1:no_of_files
     i_dir
     wk_dir{i_dir,:} = input('Import Directory: ','s')
     
 end  
 wk_dir;
 length(wk_dir)
 i_file = 1;
%       files = dir(fullfile('wk_dir{1}', 'wk_dir{2}', 'wk_dir{3}', 'R34_SD3.txt'))    
 for i_wkdir = 1:length(wk_dir)
            wk_dir(i_wkdir) = strcat(wk_dir(i_wkdir),'\')
 end
 wk_dir
 
   filename = input('Input file name: ','s')
 %%%%%%%%%% sorting in a struct or files
%  
%   Ffields = fieldnames(files)
%   Fcell = struct2cell(files)
%   sz = size(Fcell) 
%  
%  % Convert to a matrix
% Fcell = reshape(Fcell, sz(1), [])      % Px(MxN)
% 
% % Make each field a column
% Fcell = Fcell'                       % (MxN)xP
% 
% % Sort by first field "name"
% Fcell = sortrows(Fcell, 1)
% Fcell = reshape(Fcell', sz);
% 
% % Convert to Struct
% Fsorted = cell2struct(Fcell, Ffields, 1);
% for id = 1:length(Fsorted)
%     fprintf('%d\n',id)
%     disp(Fsorted(id))
% end
 %%%%%%%%%%
 %column variable for plot data
 PlotData= cell(1000,(2*no_of_files)); %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
 i_padinfo=1;
 k=1;
 clear i;
 
 for i=1:length(wk_dir)   
 clear FileData;
     
      
% %         j_file=files(i).name(8)
% %         j_FileColumn = str2num(j_file)
% %         k=(2*j_FileColumn)-1
%         %get the pad spacing from the file name   
%           % Loop through file name to find out the corresponding pad spacing
%         
%           for i_findspacing =1:length(FileName_2)
%                 if FileName_2{i_findspacing} == files(i).name(7:8)                             
%                     PadInfo(i_padinfo,1) = {[files(i).name(1:8)]}      
%                     PadInfo(i_padinfo,2) = {[Spacing(i_findspacing)]}
%                     Area = ((Spacing(i_findspacing)*Width*10^(-4))) %cm2 
%                     PadSpacing = PadInfo{i_padinfo,2}
% %                  l1=i_spacing %storing location number of the device in V
%           
%                 end   
%         
         %get the data for each  pad-spacing or each file
          filename =   strcat(wk_dir{i},filename)
%           fprintf('Filename: %s\n', filename(:));
%           fprintf('Pad Spacing: %d\n', PadSpacing);
          FileData = read_mixed_csv(filename,'\t'); %reading data from the file which includes header and measurements
          [nrows, ncols]=size(FileData)
          
          j_FileDataRow=5; %reading measured data from row 5 onwards of the filedata to exclude header info
               for i_PlotData=1:1:nrows-4 %read each filedata row into plotdata for each TLM pad or file
                  PlotData(i_PlotData,k) = {str2num((FileData{j_FileDataRow,2}))}; % Voltage%
                  PlotData(i_PlotData,k+1) = {str2num((FileData{j_FileDataRow,3}))}; % Current%
                  j_FileDataRow=j_FileDataRow+1; %next row from each filedata
                  
                end    
          i_padinfo= i_padinfo+1; %increment the column to take the data from the next pad or file
          k=k+2;
fclose('all');
          i=i+1;
    end
    
 

% TitleStr1='B61 R3C4 - T4';
% TitleStr2 ='I-V (InGaAs-TLMs without p-InAlAs)';
% TitleStr = [TitleStr1,TitleStr2]
% m=1;
% [V_maxlim V_maxlim_i] = max(cell2mat(PlotData(:,1)))
% [I_max I_max_i]=max(cell2mat(PlotData(:,2)))
% I_maxlim = ceil(I_max*((10^3)/0.10)/100)*100
% [V_minlim V_minlim_i] = min(cell2mat(PlotData(:,1)))
% [I_min I_min_i]=min(cell2mat(PlotData(:,2)))
% I_minlim = ceil(I_min*((10^3/0.10))/100)*100
% if max(cell2mat(PlotData(:,2)))> abs(min(cell2mat(PlotData(:,1))))
%     I_minlim = -1*(I_maxlim);
% else 
%     I_maxlim = -1*(I_minlim);
% end
% I_step=(I_maxlim)/5;
%        fig1= figure(1);
%        set(gcf,'color','w');
% %        set(gcf,'PaperUnits','centimeters','PaperPosition', [10 5 150 150])
% %        set(gcf,'gridlinestyle',':')
%        box on;
%        Ax1=gca;
%        set(Ax1,'LineWidth',2)
%        set(Ax1,'XMinorTick','on')
%        set(Ax1,'YMinorTick','on')
%        set(Ax1,'YMinorTick','on')
%        set(Ax1,'YLim',[I_minlim I_maxlim]) %mA
%        set(Ax1,'XLim',[V_minlim V_maxlim])
%        set(Ax1,'YTick',[I_minlim:I_step:I_maxlim]) %mA
%        set(Ax1,'XTick',[V_minlim:1:V_maxlim])
%        set(Ax1,'YColor', 'black')
%        ylabel('I (mA/mm)','FontSize',25,'FontName','Times New Roman') 
%        xlabel('V (V)','FontSize',25,'FontName','Times New Roman') 
%        set(Ax1,'fontsize',25,'FontName','Times New Roman')
% 
%        clear PlotLines;
%        clear LegendStr;
% clear x;
% x=1;
% y=length(PadInfo)
% while m <= (2*length(PadInfo)) && x <= length(PadInfo)
%     
%         
%         V=cell2mat(PlotData(:,m));
%         I=cell2mat(PlotData(:,m+1))*((10^3)/0.1);
%      
%         
%         Legend_each= PadInfo{x,2}
%         LegendStr{x}=sprintf('%d%s',Legend_each, ' \mum') 
%       
%        
%         hold on;
%         PlotLines(x)=plot(V,I,PlotLineSpec{x},'LineWidth',2);
%     
%         m=m+2;
%        x=x+1
%    
% end
%  
%  PlotLegend=legend(PlotLines,LegendStr{:})
%       set(PlotLegend,'YColor',[1 1 1],'XColor',[1 1 1],...
%        'Position',[0.144317460317461 0.425120567375885 0.198666666666667 0.484510638297872], 'FontSize',15,'FontName','Times New Roman');
%       title(TitleStr, 'Units', 'normalized', ...
%  'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
