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
        height%MAKE SURE TO CODE THIS LATER
        loop_diam
        L_major %sup or inf
        L_minor %ant or pos
        
        Torque = [0;0;0]; %(Nm)
    end
    
    methods
        %Method to intialize spring rate and lengths. 
        %called after GetInitKinematics
        function obj = initSpring(obj, mass, mainlink, sublink)
            obj.K = 5*0.0022*mass; %this is different 
            obj.l1 = 0.4*mainlink.L;
            obj.l2 = 0.4*mainlink.L;
            obj.beta = 180 - obj.theta0;
            obj.Nb = 4 + (obj.beta / 360);
            obj.D = 5.85E-03;
            obj.Na = obj.Nb + ((obj.l1 + obj.l2)/(3*pi*obj.D));
            obj.d = ((obj.K*64*obj.D*obj.Na)/obj.E)^(0.25);
            obj.C = obj.D/obj.d;
        end
        
        %Method to intialize spring rate and lengths. 
        %called after GetInitKinematics
        function obj = updateSpring(obj)
            obj.Na = obj.Nb + ((obj.l1 + obj.l2)/(3*pi*obj.D));
            obj.d = ((obj.K*64*obj.D*obj.Na)/obj.E)^(0.25);
            obj.C = obj.D/obj.d;
        end
        
        %method to output dimensions to .txt files.
        function outputDimensions(obj, springnum)
            if(springnum == 1)
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/spring_sa.txt','w');
            else
                fileID = fopen('../MCG4322B_Brace_Yourself/SOLIDWORKSTestDir/Equations/spring_ip.txt','w');
            end
            
            fprintf(fileID,'"D_coil"=%.6f\n',obj.D);
            fprintf(fileID,'"d_wire"=%.6f\n',obj.d);
            fprintf(fileID,'"Nb"=%.6f\n',obj.Nb);
            
            if(springnum == 1)
                fprintf(fileID,'"l_s_arm"=%.6f\n',obj.L_major);
                fprintf(fileID,'"l_a_arm"=%.6f\n',obj.L_minor);
            else
                fprintf(fileID,'"l_i_arm"=%.6f\n',obj.L_major);
                fprintf(fileID,'"l_p_arm"=%.6f\n',obj.L_minor);
            end
            
            fprintf(fileID,'"loop_diam"=%.6f\n',obj.loop_diam);
            
            fclose(fileID); 
        end
        
        
    end
end

