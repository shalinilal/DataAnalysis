function [x, y1, y2, z] = read4294a(fname, plot)
%Usage:  [V, C, G] = read4294a(fname);

switch nargin
    case 0
        clc;
        wkdir = input('Filename: ','s');
        if isdir(wkdir)
            fname = input('Filename: ','s');
            fname = strcat(wkdir,'\',fname); 
        else
            fname = wkdir;
        end
        plot = 1;
    case 1
        plot = 0;
end

%read header
fid = fopen(fname);
while feof(fid)==0
    a = fgetl(fid);
    if length(a) > 10 && strcmp(a(2:10),'OSC FREQ:')
        switch a(end-3:end-1)
            case 'MHz'
                z = sscanf(a(12:end-5),'%f')*1e6;
            case 'KHz'
                z = sscanf(a(12:end-5),'%f')*1e3;
            case ' Hz'
                z = sscanf(a(12:end-4),'%f');
        end
    end
    if length(a) > 12 && strcmp(a(2:12),'SWEEP TYPE:')
        xl = a(14:end-1);
        switch xl
            case 'LIST FREQ'
                segment = 1;plotlog = 1;
            case 'LOG FREQ'
                segment = 0;plotlog = 1;
            case {'DC BIAS VOLT','OSC VOLT'}
                segment = 0;plotlog = 0;
        end
    end
    if length(a) > 18 && strcmp(a(2:18),'NUMBER of POINTS:')
        nop = sscanf(a(20:end-1),'%d');
    end
    if length(a) > 7 && strcmp(a(2:7),'TRACE:')
        break;
    end
end
fgetl(fid);
fgetl(fid);
if  segment > 0
    %segments
    a = fgetl(fid);
    while length(a) > 0
        n = sscanf(a(18:end-1),'%d');%strcmp(a(2:16), 'SEGMENT NUMBER:')
        a = fgetl(fid);
        nop = sscanf(a(20:end-1),'%d');%strcmp(a(2:18),'NUMBER of POINTS:')
        fgetl(fid);%OSC LEVEL
        a = fgetl(fid);
        z(n) = sscanf(a(11:end-5),'%f');%strcmp(a(2:9),'DC BIAS:')
        fgetl(fid);%BW
        fgetl(fid);%POINT AVERAGING
        fgetl(fid);%-Empty-
        fgetl(fid);%Header
        
        a = fscanf(fid,'%f %f %*f',[2, nop]);  
        x(:,n)  = a(1,:)';
        y1(:,n) = a(2,:)';
        
        if(a(1,1) == a(1,2))
            x(:,n) = ones(length(a(1,:)),1);
        end
        
        fgetl(fid);fgetl(fid);
        a = fgetl(fid);
    end
    fgetl(fid);fgetl(fid);fgetl(fid);
    while feof(fid)==0
        a = fgetl(fid);
        n = sscanf(a(18:end-1),'%d');%strcmp(a(2:16), 'SEGMENT NUMBER:')
        a = fgetl(fid);
        nop = sscanf(a(20:end-1),'%d');%strcmp(a(2:18),'NUMBER of POINTS:')
        fgetl(fid);%OSC LEVEL
        fgetl(fid);%DC BIAS
        fgetl(fid);%BW
        fgetl(fid);%POINT AVERAGING
        fgetl(fid);%-Empty-
        fgetl(fid);%Header
        
        y2(:,n) = fscanf(fid,'%*f %f %*f',nop);  
        fgetl(fid);fgetl(fid);
    end
    if plot > 0
        if plotlog > 0
            h=plot3(x,ones(1,max(length(x)))'*z,y1);view(0,0);xlabel(xl);
            %setoptions(h,'XScale','log');
            figure
            h=plot3(x,ones(1,max(length(x)))'*z,y2);view(0,0);xlabel(xl);
            %setoptions(h,'XScale','log');
        else
            plot3(x,ones(1,max(length(x)))'*z,y1);view(0,0);xlabel(xl);
            figure
            plot3(x,ones(1,max(length(x)))'*z,y2);view(0,0);xlabel(xl);
        end
    end
else    
    %loop through traces
    fgetl(fid);%Header
    a = fscanf(fid,'%f %f %*f',[2, nop]); 
    x = a(1,:)';
    y1 = a(2,:)';
    for i= 1:7
        fgetl(fid);
    end
    y2 = fscanf(fid,'%*f %f %*f',nop);

    [Coxuv,j] = max(y1);
    if x(j) > x(round(end/2))
        x = -x;
    end
    
    if plot > 0
        if plotlog > 0
            plotyy(x,y1,x,y2,'semilogx');xlabel(xl);
        else
            plotyy(x,y1,x,y2);xlabel(xl);
        end
    end
end
fclose(fid);

