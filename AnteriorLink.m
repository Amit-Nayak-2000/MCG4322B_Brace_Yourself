classdef AnteriorLink < handle
    %ANTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations,
    %and Forces. 
    
    
    properties
        %Geometric Properties (m)
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        T %thickness
        bolt_hole_diam
        
        
        %Physical Properties
        m % Mass (kg)
        rho = 2700; %Density of Aluminium 6061-T6 (kg/m^3)
        I % Moment of inertia (kg m^2)
        E = 68.9e9; % Elastic modulus of Aluminium 6061-T6 (Pa)
        SU = 310e6; %Ultimate Tensile Strength of Aluminium 6061-T6 (Pa)
        SY = 276e6; %Yield Strength of Aluminium 6061-T6 (Pa)
        G = 26e9; %Shear modulus of Aluminium 6061-T6 (Pa)
        
        
        %Dynamical Properties
        %Position vectors units are (m).
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %Vector from superior joint (SA) to centre of mass
        rsa = [0;0;0];
        %Vector from inferior joint (IA) to centre of mass
        ria = [0;0;0]; 
        theta %Angle with respect to horizontal-x (deg) 
        %omega and alpha initially set to 0, but will have values in k.
        omega  = [0;0;0]; %Angular Velocity (rad/s)
        alpha  = [0;0;0]; %Angular acceleration (rad/s^2)
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity (m/s)
        a = [0;0;0]; %Linear Acceleration (m/s^2)
        
        %Force Vectors
        F_sa = [0;0;0]; %(N)
        F_ia = [0;0;0]; %(N)
        
        %file names
        file
    end
    
    methods
        
        %Method to calculate mass and moment of inertia.
        function obj = calculate_inertial_props(obj)
            volume = obj.B * obj.H * obj.T;
            
            %density * volume.
            obj.m = obj.rho * volume;
            
            %moment of inertia of a thin bar.
            obj.I = (1/12)*obj.m*obj.H^2;
        end
        
        %Method to calculate vectors from joints to centre mass. 
        function obj = calculateCOM(obj)
            obj.rsa = [0.5*obj.L*cosd(obj.theta); 0.5*obj.L*sind(obj.theta); 0];
            obj.ria = -obj.rsa;
        end
        
        %method to output dimensions to .txt files.
        function outputDimensions(obj)
            fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/AnteriorLink.txt','w');
            fprintf(fileID,'"B"=%.6f\n',obj.B);
            fprintf(fileID,'"L"=%.6f\n',obj.L);
            fprintf(fileID,'"H"=%.6f\n',obj.H);
            fprintf(fileID,'"T"=%.6f\n',obj.T);
            fclose(fileID); 
        end
        
    end
end

