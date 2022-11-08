%Simulation of Instantaneous Centre of Rotation of Brace

%User provided parameters
mass = 56.7; %kilograms
height = 1.73; %metres
thighdiameter = 0.1; %metres
calfdiameter = 0.08; %metres

%Thigh/Calf Length from Winters Segment Model
thighlength = (0.530 - 0.285)*height;
calflength = (0.285 - 0.0039)*height;


%Instantiate Objects
S = SuperiorLink;
A = AnteriorLink;
In = InferiorLink;
P = PosteriorLink;
T1 = TorsionalSpring;
T2 = TorsionalSpring;


%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2);

%Initialize Torsional Springs:
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};

syms Da Dp;
% assume(Da ~=0);
% assume(Dp ~=0);

ICRx=ones(1,75);
ICRy=ones(1,75);
Test_Params=ones(101,5);

Test_Params(1,:)=["Plot Num" "Superior L (m)" "Inferior L (m)" "Posterior L (m)" "Anterior L (m)"];

for j=1:11
    In.L=0.028+0.0022*j;
    for k=1:11
        A.L=0.043+0.0022*k;

        for i=1:75
         %Obtain biological kinematics of calf and thigh.
        kincalf = [kinematicsdata(i,16), kinematicsdata(i,17), kinematicsdata(i,18), 0, 0, 0; 
           kinematicsdata(i,19), kinematicsdata(i,20), kinematicsdata(i,21), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,13), kinematicsdata(i,14), kinematicsdata(i,15);];
       
        kinthigh = [kinematicsdata(i,26), kinematicsdata(i,27), kinematicsdata(i,28), 0, 0, 0; 
           kinematicsdata(i,29), kinematicsdata(i,30), kinematicsdata(i,31), 0, 0, 0;
           0, 0, 0, kinematicsdata(i,23), kinematicsdata(i,24), kinematicsdata(i,25);];
       
        %calculate kinematics
        Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2);

        ICR1 = Da*cosd(A.theta) + Dp*cosd(P.theta)+S.L*cosd(S.theta) == 0;
        ICR2 = Da*sind(A.theta) + Dp*sind(P.theta)+S.L*sind(S.theta) == 0;

        ICRsoln = solve([ICR1, ICR2], [Da, Dp]);

        ICRx(i) = double(ICRsoln.Da*cosd(A.theta));
        ICRy(i) = double(ICRsoln.Da*sind(A.theta));

        %calculate forces
        % Kinetic_Saggital(S,In,P,A, T1, T2);

        end
        
    plot_num=(j-1)*10+k;
        
    Test_Params(plot_num+1,:)= [plot_num S.L, In.L, P.L, A.L];
    
    plotICR_Iteration(ICRx,ICRy,j,k);
    end
end

writematrix(Test_Params,'C:\Users\rohan\University of Ottawa\Amit Nayak - MCG4322B Group 03\Rohan\ICR_iteration_2\ICR_Plot_Params.xls');