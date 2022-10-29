function [] = StressCalculations(Superior,Inferior,Posterior,Anterior,Spring1,Spring2)
%STRESSCALCULATIONS
%THIS FUNCTION IS INCOMPLETE AND NOT TESTED.
%THIS FUNCTION WILL BE COMPLETED AT A LATER TIME.
%DO NOT RUN THIS FUNCTION
%% Stresses for Superior Link:
%Stress concentrations will be added via lookup table.
% %Saggital Plane:
% Superior.Bending_Saggital = SuperiorMoment * (Superior.B2/2) / Superior.Iz;
% %Frontal Plane:
% Superior.Bending_Frontal = SuperiorVVMoment * (Superior.t/2) / Superior.Ix;
% %Tensile Stress
% Superior.Tensile = SuperiorTensileForce / (Superior.B2*Superior.t);
% %Shear Stress
% Superior.Shear = SuperiorShearForce / (Superior.B2*Superior.t);

%% Stresses for Anterior Link:
%Stress concentrations will be added via lookup table.
% %Saggital Plane:
% Anterior.Bending_Saggital = AnteriorMoment * (Anterior.B/2) / Anterior.Iz;
% %Frontal Plane:
% Anterior.Bending_Frontal = AnteriorVVMoment * (Anterior.t/2) / Anterior.Ix;
% %Tensile Stress
% Anterior.Tensile = AnteriorTensileForce / (Anterior.B*Anterior.t);
% %Shear Stress
% Anterior.Shear = AnteriorShearForce / (Anterior.B*Anterior.t);

%% Stresses for Posterior Link:
%Stress concentrations will be added via lookup table.
% %Saggital Plane:
% Posterior.Bending_Saggital = PosteriorMoment * (Posterior.B/2) / Posterior.Iz;
% %Frontal Plane:
% Posterior.Bending_Frontal = PosteriorVVMoment * (Posterior.t/2) / Posterior.Ix;
% %Tensile Stress
% Posterior.Tensile = PosteriorTensileForce / (Posterior.B*Posterior.t);
% %Shear Stress
% Posterior.Shear = PosteriorShearForce / (Posterior.B*Posterior.t);


%% Stresses for Inferior Link:
%Stress concentrations will be added via lookup table.
%Saggital Plane:
% Inferior.Bending_Saggital = InferiorMoment * (Inferior.B2/2) / Inferior.Iz;
% %Frontal Plane:
% Inferior.Bending_Frontal = InferiorVVMoment * (Inferior.t/2) / Inferior.Ix;
% %Tensile Stress
% Inferior.Tensile = InferiorTensileForce / (Inferior.B2*Inferior.t);
% %Shear Stress
% Inferior.Shear = InferiorShearForce / (Inferior.B2*Inferior.t);

end

