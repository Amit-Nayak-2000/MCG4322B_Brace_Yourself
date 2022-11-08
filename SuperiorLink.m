classdef SuperiorLink < handle
    %SUPERIORLINK 
    %Contains essential properties of link.
    %Dimensions, Material Properties, Position, Velocities, Acclerations
    %and Forces.
    
    properties
        %Geometric Dimensions of Link
        B1 % For B1 to H4, refer to definition of dimension figure in report.
        B2
        B3
        L
        H1
        H2
        H3
        H4
        T %Thickness
        bolt_hole_diam
        
        
        %Physical Properties
        m % Mass (kg)
        rho = 8000; %Density of 304 stainless steel (kg/m^3)
        I % Moment of inertia (kg m^2)
        E = 193e9; % Elastic modulus of 304 stainless steel (Pa)
        SU = 505e6; %Ultimate Tensile Strength of 304 stainless steel (Pa)
        SY = 215e6; %Yield Strength of 304 stainless steel (Pa)
        
        
        %Dynamical Properties
        %Position vectors units are (m).
        %vector for centre of mass with respect to thigh (initially 0)
        com = [0;0;0];
        %vector for centre of mass absolute (initially 0)
        com_abs = [0;0;0];
        %vector from centre of mass to anterior joint (joint SA)
        rsa = [0;0;0];
        %vector from centre of mass to posterior joint (joint SP)
        rsp = [0;0;0];
        %vector from centre of mass to thigh contact point for sum of
        %moments
        rst = [0;0;0];
        theta %Angle with respect to horizontal-x (deg)
        %omega and alpha initially set to 0, but will have values in k.
        omega  = [0;0;0]; %Angular Velocity (rad/s)
        alpha  = [0;0;0]; %Angular acceleration (rad/s^2)
        %v and a are initially set to 0, but will have values in i and j.
        v = [0;0;0]; %Linear Velocity (m/s)
        a = [0;0;0]; %Linear Acceleration (m/s^2)
        
        %Force Vectors
        F_t = [0;0;0]; %(N)
        F_sa = [0;0;0]; %(N)
        F_sp = [0;0;0]; %(N)
        
        %file names
        file
    end
    
    methods
        
        %Method to calculate COM and position vectors.
        function obj = calculateCOM(obj, thighlength)
            %COM calculation
            A(1) = obj.B1*obj.H1;
            A(2) = 0.5 * (obj.B1 + obj.B2) * (obj.H2 - obj.H1);
            A(3) = obj.B2 * (obj.H3 - obj.H2);
            A(4) = obj.B3 * (obj.H4 - obj.H3);
            
            x(1) = obj.B2 / 2;
            x(2) = obj.B2 / 2;
            x(3) = obj.B2 / 2;
            x(4) = obj.B3 / 2;
            
            y(1) = obj.H4 - (obj.H1 / 2);
            y(2) = (obj.H4 - obj.H1) - (obj.H2 - obj.H1) * (1/3) * ( (2*obj.B2 + obj.B1) / (obj.B2 + obj.B1));
            y(3) = (obj.H4 - obj.H3) + ((obj.H3 - obj.H2) / 2);
            y(4) = (obj.H4 - obj.H3) / 2;
            
            Xnum = 0;
            Xdenom = 0;
            Ynum = 0;
            Ydenom = 0;
            
            for i=1:4
                Xnum = Xnum + x(i)*A(i);
                
                Ynum = Ynum + y(i)*A(i);
                
                Xdenom = Xdenom + A(i);
                
                Ydenom = Ydenom + A(i);
            end
            
            Xcom = Xnum / Xdenom; %sum of X(i)A(i) / sum of A(i)
            Ycom = Ynum / Ydenom; %sum of Y(i)A(i) / sum of A(i)
            
            
            comx = (Xcom - obj.B2/2)*cosd(obj.theta) + (0.567*thighlength -(obj.H4-Ycom))*sind(obj.theta);
            comy = (Xcom - obj.B2/2)*sind(obj.theta) - (0.567*thighlength -(obj.H4-Ycom))*cosd(obj.theta);
            obj.com = [comx; comy; 0];
            
            %rsa & rsp calculations
            ry = obj.H4 - Ycom - (obj.H1 / 2); % y component
            rxa = (obj.B2 / 2) + (obj.L / 2) - Xcom; % x component to joint SA.
            rxp = abs((obj.B2 / 2) - (obj.L / 2) - Xcom); % x component to joint SP, need abs val since signs are handled below.
            
            obj.rsa = [ry*sind(obj.theta) + rxa*cosd(obj.theta); -ry*cosd(obj.theta) + rxa*sind(obj.theta); 0];
            obj.rsp = [ry*sind(obj.theta) - rxp*cosd(obj.theta); -ry*cosd(obj.theta) - rxp*sind(obj.theta); 0];
            
            %rst calculation
            obj.rst = [-Ycom*sind(obj.theta) + (obj.B3 - Xcom)*cosd(obj.theta); Ycom*cosd(obj.theta) + (obj.B3 - Xcom)*sind(obj.theta); 0];
            
            
            
        end
        
        function obj = calculate_inertial_props(obj)
            %calculate areas
            A(1) = obj.B1*obj.H1;
            A(2) = 0.5 * (obj.B1 + obj.B2) * (obj.H2 - obj.H1);
            A(3) = obj.B2 * (obj.H3 - obj.H2);
            A(4) = obj.B3 * (obj.H4 - obj.H3);
            
            volume = obj.T*(A(1) + A(2) + A(3) + A(4));
            %mass = density * volume
            obj.m = obj.rho*volume;
            
            %need these for distance between axes for parallel axis theorem
            x(1) = obj.B2 / 2;
            x(2) = obj.B2 / 2;
            x(3) = obj.B2 / 2;
            x(4) = obj.B3 / 2;
            y(1) = obj.H4 - (obj.H1 / 2);
            y(2) = (obj.H4 - obj.H1) - (obj.H2 - obj.H1) * (1/3) * ( (2*obj.B2 + obj.B1) / (obj.B2 + obj.B1));
            y(3) = (obj.H4 - obj.H3) + ((obj.H3 - obj.H2) / 2);
            y(4) = (obj.H4 - obj.H3) / 2;
            
            %calculate individual axis
            Xnum = 0;
            Xdenom = 0;
            Ynum = 0;
            Ydenom = 0;
            
            for i=1:4
                Xnum = Xnum + x(i)*A(i);
                
                Ynum = Ynum + y(i)*A(i);
                
                Xdenom = Xdenom + A(i);
                
                Ydenom = Ydenom + A(i);
            end
            
            Xcom = Xnum / Xdenom; %sum of X(i)A(i) / sum of A(i)
            Ycom = Ynum / Ydenom; %sum of Y(i)A(i) / sum of A(i)
            
            %masses of individual objects
            M(1) = obj.rho*obj.T*A(1);
            M(2) = obj.rho*obj.T*A(2);
            M(3) = obj.rho*obj.T*A(3);
            M(4) = obj.rho*obj.T*A(4);
            
            %mass moment of inertias of individual objects
            I(1) = (1/12)*M(1)*(obj.B1^2 + obj.H1^2);
            
            I(3) = (1/12)*M(3)*(obj.B2^2 + (obj.H3 - obj.H2)^2);
            
            I(4) = (1/12)*M(4)*(obj.B3^2 + (obj.H4 - obj.H3)^2);
            
            %radius of gyration calculation for trapezoid
            a = obj.B2;
            b = obj.B1;
            h = obj.H2 - obj.H1;
            rtrap = (1/12)*sqrt(2*(16*h^2*a*b + 4*h^2*b^2 + 4*h^2*a^2 + 3*a^4 + 6*a^2*b^2 + 6*a^3*b + 6*a*b^3 + 3*b^4) / (a + b)^2);
            
            I(2) = M(2) * rtrap^2;
            
            %using parallel axis theorem: I = Icom_i + m_i*d_i^2
            Ifinal = 0.0;
            for i=1:4
                Ifinal = Ifinal + I(i) + M(i)*((Xcom - x(i))^2 + (Ycom - y(i))^2);
            end
            
            obj.I = Ifinal;
            
            
            
            
        end
    end
end

