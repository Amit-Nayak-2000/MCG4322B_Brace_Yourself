classdef SuperiorLink
    %SUPERIORLINK 
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Dimensions of Link
        B1 % For B1 to H4, refer to dimension figure
        B2
        B3
        L
        H1
        H2
        H3
        H4
        
        
        %Physical Properties
        m % Mass
        rho %Density of material
        I % Moment of inertia
        E % Elastic modulus
        SU %Ultimate Strength
        SY %Yield Strength
        
        
        %Dynamical Properties
        %vector for centre of mass with respect to thigh (initially 0)
        com = [0;0;0];
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %vector from centre of mass to anterior joint
        rsa = [0;0;0];
        %vector from centre of mass to posterior joint
        rsp = [0;0;0];
        %theta, omega and alpha initially set to 0, but will have values in
        %k. 
        theta = [0;0;0]; %Angle with respect to horizontal (x) 
        omega  = [0;0;0]; %Angular Velocity
        alpha  = [0;0;0]; %Angular acceleration
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity
        a = [0;0;0]; %Linear Acceleration
    end
    
    methods
        
    end
end

