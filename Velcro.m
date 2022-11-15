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
end