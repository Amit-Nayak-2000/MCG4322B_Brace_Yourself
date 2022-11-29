function []=plotICR(ICRx,ICRy)
%The plot shows the distance from the SA joint to the instantaneous center
%of rotation in the sagittal plane. It is assumed that the SA joint lines
%up roughly with the anterior side of the femoral condyles

figure
plot(ICRx,ICRy)
ylabel("Y distance from SA joint (m)");
xlabel("X distance from SA joint (m)");
title("ICR position for frames 1-70");

