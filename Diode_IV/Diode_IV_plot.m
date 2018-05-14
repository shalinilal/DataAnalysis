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
 PlotData= cell(1000,(2*no_of_files)); %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
 i_padinfo=1;
 k=1;
 clear i l;
 clear i_f;
 clear sample_info;
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
       
    files = dir(wk_dir{i})
    l=length(files)
       for i_f=1:length(files)
           z=1
            if ~files(i_f).isdir && strcmpi(files(i_f).name, filename1)
                z=2
                filename=files(i_f).name
                filename =   strcat(w,filename)
         
         
                FileData = read_mixed_csv(filename,'\t'); %reading data from the file which includes header and measurements
                [nrows, ncols]=size(FileData)
          
                j_FileDataRow=5; %reading measured data from row 5 onwards of the filedata to exclude header info
                for i_PlotData=1:1:nrows-4 %read each filedata row into plotdata for each TLM pad or file
                    PlotData(i_PlotData,k) = {str2num((FileData{j_FileDataRow,2}))}; % Voltage%
                    PlotData(i_PlotData,k+1) = {str2num((FileData{j_FileDataRow,3}))}; % Current%
                    j_FileDataRow=j_FileDataRow+1; %next row from each filedata
                  
                end                                 

            end
                       

        end
          k=k+2;
          i=i+1;
    end
    
 

TitleStrI=[sample_info{1,7},' of ',sample_info{1,8},' diodes with p, pi, i doped InAlAs']   ;


m=1;
[V_maxlim V_maxlim_i] = max(cell2mat(PlotData(:,1)))
[I_max I_max_i]=max(cell2mat(PlotData(:,2)))
I_maxlim = (I_max)./Ap_Area %A/cm-2
[V_minlim V_minlim_i] = min(cell2mat(PlotData(:,1)))
[I_min I_min_i]=min(cell2mat(PlotData(:,2)))
I_minlim = I_min*(10^3)./Ap_Area  %A/cm-2
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
% y=length(PadInfo)
while m <= (2*no_of_files)   
       
        V=cell2mat(PlotData(:,m));
        [Vmin iVmin] = min(V)
        if iVmin == length(V)
            V= -1.*V %changing sign of the voltages so that when differentiating cinv2 with V , we do not get negative numbers of N
        end
        I=(cell2mat(PlotData(:,m+1))/(Ap_Area));
         %Plot I-V
        fig1= figure(1);
        set(gcf,'color','w');
        box on;
        Ax1=gca;
        Legend_each= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
        LegendStrI{x}=sprintf('%s',Legend_each ) 
        PlotLinesI(x)=plot(V,I,PlotLineSpec{x},'LineWidth',2);
        title(TitleStrI, 'Units', 'normalized', ...
            'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
        set(Ax1,'LineWidth',2)
        set(Ax1,'XMinorTick','on')
        set(Ax1,'YMinorTick','on')
        set(Ax1,'YMinorTick','on')
%         ylim('auto')
        ylim([-10 10])
%        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])
        set(Ax1,'XLim',[-1.5 5])
        set(Ax1,'YColor', 'black')
        ylabel('I (Acm^{-2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax1,'fontsize',25,'FontName','Times New Roman')
        hold on;
        %ends Plot I-V
        
        
        fig2= figure(2);
        set(gcf,'color','w');
        box on;
        Ax2=gca;
        Legend_eachlogI= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
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
        set(Ax2,'XLim',[-1.5 5])
        set(Ax2,'YColor', 'black')
        ylabel('I (Acm^{-2})','FontSize',25,'FontName','Times New Roman') 
        xlabel('V_{SG} (V)','FontSize',25,'FontName','Times New Roman') 
        set(Ax2,'fontsize',25,'FontName','Times New Roman')
        hold on;    
        
        m=m+2;
       x=x+1
   
end
 
  PlotLegend=legend(PlotLinesI,LegendStrI{:})
   PlotLegend2=legend(PlotLineslogI,LegendStrlogI{:})
      set(PlotLegend,'YColor',[1 1 1],'XColor',[1 1 1],...
            'FontSize',18,'FontName','Times New Roman');
        set(PlotLegend2,'YColor',[1 1 1],'XColor',[1 1 1],...
           'FontSize',18,'FontName','Times New Roman');
