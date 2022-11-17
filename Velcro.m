classdef Velcro < handle
    %VELCRO
    %Contains essential properties of velcro
    %Dimensions, Material Properties
    
    properties
        %Geometric Properties (m)
        L %Length of velcro
        W %Width of velcro      
        
        %Physical Properties
        G = 96526.6 % Shear modulus of velcro (Pa)
        
    end
    
    methods
        %Method to intialize inner diameter and outer diameter of bearing. 
        function obj = initVelcro(obj, length, width)
            obj.L = length; 
            obj.W = width;
        end
         
    end
end