function []=setupPartFiles(part,type)
%NEWPHONE WHODIS
%change filepath before submitting
filePath='C:\Users\rohan\University of Ottawa\Amit Nayak - MCG4322B Group 03\Solidworks\Equations';

fileName=strcat(filePath,'\',part.file)

fid = fopen(fileName,'w');

if (type=="S" || type=="In")
    fprintf(fid,strcat('"B1"=',num2str(part.B1),'\n'));
    fprintf(fid,strcat('"B2"=',num2str(part.B2),'\n'));
    fprintf(fid,strcat('"B3"=',num2str(part.B3),'\n'));
    fprintf(fid,strcat('"H1"=',num2str(part.H1),'\n'));
    fprintf(fid,strcat('"H2"=',num2str(part.H2),'\n'));
    fprintf(fid,strcat('"H3"=',num2str(part.H3),'\n'));
    fprintf(fid,strcat('"H4"=',num2str(part.H4),'\n'));
    fprintf(fid,strcat('"T"=',num2str(part.T),'\n'));
    fprintf(fid,strcat('"L"=',num2str(part.L),'\n'));
    fprintf(fid,strcat('"B1"=',num2str(part.B1),'\n'));
    fprintf(fid,strcat('"bolt_hole_diameter"=',num2str(part.bolt_hole_diam),'\n'));

    
elseif (type=="A" || type=="P")
    fprintf(fid,strcat('"L"=',num2str(part.L),'\n'));
    fprintf(fid,strcat('"H"=',num2str(part.H),'\n'));
    fprintf(fid,strcat('"B"=',num2str(part.B),'\n'));
    fprintf(fid,strcat('"T"=',num2str(part.T),'\n'));
    fprintf(fid,strcat('"bolt_hole_diameter"=',num2str(part.bolt_hole_diam),'\n'));
    
end

fclose(fid);



