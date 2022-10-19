classdef PosteriorLink < handle
    %POSTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Properties
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        T %Thickness
        
        %Physical Properties
        m % Mass
        rho = 8000; %Density of 304 stainless steel (kg/m^3)
        I % Moment of inertia
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa)
        
        
        %Dynamical Properties
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %Vector from superior joint (SP) to centre of mass
        rsp = [0;0;0];
        %Vector from inferior joint (IP) to centre of mass
        rip = [0;0;0];
        %omega and alpha initially set to 0, but will have values in k.  
        theta %Angle with respect to horizontal (x) 
        omega  = [0;0;0]; %Angular Velocity
        alpha  = [0;0;0]; %Angular acceleration
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity
        a = [0;0;0]; %Linear Acceleration
    end
    
    methods
        
        function obj = calculate_inertial_props(obj)
            volume = obj.B * obj.H * obj.T;
            
            obj.m = obj.rho * volume;
            
            obj.I = (1/12)*obj.m*obj.H^2;
        end
        
    end
end

