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
        Nb %body turns
        Na %Active turns
        K %Spring Rate (Nm/deg kg)
        theta %Deflection of Spring (deg)
        l1 %length to standoff/moment arm (Superior/Inferior link) (m)
        l2 %length to standoff/moment arm (Anterior/Posterior link) (m)
        
        Torque = [0;0;0]; %(Nm)
    end
    
    methods
        %Method to intialize spring rate and lengths. 
        %called after GetInitKinematics
        function obj = initSpring(obj, mass, mainlink, sublink)
            obj.K = 0.0022*mass; 
            obj.l1 = 0.4*mainlink.L;
            obj.l2 = 0.4*mainlink.L;
            obj.beta = 180 - obj.theta0;
            obj.Nb = 3 + (obj.beta / 360);
            obj.D = 5.85E-03;
            obj.Na = obj.Nb + ((obj.l1 + obj.l2)/(3*pi*obj.D));
            obj.d = ((obj.K*64*obj.D*obj.Na)/obj.E)^(0.25);
        end
        
        
    end
end

