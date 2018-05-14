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
%  PlotData= cell(201,(2*no_of_files)); %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
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
          
            if ~files(i_f).isdir && strcmpi(files(i_f).name, filename1)
                
                filename=files(i_f).name
                filename =   strcat(w,filename)
%        %=====
%                 fid = fopen(filename,'r')   %# Open the file
%         lineArray = cell(1000,1)     %# Preallocate a cell array (ideally slightly
%                                %#   larger than is needed)
%         lineIndex = 1               %# Index of cell to place the next line in
%         nextLine = fgetl(fid)
%          while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
%              z(lineIndex)=1
%             lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
%             lineIndex = lineIndex+1;          %# Increment the line index
%             nextLine = fgetl(fid);            %# Read the next line from the file
%          end
%         fclose(fid);                 %# Close the file
%         lineArray = lineArray(1:lineIndex-1)  %# Remove empty cells, if needed
%        lineArray=regexp(lineArray,'\t|\n','split')
%       Data=reshape(C,length(lineArray),[])';
%       Data =Data(:)
%        Data(:,end)=deblank(Data(:,end));
  
   
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

TitleStr=[sample_info{1,7},' of ',sample_info{1,8},' diodes with p, pi, i doped InAlAs']   ;

% 
m=1;
[V_maxlim V_maxlim_i] = max(str2double(PlotData(:,1)))
[I_max I_max_i]=max(str2double(PlotData(:,2)))
I_maxlim = (I_max)./Ap_Area %A/cm-2
[V_minlim V_minlim_i] = min(str2double(PlotData(:,1)))
[I_min I_min_i]=min(str2double(PlotData(:,2)))
I_minlim = I_min*(10^3)./Ap_Area  %A/cm-2
I_step=10;
       fig1= figure(1);
       set(gcf,'color','w');
       box on;
       Ax1=gca;
       set(Ax1,'LineWidth',2)
       set(Ax1,'XMinorTick','on')
       set(Ax1,'YMinorTick','on')
       set(Ax1,'YMinorTick','on')
%         ylim('auto')
        ylim([1e-6 100])
%        set(Ax1,'YTick',[1e-6:100:100]) %mA
%        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])

       set(Ax1,'XLim',[V_minlim V_maxlim])
       set(Ax1,'YColor', 'black')
       ylabel('I (Acm^{-2})','FontSize',25,'FontName','Times New Roman') 
       xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
       set(Ax1,'fontsize',25,'FontName','Times New Roman')

       clear PlotLines;
       clear LegendStr;
clear x;
x=1;
% y=length(PadInfo)
while m <= (2*no_of_files)   
        set(Ax1,'LineWidth',2)
       set(Ax1,'XMinorTick','on')
       set(Ax1,'YMinorTick','on')
       set(Ax1,'YMinorTick','on')
         ylim('auto')
%        ylim([1e-6 100])
%        set(Ax1,'YTick',[1e-6:100:100]) %mA
%        set(Ax1, 'YTick', [10.^-6 10.^-5 10.^-4 10.^-3 10.^-2 10.^-1 10.^0 10.^1 10.^2])

       set(Ax1,'XLim',[V_minlim V_maxlim])
       set(Ax1,'YColor', 'black')
       ylabel('C (Fcm^{-2})','FontSize',25,'FontName','Times New Roman') 
       xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
       set(Ax1,'fontsize',25,'FontName','Times New Roman')
        V=str2double(PlotData(:,m));
        C=str2double(PlotData(:,m+1))/(Ap_Area);
        G=str2double(PlotData(:,m+2))/(Ap_Area);         
        
     
         Legend_each= [(sample_info{x,5}),'-InAlAs (' ,num2str((sample_info{x,2})),' ', num2str(sample_info{x,6}),'-',filename1(1:end-4),')']
         LegendStr{x}=sprintf('%s',Legend_each ) 
                
    
         hold on;
         PlotLines(x)=plot(V,C,PlotLineSpec{x},'LineWidth',2); 
         ylabel('C (Fcm^{-2})','FontSize',25,'FontName','Times New Roman') 
         xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman') 
         
          PlotLinesG(x)=plot(V,G,PlotLineSpec{x},'LineWidth',2);
           ylabel('G (Scm^{-2})','FontSize',25,'FontName','Times New Roman') 
         xlabel('V_{DG} (V)','FontSize',25,'FontName','Times New Roman')
         
%         PlotLines(x)=semilogy(V,abs(I),PlotLineSpec{x},'LineWidth',2);
            
       
        m=m+3;
       x=x+1
   
end
 
  PlotLegend=legend(PlotLines,LegendStr{:})
  PlotLegend2=legend(PlotLinesG,LegendStr{:})
%        set(PlotLegend,'YColor',[1 1 1],'XColor',[1 1 1],...
%          'FontSize',18,'FontName','Times New Roman');
%       set(PlotLegend2,'YColor',[1 1 1],'XColor',[1 1 1],...
%          'FontSize',18,'FontName','Times New Roman');
      title(TitleStr, 'Units', 'normalized', ...
 'Position', [0.5 1.02],'FontSize',25,'FontName','Times New Roman')
