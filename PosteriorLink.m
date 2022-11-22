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
        bearing_hole_diam = 0.008;
        bearing_depth = 0.0034;
        springarmholepos %MAKE SURE TO DEFINE THIS AFTER LOOP
        springarmholemaxd = 0.006;
        springarmholemind = 0.0034;
        armholeheadheight = 0.00165;
        
        %Physical Properties
        m % Mass (kg)
        rho = 2705; %Density of Aluminium 1060-O (kg/m^3)
        I % Moment of inertia (kg m^2)
        E = 68.9e9; % Elastic modulus of Aluminium 1060-O (Pa)
        SU = 55e6; %Ultimate Tensile Strength of Aluminium 1060-O (Pa)
        SY = 17e6; %Yield Strength of Aluminium 1060-O (Pa)
        SSY = 0.55*17e6; %Shear Yield Strength of Aluminium 1060-O (Pa)
        G = 26e9; %Shear modulus of Aluminium 1060-O (Pa)
        
        
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
            fprintf(fileID,'"bolt_hole_diameter"=%.6f\n', obj.bolt_hole_diam);
            fprintf(fileID,'"bearing_hole_diameter"=%.6f\n', obj.bearing_hole_diam);
            fprintf(fileID,'"bearing_depth"=%.6f\n', obj.bearing_depth);
            fprintf(fileID,'"spring_arm_hole_pos"=%.6f\n', obj.springarmholepos);
            fprintf(fileID,'"spring_arm_hole_max_diam"=%.6f\n', obj.springarmholemaxd);
            fprintf(fileID,'"spring_arm_hole_min_diam"=%.6f\n', obj.springarmholemind);
            fprintf(fileID,'"arm_hole_head_height"=%.6f\n', obj.armholeheadheight);
            fclose(fileID); 
        end
        
    end
end

