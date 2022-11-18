function [] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, ZF, SF, mass)


%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};

startframe = 29; %HCR %originally 28
endframe = 29; %Just Before next HCR %originally 96

SFarray = zeros(1 ,endframe - startframe + 1);

%Loop through the gait cycle
for i=startframe:endframe
    %index to store safety factor in arrays
    dataindex = i - startframe + 1;

    %Obtain biological kinematics of calf and thigh.
    kincalf = [kinematicsdata(i,16), kinematicsdata(i,17), kinematicsdata(i,18), 0, 0, 0; 
               kinematicsdata(i,19), kinematicsdata(i,20), kinematicsdata(i,21), 0, 0, 0;
               0, 0, 0, kinematicsdata(i,13), kinematicsdata(i,14), kinematicsdata(i,15);];

    kinthigh = [kinematicsdata(i,26), kinematicsdata(i,27), kinematicsdata(i,28), 0, 0, 0; 
               kinematicsdata(i,29), kinematicsdata(i,30), kinematicsdata(i,31), 0, 0, 0;
               0, 0, 0, kinematicsdata(i,23), kinematicsdata(i,24), kinematicsdata(i,25);];

    %calculate kinematics
    Kinematic_Modelling(S,In,P,A,kinthigh,kincalf, thighlength, calflength, T1, T2);

    %calculate forces
    Kinetic_Saggital(S,In,P,A,T1,T2);
    %this needs to work with our chosen frames...
    Kinetic_Frontal(S,In,P,ZF,i,mass);
    
    StressCalculations(S, In, A, P, T1, T2, VT, VC, Blt, Brng, SF);

    %calculate safety factors and store in an array
    SFarray(dataindex) = i; %this is just a placeholder, will be doing this once I get the SF.
    
end

%obtain minimum safety factors from arrays and return
min(SFarray);

end

