classdef Bearing < handle
    %BEARING
    %Contains essential properties of bearing.
    %Dimensions, Material Properties
    
    
    properties
        %Geometric Properties (m)
        ID %Inner diameter.
        OD %Outer diameter.
        
        %Physical Properties
        LC %Load capacity of the bearing.
        
    end
    
    methods
        %Method to intialize inner diameter and outer diameter of bearing. 
        function obj = initBearing(obj, innerdiameter, outerdiameter)
            obj.ID = innerdiameter; 
            obj.OD = outerdiameter;
        end
         
    end
    
end