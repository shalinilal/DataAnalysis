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
clear Ap_Area Gt_Width Gt_Area Ms_Width Ms_Area

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
    
    PlotData(:,1) = FileData(6:nrows,2); %Vds
    PlotData(:,2) = FileData(6:nrows,3); %Id
    PlotData(:,3) = FileData(6:nrows,4); %Vgs
    PlotData(:,4) = FileData(6:nrows,5); %Ig
    size(PlotData)
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
    
%     for i_PlotData=6:1:nrows %read each filedata row into plotdata for each TLM pad or file
%                        PlotData(i_PlotData,1) = (FileData{i_PlotData,1}(1)); % Voltage%
% %                       PlotData(i_PlotData,k+1) = CV{i_PlotData,1}(2); % Current%
%                       PlotData(i_PlotData,k+2) = GV{i_PlotData,1}(2);
% %                     j_FileDataRow=j_FileDataRow+1; %next row from each filedata
% %                   
%                  end 
iVd=1;


if Vg_step < 0
  for iVg=Vg_max:Vg_step:Vg_min 
      z=1
    for i=1:1:size(PlotData) 
        z=2
         if str2double(PlotData(i,3))==iVg 
             z=3
            VdVg(iVd,1) = iVg
            VdVg(iVd,2)=  str2double(PlotData(i,1))
            
            IdVg(iVd,1) = iVg
            IdVg(iVd,2)=  str2double(PlotData(i,2))
            
            IgVg(iVd,1) = iVg
            IgVg(iVd,2)=  str2double(PlotData(i,4))
            
            IsVg(iVd,1) = iVg
            IsVg(iVd,2)=  -1*(Id(iVd,2) + Ig(iVd,2))
            
            iVd=iVd+1;   
         end
    end
  end    
end 
  p1=plot(VdVg(:,2),IdVg(:,2),'LineWidth',4,'Color','k');  
