function [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, ZF, SF, mass)


%Parse Winters Data
WinterData = Parse_Winter_Data("Winter_Appendix_data_fixed.xlsx");
kinematicsdata = WinterData{3};

startframe = 28; %HCR %originally 28
endframe = 96; %Just Before next HCR %originally 96

%Arrays to store critical safety factors at each frame in gait cycle. 
%Links
SupSFArr = zeros(1 ,endframe - startframe + 1);
AntSFArr = zeros(1 ,endframe - startframe + 1);
PosSFArr = zeros(1 ,endframe - startframe + 1);
InfSFArr = zeros(1 ,endframe - startframe + 1);

%Springs
T1SFArr = zeros(1 ,endframe - startframe + 1);
T2SFArr = zeros(1 ,endframe - startframe + 1);

%Straps
VtSFArr = zeros(1 ,endframe - startframe + 1);
VcSFArr = zeros(1 ,endframe - startframe + 1);

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
    
    SupSFArr(dataindex) = SF.SF_sup;
    AntSFArr(dataindex) = SF.SF_ant;
    PosSFArr(dataindex) = SF.SF_pos;
    InfSFArr(dataindex) = SF.SF_inf;
    
    T1SFArr(dataindex) = SF.SF_TS1;
    T2SFArr(dataindex) = SF.SF_TS2;
    
    VtSFArr(dataindex) = SF.SF_VT;
    VcSFArr(dataindex) = SF.SF_VC;
    
    

%     %calculate safety factors and store in an array
    disp(i);
    
end


end

