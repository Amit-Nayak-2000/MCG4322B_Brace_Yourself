classdef Bearing < handle
    %BEARING
    %Contains essential properties of bearing.
    %Dimensions, Material Properties
    
    
    properties
        %Geometric Properties (m)
        ID %Inner diameter.
        OD %Outer diameter.
        
        %Physical Properties
        LC %Load capacity of the bearing.
        C_10 %Catalogue load rating
        L_10 %Number of rev for 90% reliability
        L %Number of rev we want, 1 000 000 rev
        
    end
    
    methods
        %Method to intialize inner diameter and outer diameter of bearing. 
        function obj = initBearing(obj, innerdiameter, outerdiameter)
            obj.ID = innerdiameter; 
            obj.OD = outerdiameter;
        end
        
        %method to output dimensions to .txt files.
        function outputDimensions(obj)
            fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/ball_bearing.txt','w');
            fprintf(fileID,'"width"=%.6f\n', 0.003);
            fprintf(fileID,'"OD"=%.6f\n', 0.008);
            fprintf(fileID,'"ID"=%.6f\n', 0.003);
            fprintf(fileID,'"race_thickness"=%.6f\n', 0.00075);
            fprintf(fileID,'"D_ball"=%.6f\n', 0.0015);
            fprintf(fileID,'"num_balls"=%.6f\n', 10);
            fprintf(fileID,'"track_depth"=%.6f\n', 0.00025);
            
            
            fclose(fileID); 
        end
         
    end
    
end