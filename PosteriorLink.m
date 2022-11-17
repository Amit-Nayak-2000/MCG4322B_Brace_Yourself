classdef PosteriorLink < handle
    %POSTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    %and Forces.
    
    properties
        %Geometric Properties (m)
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        T %Thickness
        bolt_hole_diam
        
        %Physical Properties
        m % Mass (kg)
        rho = 8000; %Density of 304 stainless steel (kg/m^3)
        I % Moment of inertia (kg m^2)
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa)
        G = 74e9; %Shear modulus of 304 stainless steel (Pa)
        
        
        %Dynamical Properties
        %position vectors units are (m)
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %Vector from superior joint (SP) to centre of mass
        rsp = [0;0;0];
        %Vector from inferior joint (IP) to centre of mass
        rip = [0;0;0];
        theta %Angle with respect to horizontal-x (deg) 
        %omega and alpha initially set to 0, but will have values in k.
        omega  = [0;0;0]; %Angular Velocity (rad/s)
        alpha  = [0;0;0]; %Angular acceleration (rad/s^2)
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity (m/s)
        a = [0;0;0]; %Linear Acceleration (m/s^2)
        
        %Force Vectors
        F_sp = [0;0;0]; %(N)
        F_ip = [0;0;0]; %(N)
        
        %file names
        file
    end
    
    methods
        
        %Method to calculate mass and moment of inertia
        function obj = calculate_inertial_props(obj)
            volume = obj.B * obj.H * obj.T;
            
            %mass = density * volume.
            obj.m = obj.rho * volume;
            
            %thin bar moment of inertia.
            obj.I = (1/12)*obj.m*obj.H^2;
        end
        
        %Method to calculate vectors from joints to COM.
        function obj = calculateCOM(obj)
            %negative since theta angle starts at joint IP.
            obj.rip = [0.5*obj.L*cosd(obj.theta); 0.5*obj.L*sind(obj.theta); 0];
            obj.rsp = -obj.rip;
        end
        
        %method to output dimensions to .txt files.
        function outputDimensions(obj)
            fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/PosteriorLink.txt','w');
            fprintf(fileID,'"B"=%.6f\n',obj.B);
            fprintf(fileID,'"L"=%.6f\n',obj.L);
            fprintf(fileID,'"H"=%.6f\n',obj.H);
            fprintf(fileID,'"T"=%.6f\n',obj.T);
            fclose(fileID); 
        end
        
    end
end

