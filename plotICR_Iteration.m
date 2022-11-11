function []=plotICR_Iteration(ICRx,ICRy,j,k)
%The plot shows the distance from the SA joint to the instantaneous center
%of rotation in the sagittal plane. It is assumed that the SA joint lines
%up roughly with the anterior side of the femoral condyles

folderPath='C:\Users\rohan\University of Ottawa\Amit Nayak - MCG4322B Group 03\Rohan\ICR_iteration_2';
fileName=strcat(folderPath,'\Plot_',num2str((j-1)*10+k),'.png');


fig=figure();
plot(ICRx,ICRy)
ylabel("Y distance from SA joint (m)");
xlabel("X distance from SA joint (m)");
title("ICR position for frames 1-70");

saveas(fig,fileName);