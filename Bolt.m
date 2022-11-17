classdef Bolt < handle
    %BOLT
    %Contains essential properties of bolt.
    %Dimensions, Material Properties
    %ADD Length calc for solidworks param
    
    properties
        %Geometric Properties (m)
        L %Length of bolt
        D %Diameter of bolt        
        
        %Physical Properties
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa) 
    end
    
    methods
        %Method to intialize and diameter of bolt. 
        function obj = initBolt(obj, diameter)
            obj.D = diameter;
        end
         
    end
end