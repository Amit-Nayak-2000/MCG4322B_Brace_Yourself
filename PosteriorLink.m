classdef PosteriorLink < handle
    %POSTERIORLINK
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Properties
        L %Length from joint to joint.
        H %Total length of link.
        B %Base of link
        
        
        %Physical Properties
        m % Mass
        rho %Density of material
        I % Moment of inertia
        E % Elastic modulus
        SU %Ultimate Strength
        SY %Yield Strength
        
        
        %Dynamical Properties
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %Vector from centre of mass to superior joint
        rsp = [0;0;0];
        %Vector from centre of mass to inferior joint
        rip = [0;0;0];
        %theta, omega and alpha initially set to 0, but will have values in
        %k. 
        theta %Angle with respect to horizontal (x) 
        omega  = [0;0;0]; %Angular Velocity
        alpha  = [0;0;0]; %Angular acceleration
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity
        a = [0;0;0]; %Linear Acceleration
    end
    
    methods
        
        function obj = calculateCOM(obj, calflength)
            A(1) = obj.B1*obj.H1;
            A(2) = 0.5 * (obj.B1 + obj.B2) * (obj.H2 - obj.H1);
            A(3) = obj.B2 * (obj.H3 - obj.H2);
            A(4) = obj.B3 * (obj.H4 - obj.H3);
            
            x(1) = obj.B2 / 2;
            x(2) = obj.B2 / 2;
            x(3) = obj.B2 / 2;
            x(4) = obj.B3 / 2;
            
            y(1) = obj.H4 - (obj.H1 / 2);
            y(2) = (obj.H4 - obj.H2) + (obj.H2 - obj.H1) * (1/3) * ( (2*obj.B2 + obj.B1) / (obj.B2 + obj.B1));
            y(3) = (obj.H4 - obj.H3) + ((obj.H3 - obj.H2) / 2);
            y(4) = (obj.H4 - obj.H3) / 2;
            
            Xnum = 0;
            Xdenom = 0;
            Ynum = 0;
            Ydenom = 0;
            
            for i=1:4
                Xnum = Xnum + x(i)*A(i);
                
                Ynum = Ynum + y(i)*A(i);
                
                Xdenom = Xdenom + x(i);
                
                Ydenom = Ydenom + y(i);
            end
            
            Xcom = Xnum / Xdenom; %sum of X(i)A(i) / sum of X(i)
            Ycom = Ynum / Ydenom; %sum of X(i)A(i) / sum of X(i)
            
            comx = ((obj.B2/2 + Xcom) + (0.433*calflength -(obj.H4-Ycom))) * cosd(obj.theta);
            comy = (((obj.B2/2 + Xcom) + (0.433*calflength -(obj.H4-Ycom))) * sind(obj.theta));
            
            obj.com = [comx; comy; 0];
        end
        
    end
end

