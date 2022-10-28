classdef TorsionalSpring < handle
    %TORSIONALSPRING 
    %Helical Torsional Spring
    
    properties
        beta %Resting angle
        C %Spring Index
        d %Coil Diameter
        D %Mean Diameter
        E = 201e9; % Elastic modulus of SAE 1070 Carbon Steel 
        SU = 640e6;
        SY = 495e6;
        Na %Active turns
        K %Spring Rate
        theta %Deflection of Spring
        l1 %length to standoff/moment arm (Superior/Inferior link)
        l2 %length to standoff/moment arm (Anterior/Posterior link)
        
        Torque = [0;0;0];
    end
    
    methods
        function obj = initSpring(obj, mass, mainlink, sublink)
            obj.K = 0.0022*mass; 
            obj.l1 = 0.4*mainlink.L;
            obj.l2 = 0.4*sublink.L;
        end
        
        
    end
end

