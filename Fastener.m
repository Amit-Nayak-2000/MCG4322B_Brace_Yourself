classdef Fastener
    %F Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        height
        thread_height
    end
    
    methods
        function outputDimensions(obj, type)
            %type 1 is link spring locknut
            %type 2 is interlink locknut
            
            if(type == 1)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/locknut_link_spring.txt','w');
                fprintf(fileID,'"thread_height"=%.6f\n', obj.thread_height);
                fprintf(fileID,'"hex_base_diam"=%.6f\n', 0.0055);
                fprintf(fileID,'"hole_diam"=%.6f\n', 0.003);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            
            else
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/locknut_inter_link.txt','w');
                fprintf(fileID,'"height"=%.6f\n', obj.height);
                fprintf(fileID,'"thread_height"=%.6f\n', obj.thread_height);
                fprintf(fileID,'"hex_base_diam"=%.6f\n', 0.0055);
                fprintf(fileID,'"hole_diam"=%.6f\n', 0.003);
                fprintf(fileID,'"lock_diam"=%.6f\n', 0.00235);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
                
            end     
            
        end
    end
end

