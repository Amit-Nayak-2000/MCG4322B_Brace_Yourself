classdef Bolt < handle
    %BOLT
    %Contains essential properties of bolt.
    %Dimensions, Material Properties
    %ADD Length calc for solidworks param
    
    properties
        %Geometric Properties (m)
        L %Length of bolt
        D %Diameter of bolt     
        L_thread %MAKE SURE TO ADD THIS IN
        
        %Physical Properties
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa) 
    end
    
    methods
        %Method to intialize and diameter of bolt. 
        function obj = initBolt(obj, diameter)
            obj.D = diameter;
        end
        
        function outputDimensions(obj, type)
            %type 1 is link spring bolt
            %type 2 is inferior interlink bolt
            %type 3 is superior interlink bolt
            
            if(type == 1)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/link_spring_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0056);
                fprintf(fileID,'"L_head"=%.6f\n', 0.00165);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
                
            elseif(type == 2)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/inferior_inter_link_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
            
            else
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/superior_inter_link_bolt.txt','w');
                fprintf(fileID,'"diam_head"=%.6f\n', 0.0055);
                fprintf(fileID,'"L_head"=%.6f\n', 0.002);
                fprintf(fileID,'"L"=%.6f\n',obj.L);
                fprintf(fileID,'"L_thread"=%.6f\n',obj.L_thread);
                fprintf(fileID,'"diam_thread"=%.6f\n',obj.D);
                fprintf(fileID,'"pitch"=%.6f\n', 0.0005);
                fclose(fileID); 
                
                
            end
            
            
            
        end
         
    end
end