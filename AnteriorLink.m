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
        theta %Angle with respect to horizontal (x)
        omega %Angular Velocity
        alpha %Angular acceleration
        comx %x position of centre of mass
        comy %x position of centre of mass
        vx %Linear velocity x-axis
        vy %Linear velocity x-axis
        ax %Linear Acceleration x-axis
        ay %Linear Acceleration y-axis
    end
    
    methods
        
    end
end

