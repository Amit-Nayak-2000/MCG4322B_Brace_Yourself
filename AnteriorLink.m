classdef AnteriorLink
    %ANTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Properties
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        
        
        %Physical Properties
        m % Mass
        rho %Density of material
        I % Moment of inertia
        E % Elastic modulus
        SU %Ultimate Strength
        SY %Yield Strength
        
        
        %Dynamical Properties
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %Vector from centre of mass to superior joint
        rsa = [0;0;0];
        %Vector from centre of mass to inferior joint
        ria = [0;0;0];
        %theta, omega and alpha initially set to 0, but will have values in
        %k. 
        theta %Angle with respect to horizontal (x) 
        omega  = [0;0;0]; %Angular Velocity
        alpha  = [0;0;0]; %Angular acceleration
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity
        a = [0;0;0]; %Linear Acceleration
    end
    
    methods
        
    end
end

