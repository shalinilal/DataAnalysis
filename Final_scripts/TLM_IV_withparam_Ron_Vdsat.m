% Plot Ron of between TLM pads with InAlAs on top%
% 1)Will have to change the column index on line 59 and 60: for example Pad 1
% you need column 1 and 2, & for pad 3 you need columns 3 and 4
% 2) Might have to change the peak values on line 72 and 76, it increases
% as pad spacing increases
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
% FileName_1 = 'R35_T1S1';
FigureStr = 'B58 R3C5 TLM-T1 - Plot R-V for all TLM pads with p InAlAs';
FileName_2 = {'S1', 'S2','S3','S4','S5', 'S6','S7','S8'};
Spacing = [5, 8, 11, 14, 17, 20, 23, 26]; %in um%
PlotLineSpec = {'-k', '-b', '-g','-r','--k','--b','--g','--r'};
Width = 75 %in um%

     %input the directory where text files are located   
     wk_dir = input('Import Directory: ','s')
if isdir(wk_dir)
    if wk_dir(end) ~= '\'
    	wk_dir = strcat(wk_dir,'\');
    end
    files = dir(wk_dir);
else
    files(1) = wk_dir;
end


%  T2 = 'Bond 35: pInAlAs 53KeV';

 k=1; %column variable for plot data
 PlotData= cell(1000,16) %setting 16 columns so that I-V for each TLM i.e 2 columns/pad are read into it
for i=1:length(files)   
    if ~files(i).isdir && strcmpi(files(i).name(end-3:end), '.txt')
        %get the pad spacing from the file name   
        for i_spacing=1:size(Spacing,2)  % Loop through file name to find out the corresponding pad spacing
                if strcmp(FileName_2{i_spacing},files(i).name(7:8)) ==1
                      
                    PadInfo(i_spacing,1) = {[files(i).name(1:8)]};
                    PadInfo(i_spacing,2) = {[Spacing(i_spacing)]};
                    Area = ((Spacing(i_spacing)*Width*10^(-4))) %cm2 
                    PadSpacing = PadInfo{i_spacing,2};
%                  l1=i_spacing %storing location number of the device in V
          
                end   
        end
         %get the data for each  pad-spacing or each file
          FileName =   files(i).name;
          fprintf('Filename: %s\n', FileName);
          fprintf('Pad Spacing: %d\n', PadSpacing);
          FileData = read_mixed_csv(strcat(wk_dir,FileName),'\t'); %reading data from the file which includes header and measurements
          [nrows, ncols]=size(FileData)
          j_FileDataRow=5; %reading measured data from row 5 onwards of the filedata to exclude header info
               for i_PlotData=1:1:nrows-4 %read each filedata row into plotdata for each TLM pad or file
                  PlotData(i_PlotData,k) = {str2num((FileData{j_FileDataRow,2}))}; % Voltage%
                  PlotData(i_PlotData,k+1) = {str2num((FileData{j_FileDataRow,3}))}; % Current%
                  j_FileDataRow=j_FileDataRow+1; %next row from each filedata
                  
          end    
          k=k+2; %increment the column to take the data from the next pad or file
    end
    
 end  
%plot data for all TLMs%
TitleStr='B58: R-V (InGaAs-TLM-Pads with pInAlAs on the channel)';
m=1;

       fig1= figure(1);
       set(gcf,'color','w');
       box on;
       Ax1=gca;
       set(Ax1,'LineWidth',2)
       set(Ax1,'XMinorTick','on')
       set(Ax1,'YMinorTick','on')
       set(Ax1,'YMinorTick','on')
       set(Ax1,'YLim',[-20 6000])
       set(Ax1,'YTick',[0:1000:6000])
       set(Ax1,'XTick',[-3:1:3])
       set(Ax1,'YColor', 'black')
       ylabel('R (Ohms)','FontSize',25,'FontName','Calibri') 
       xlabel('V (V)','FontSize',25,'FontName','Calibri') 
       set(Ax1,'fontsize',25,'FontName','Calibri')
           
while m < (2*length(Spacing))
        V=cell2mat(PlotData(:,m));
        I=cell2mat(PlotData(:,m+1));
      
        s=(m+1)/2;
        LegendStr{s}=sprintf('%d%s',PadInfo{s,2}, ' \mum'); 
        [dV1,dR1] = Get_Ron(V,I) %call function to differentiate I-V and smooth the Ron vs V 
        hold on;
        PlotRV(s)=plot(dV1,dR1,PlotLineSpec{s},'LineWidth',2);
        m=m+2;
end
    PlotLegend=legend(PlotRV,LegendStr{:})
     set(PlotLegend,...
      'Position',[0.382043650793652 0.505673758865246 0.0863095238095238 0.385106382978723], 'FontSize',15,'FontName','Calibri');
       title(TitleStr, 'Units', 'normalized', ...
  'Position', [0.5 1.02])
%   print(fig1,'-depsc','-tiff','-r300',FigureStr);
