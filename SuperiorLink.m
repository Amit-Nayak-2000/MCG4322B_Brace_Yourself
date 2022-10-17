classdef SuperiorLink < handle
    %SUPERIORLINK 
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    
    properties
        %Geometric Dimensions of Link
        B1 % For B1 to H4, refer to dimension figure
        B2
        B3
        L
        H1
        H2
        H3
        H4
        
        
        %Physical Properties
        m % Mass
        rho %Density of material
        I % Moment of inertia
        E % Elastic modulus
        SU %Ultimate Strength
        SY %Yield Strength
        
        
        %Dynamical Properties
        %vector for centre of mass with respect to thigh (initially 0)
        com = [0;0;0];
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %vector from centre of mass to anterior joint
        rsa = [0;0;0];
        %vector from centre of mass to posterior joint
        rsp = [0;0;0];
        %vector from centre of mass to thigh contact point
        rst = [0;0;0];
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
        
        %TO BE TESTED
        function obj = calculateCOM(obj, thighlength)
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
            
            comx = (obj.B2/2 + Xcom)*cosd(obj.theta) + (0.567*thighlength -(obj.H4-Ycom))*sind(obj.theta);
            comy =  (obj.B2/2 + Xcom)*sind(obj.theta) - (0.567*thighlength -(obj.H4-Ycom))*cosd(obj.theta);
            
            obj.com = [comx; comy; 0];
        end
        
    end
end

