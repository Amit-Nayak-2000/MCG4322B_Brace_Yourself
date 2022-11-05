classdef TorsionalSpring < handle
    %TORSIONALSPRING 
    %Helical Torsional Spring
    %Contains geometric, material and torque information about spring.
    
    properties
        theta0 %Resting angle 
        beta
        C %Spring Index
        d %Coil Diameter (m)
        D %Mean Diameter (m)
        E = 201e9; % Elastic modulus of SAE 1070 Carbon Steel (Pa)
        SU = 640e6; %Ultimate Tensile strength of SAE 1070 Carbon Steel (Pa)
        SY = 495e6; %Yield Strength of SAE 1070 Carbon Steel (Pa)
        Na %Active turns
        K %Spring Rate (Nm/deg kg)
        theta %Deflection of Spring (deg)
        l1 %length to standoff/moment arm (Superior/Inferior link) (m)
        l2 %length to standoff/moment arm (Anterior/Posterior link) (m)
        
        Torque = [0;0;0]; %(Nm)
    end
    
    methods
        %Method to intialize spring rate and lengths. 
        function obj = initSpring(obj, mass, mainlink, sublink)
            obj.K = 0.0022*mass; 
            obj.l1 = 0.4*mainlink.L;
            obj.l2 = 0.4*sublink.L;
        end
        
        
    end
end

