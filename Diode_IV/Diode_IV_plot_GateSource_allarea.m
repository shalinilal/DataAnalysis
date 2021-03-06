% Plot same diode from different samples 
% Plot I-V of S-D/G-D/G-S diodes%
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
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

% no_of_files = str2num(input('Number of files in same directory ','s'))    

clear wk_dir;
clear files;
clear i_dir;
i_dir=1;
clear Ap_Area Gt_Width Gt_Area Ms_Width Ms_Area

     wk_dir = input('Import Directory: ','s');
     wk_dir = strcat(wk_dir,'\')
 
 
 
%  i_file = 1;
%       files = dir(fullfile('wk_dir{1}', 'wk_dir{2}', 'wk_dir{3}', 'R34_SD3.txt'))    
%  for i_file = 1:no_of_files 
%      filename1(i_file,:) = input('Input file name: ','s');       
%         for i_devlookup = 1:length(DevLookup)
%             if strcmpi(DevLookup(i_devlookup,1), filename1(i_file,1:end-4));
%                 Ap_Width(i_file) = str2num(DevLookup{i_devlookup,2}); %in um
%                 Ap_Area(i_file) = (str2num(DevLookup{i_devlookup,2}).* 10^(-4)).^2; % cm2
%                 Gt_Width(i_file) = str2num(DevLookup{i_devlookup,3}); %in um
%                 Gt_Area(i_file) = (str2num(DevLookup{i_devlookup,3}).* 10^(-4)).^2; % cm2
%                 Ms_Width(i_file) = str2num(DevLookup{i_devlookup,4}); % in um
%                 Ms_Area(i_file) = (str2num(DevLookup{i_devlookup,4}).* 10^(-4)).^2; % cm2
%             end
%         end
%  end

 

  
 
  i_padinfo=1;
  k=1;
  clear i l;
  clear i_f;
  clear sample_info;
    clear filename;
     clear FileData;
     clear files;
 
     w=wk_dir
        
     i_slashes = strfind(wk_dir,filesep())
     sample_info{1} = wk_dir((i_slashes(5)+1):(i_slashes(6)-1))    %sample name
    
     index_sampleinfo = strfind(sample_info{1},'_')
     sample_info{2} = sample_info{1}(1:index_sampleinfo(1)-1)     %sample number
     sample_info{3}= sample_info{1}(index_sampleinfo(1)+1:index_sampleinfo(2)-1) %structure info whether p or pi or i InAlAs      
     sample_info{4} = sample_info{1}(index_sampleinfo(2)+1:index_sampleinfo(3)-1) %structure info whether InGaN or GaN didoes
     index_dopinginfo = strfind(sample_info{1},'InAlAs')  
     sample_info{5}= sample_info{1}(index_sampleinfo(1)+1:index_dopinginfo(1)-1) %doping in InAlAs
    
    sample_info{6} = wk_dir((i_slashes(6)+1):(i_slashes(7)-1))     %die number
    sample_info{7} = wk_dir((i_slashes(8)+1):(i_slashes(9)-1))     % measurement technique 
    sample_info{8} = wk_dir((i_slashes(9)+1):(i_slashes(10)-1))     % Which diode : G-D or S-D or G-S
       
    files = dir(wk_dir)
    l=length(files)
     PlotData= cell(1000,2); %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
       i_txtfile=1
       for i_f=1:length(files)
        
        
%            [dir_content{i_f}(1,1:3)]
             files(i_f).name
%             filename{end-4:end}
              if ~files(i_f).isdir && length(strfind(files(i_f).name, '.TXT')) > 0
                
                 filename= files(i_f).name
                 filename(1:end-4)
                 for i_devlookup = 1:length(DevLookup)
                    if strcmpi(DevLookup(i_devlookup,1), filename(1:end-4));
                        Ap_Width(i_txtfile) = str2num(DevLookup{i_devlookup,2}); %in um
                        Ap_Area(i_txtfile) = (str2num(DevLookup{i_devlookup,2}).* 10^(-4)).^2; % cm2
                        Gt_Width(i_txtfile) = str2num(DevLookup{i_devlookup,3}); %in um
                        Gt_Area(i_txtfile) = (str2num(DevLookup{i_devlookup,3}).* 10^(-4)).^2; % cm2
                        Ms_Width(i_txtfile) = str2num(DevLookup{i_devlookup,4}); % in um
                        Ms_Area(i_txtfile) = (str2num(DevLookup{i_devlookup,4}).* 10^(-4)).^2; % cm2
                    end
                end
                filenamedir =  strcat(w,filename)
                diode_name{i_txtfile} = filename(1:end-4)
                 diode_name= diode_name(:)
          
                 FileData = read_mixed_csv(filenamedir,'\t'); %reading data from the file which includes header and measurements
                [nrows, ncols]=size(FileData)
          
                j_FileDataRow=5; %reading measured data from row 5 onwards of the filedata to exclude header info
                for i_PlotData=1:1:nrows-4 %read each filedata row into plotdata for each TLM pad or file
                    PlotData(i_PlotData,k) = {str2num((FileData{j_FileDataRow,2}))}; % Voltage%
                    PlotData(i_PlotData,k+1) = {str2num((FileData{j_FileDataRow,3}))}; % Current%
                    j_FileDataRow=j_FileDataRow+1; %next row from each filedata
                  
                end                                 
                i_txtfile=i_txtfile+1
                k=k+2;
              end                   

        end
         
   
%     
%  
% 
TitleStrI=[sample_info{1,8},' of ',sample_info{1,3},' with different area']   ;


m=1;
[V_maxlim V_maxlim_i] = max(cell2mat(PlotData(:,1)))
[I_max I_max_i]=max(cell2mat(PlotData(:,2)))
I_maxlim = (I_max)./Gt_Area %A/cm-2
[V_minlim V_minlim_i] = min(cell2mat(PlotData(:,1)))
[I_min I_min_i]=min(cell2mat(PlotData(:,2)))
I_minlim = I_min*(10^3)./Gt_Area  %A/cm-2
% if max(cell2mat(PlotData(:,2)))> abs(min(cell2mat(PlotData(:,1))))
%     I_minlim = -1*(I_maxlim);
% else 
%     I_maxlim = -1*(I_minlim);
% end
% I_step=10;
       
      

       clear PlotLinesI PlotLineslogI;
       clear LegendStrI LegendStrlogI;
clear x;
x=1;
  while m <= (2*length(Ms_Width)) %length(Ms_width) is just an indicator of how many diodes are we reading
   
        V=cell2mat(PlotData(:,m));
         [Vmin iVmin] = min(V)
         if iVmin == length(V)
             V= -1.*V %changing sign of the voltages so that when differentiating cinv2 with V , we do not get negative numbers of N
         end
         I=(cell2mat(PlotData(:,m+1))/(Ms_Area(x)));
          %Plot I-V
         fig1= figure(1);
         set(gcf,'color','w');
         box on;
        Ax1=gca;
         Legend_each= [diode_name{x},' ',(sample_info{1,5}),'-InAlAs (' ,num2str((sample_info{1,2})),' ', num2str(sample_info{1,6}),')']
         LegendStrI{x}=sprintf('%s',Legend_each ) 
        PlotLinesI(x)=plot(V,I,PlotLineSpec{x},'LineWidth',2);
        title(TitleStrI, 'Units', 'normalized', ...
            'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(Ax1,'LineWidth',2)
        set(Ax1,'XMinorTick','on')
        set(Ax1,'YMinorTick','on')
        set(Ax1,'YMinorTick','on')
%         ylim('auto')
        ylim([-8 5])
        set(Ax1, 'YTick', [-5 -4 -3 -2 -1 0 1 2 3 4 5])
        set(Ax1,'XLim',[-1.5 6])
        set(Ax1, 'XTick', [-1 0 1 2 3 4 5 6])
        set(Ax1,'YColor', 'black')
        ylabel('I (Acm^{-2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{SG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
        hold on;
        %ends Plot I-V
        
%         
         fig2= figure(2);
         set(gcf,'color','w');
        box on;
        Ax2=gca;
        Legend_eachlogI= [diode_name{x},' ',(sample_info{1,5}),'-InAlAs (' ,num2str((sample_info{1,2})),' ', num2str(sample_info{1,6}),')']
        LegendStrlogI{x}=sprintf('%s',Legend_eachlogI ) 
        PlotLineslogI(x)=semilogy(V,abs(I),PlotLineSpec{x},'LineWidth',2);
        title(TitleStrI, 'Units', 'normalized', ...
            'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(Ax2,'LineWidth',2)
        set(Ax2,'XMinorTick','on')
        set(Ax2,'YMinorTick','on')
        set(Ax2,'YMinorTick','on')
%         ylim('auto')
        ylim([10.^-6 10.^1])
        set(Ax2, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])
        set(Ax2,'XLim',[-1.5 6])
        set(Ax2, 'XTick', [-1 0 1 2 3 4 5 6])
        set(Ax2,'YColor', 'black')
        ylabel('I (Acm^{-2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{SG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax2,'fontsize',25,'FontName','Times New Roman')
        hold on;    
%         
         m=m+2;
        x=x+1
%    
 end
 
  PlotLegend=legend(PlotLinesI,LegendStrI{:})
   PlotLegend2=legend(PlotLineslogI,LegendStrlogI{:})
      set(PlotLegend,'YColor',[1 1 1],'XColor',[1 1 1],...
            'FontSize',18,'FontName','Times New Roman');
        set(PlotLegend2,'YColor',[1 1 1],'XColor',[1 1 1],...
           'FontSize',18,'FontName','Times New Roman');
