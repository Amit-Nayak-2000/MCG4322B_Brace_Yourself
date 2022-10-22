classdef TorsionalSpring
    %TORSIONALSPRING 
    %Contains essential properties of spring.
    %Dimensions, Material Properties, spring constant, etc...
    
    properties
        beta %resting angle
        C %No idea what this is...
        d 
        D
        E %Elastic Modulus
        Na %Active turns
        K %spring constant
        theta %spring deflection
    end
    
    methods
        function obj = calculateSpringConst(obj, mass)
            obj.K = 0.0022*mass; 
        end
        
        
    end
end

