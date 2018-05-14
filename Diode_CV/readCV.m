function [ lineArray ] = readCV( fileName)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

         fid = fopen(fileName,'r')   %# Open the file
        lineArray = cell(1000,1)     %# Preallocate a cell array (ideally slightly
                               %#   larger than is needed)
        lineIndex = 1               %# Index of cell to place the next line in
        nextLine = fgetl(fid)
         while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
             z(lineIndex)=1
            lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
            lineIndex = lineIndex+1;          %# Increment the line index
            nextLine = fgetl(fid);            %# Read the next line from the file
         end
        fclose(fid);                 %# Close the file
        lineArray = lineArray(1:lineIndex-1)  %# Remove empty cells, if needed
       lineArray=regexp(lineArray,'\t|\n','split')

end

