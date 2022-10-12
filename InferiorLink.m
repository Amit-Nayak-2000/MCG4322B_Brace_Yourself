classdef InferiorLink
    %INFERIORLINK 
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

