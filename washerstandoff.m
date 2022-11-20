classdef washerstandoff
    %washer/standoff object
    properties
        ID
        OD
        H
    end
    
    methods
        function outputDimensions(obj, type)
            %type 1 is link spring standoff
            %type 2 is interlink standoff
            %type 3 is link spring washer
            
            if(type == 1)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/link_spring_standoff.txt','w');
                fprintf(fileID,'"ID"=%.6f\n', obj.ID);
                fprintf(fileID,'"OD"=%.6f\n', obj.OD);
                fprintf(fileID,'"H"=%.6f\n', obj.H);
                fclose(fileID); 
                
                
            elseif(type == 2)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/inter_link_standoff.txt','w');
                fprintf(fileID,'"ID"=%.6f\n', obj.ID);
                fprintf(fileID,'"OD"=%.6f\n', obj.OD);
                fprintf(fileID,'"H"=%.6f\n', obj.H);
                fclose(fileID); 
                
            
            else
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/link_spring_washer.txt','w');
                fprintf(fileID,'"ID"=%.6f\n', obj.ID);
                fprintf(fileID,'"OD"=%.6f\n', obj.OD);
                fprintf(fileID,'"H"=%.6f\n', obj.H);
                fclose(fileID); 
                
                
            end     
            
        end
    end
end
