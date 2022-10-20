classdef AnteriorLink < handle
    %ANTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Properties
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        T %thickness
        
        
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
        %Vector from superior joint (SA) to centre of mass
        rsa = [0;0;0];
        %Vector from inferior joint (IA) to centre of mass
        ria = [0;0;0];
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
        
        function obj = calculateCOM(obj)
            obj.rsa = [0.5*obj.L*cosd(obj.theta); 0.5*obj.L*sind(obj.theta); 0];
            obj.ria = -obj.rsa;
        end
        
    end
end

