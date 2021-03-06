% Plot same diode from different samples 
% Plot I-V of S-D/G-D/G-S diodes%
endq=1.6*(10^-19); %Coulomb
ep=13.1*8.85*(10^-14); %F/cm
% FileName_1 = 'R35_T1S1';
% FigureStr = 'B61 R3C4 TLM-T4 - Plot I-V for all TLM pads without p InAlAs';

PlotLineSpec = {'-k', '-b', '-g','-r','--k','--b','--g','--r'};
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
clear Ap_Area Gt_Width Gt_Area Ms_Width Ms_Area PlotData FileData

     wk_dir = input('Import Directory: ','s');
     wk_dir = strcat(wk_dir,'\')
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
    

iVd=1;

clear Vd Id Ig Is iVg i_column i_plot p1 i_data count  Vg_old  Vg_new

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
            
            Id(i_row,count)=  PlotData(i_data,2);
            
            Ig(i_row,count)=  PlotData(i_data,4);
           
            Is(i_row,count)=  -1*(Id(i_row,count) + Ig(i_row,count));
            
    end
           
end 



  for i_column=1:1:size(Vd,2)
      p1=plot(Vd(:,i_column),Id(:,i_column),'LineWidth',2,'Color','k');  
  end 
   
   
   
   
   