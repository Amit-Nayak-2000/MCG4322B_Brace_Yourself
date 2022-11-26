%User provided parameters (WILL BE FROM GUI)
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
ZF = Z_forces;
VT = Velcro;
VC = Velcro;
Blt = Bolt;
Brng = Bearing;
SF = SafetyFactor;
Stoff1 = washerstandoff;
Stoff2 = washerstandoff;
Stoff3 = washerstandoff;
Wash = washerstandoff;
N1 = Fastener;
N2 = Fastener;
Hbase = Housing;
Hcover = Housing;

%Initialize dimensions based on Mass and Height
Init_System(mass, height, S, In, P, A, T1, T2,VT,VC,Blt,Brng, thighdiameter, calfdiameter);
%Initialize Torsional Springs:
verticaloffset = GetInitKinematics(S, In, A, P, T1, T2);
T1 = initSpring(T1, mass, S, A);
T2 = initSpring(T2, mass, In, P);


%boolean to check if safety factors are satisfied
safetyfactorsatisfied = 0;

%Parametrization Loop
while (safetyfactorsatisfied == 0)
    %loop thru the gait cycle and obtain safety factors
    disp("Computing Initial Calculations.");
    [SupSFArr,AntSFArr,PosSFArr,InfSFArr,T1SFArr,T2SFArr,VtSFArr,VcSFArr, BLSPSFArr, BLSASFArr, BLIASFArr, BLIPSFArr, BNSPFArr, BNSAFArr, BNIAFArr, BNIPFArr, percentage, biokneemoment, newkneemoment, totalPE, ICRx, ICRy, BSA, BIA, BSP, BIP] = GaitLoop(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, verticaloffset);
    
    %assume SF satisfied, then iterate thru each object.
    safetyfactorsatisfied = 1;
    
    %% Superior Link Parametrization
    disp("Optimizing Superior Link.");
    %Flag if superior link is satisfied WRT Safety Factor Range.
    SuperiorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinSup, SupIndex] = min(SupSFArr);
    while(SuperiorSatisfied == 0)
        if(MinSup > 4)
            %decrease thickness of link.
            if(S.T > 0.0039)
                S.T = 0.9*S.T;
            else
                S.B2 = 0.75*S.B2;
            end
            %recalculate inertial properties
            S = calculate_inertial_props(S);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27, verticaloffset);
            MinSup = SF.SF_sup;
        elseif(MinSup < 2)
            %increase thickness of link.
            S.B2 = 1.1*S.B2;
            %recalculate inertial properties
            S = calculate_inertial_props(S);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, SupIndex+27, verticaloffset);
            MinSup = SF.SF_sup;
        else
            %Superior Min SF is satisfied.
            SuperiorSatisfied = 1;
        end
    end
    
    
    %% Inferior Link Parametrization
    disp("Optimizing Inferior Link.");
    %Flag if inferior link is satisfied WRT Safety Factor Range.
    InferiorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinInf, InfIndex] = min(InfSFArr);
    while(InferiorSatisfied == 0)
        if(MinInf > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrease thickness of link.
            %decrease thickness of link.
            if(In.T > 0.0039)
                In.T = 0.9*In.T;
            else
                In.B2 = 0.75*In.B2;
            end
            %recalculate inertial properties
            In = calculate_inertial_props(In);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27, verticaloffset);
            MinInf = SF.SF_inf;
        elseif(MinInf < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increase thickness of link.
            In.B2 = 1.2*In.B2;
            %recalculate inertial properties
            In = calculate_inertial_props(In);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, InfIndex+27, verticaloffset);
            MinInf = SF.SF_inf;
        else
            %Inferior Min SF is satisfied.
            InferiorSatisfied = 1;
        end
    end
    
    %% Anterior Link Parametrization
    disp("Optimizing Anterior Link.");
    %Flag if anterior link is satisfied WRT Safety Factor Range.
    AnteriorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinAnt, AntIndex] = min(AntSFArr);
    while(AnteriorSatisfied == 0)
        if(MinAnt > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrease width of link.
            A.B = 0.75*A.B;
            %recalculate inertial properties
            A = calculate_inertial_props(A);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27, verticaloffset);
            MinAnt = SF.SF_ant;
        elseif(MinAnt < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increase width of link.
            A.B = 1.5*A.B;
            %recalculate inertial properties
            A = calculate_inertial_props(A);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, AntIndex+27, verticaloffset);
            MinAnt = SF.SF_ant;
        else
            %Inferior Min SF is satisfied.
            AnteriorSatisfied = 1;
        end
    end
    
    %% Posterior Link Parametrization
    disp("Optimizing Posterior Link.");
    %Flag if posterior link is satisfied WRT Safety Factor Range.
    PosteriorSatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinPos, PosIndex] = min(PosSFArr);
    while(PosteriorSatisfied == 0)
        if(MinPos > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrease width of link.
            P.B = 0.75*P.B;
            %recalculate inertial properties
            P = calculate_inertial_props(P);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27, verticaloffset);
            MinPos = SF.SF_pos;
        elseif(MinPos < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increase width of link.
            P.B = 1.5*P.B;
            %recalculate inertial properties
            P = calculate_inertial_props(P);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, PosIndex+27, verticaloffset);
            MinPos = SF.SF_pos;
        else
            %Inferior Min SF is satisfied.
            PosteriorSatisfied = 1;
        end
    end
    
    %% Thigh Velcro Parametrization
    disp("Optimizing Thigh Velcro.");
    %Flag if thigh velcro is satisfied WRT Safety Factor Range.
    VTsatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinVT, VTIndex] = min(VtSFArr);
    while(VTsatisfied == 0)
        if(MinVT > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VT.L = 0.95*VT.L;
            VT.W = 0.95*VT.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27, verticaloffset);
            MinVT = SF.SF_VT;
        elseif(MinVT < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increase thickness of link.
            VT.L = 1.15*VT.L;
            VT.W = 1.15*VT.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VTIndex+27, verticaloffset);
            MinVT = SF.SF_VT;
        else
            %Inferior Min SF is satisfied.
            VTsatisfied = 1;
        end
    end
    
    %% Calf Velcro Parametrization
    disp("Optimizing Calf Velcro.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    VCsatisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinVC, VCIndex] = min(VcSFArr);
    while(VCsatisfied == 0)
        if(MinVC > 4)
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrease thickness of link.
            VC.L = 0.95*VC.L;
            VC.W = 0.95*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27, verticaloffset);
            MinVC = SF.SF_VC;
        elseif(MinVC < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increase thickness of link.
            VC.L = 1.15*VC.L;
            VC.W = 1.15*VC.W;
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, VCIndex+27, verticaloffset);
            MinVC = SF.SF_VC;
        else
            %Inferior Min SF is satisfied.
            VCsatisfied = 1;
        end
    end
          
    %% TS1 Parametrization
    disp("Optimizing Torsional Spring 1.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    T1satisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinT1, T1Index] = min(T1SFArr);
    while(T1satisfied == 0)
        if(MinT1 > 4)
            %Design Constraint
            if(T1.Nb < 2)
                break;
            end
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrement Nb if possible.
            T1.Nb = T1.Nb - 1;
            %update Spring
            T1 = updateSpring(T1);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27, verticaloffset);
            MinT1 = SF.SF_TS1;
        elseif(MinT1 < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increment Nb.
            T1.Nb = T1.Nb + 1;
            %update Spring
            T1 = updateSpring(T1);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T1Index+27, verticaloffset);
            MinT1 = SF.SF_TS1;
        else
            %Inferior Min SF is satisfied.
            T1satisfied = 1;
        end
    end
    

    %% TS2 Parametrization
    disp("Optimizing Torsional Spring 2.");
    %Flag if calf velcro is satisfied WRT Safety Factor Range.
    T2satisfied = 0;
    %obtain minimum SF & index thru gait cycle.
    [MinT2, T2Index] = min(T2SFArr);
    while(T2satisfied == 0)
        if(MinT2 > 4)
            %Design Constraint
            if(T2.Nb < 2)
                break;
            end
            %Flag to recheck with entire gait cycle after has been optimized. 
%             safetyfactorsatisfied = 0;
            %decrement Nb if possible.
            T2.Nb = T2.Nb - 1;
            %update Spring
            T2 = updateSpring(T2);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27, verticaloffset);
            MinT2 = SF.SF_TS2;
        elseif(MinT2 < 2)
            %Flag to recheck with entire gait cycle after has been optimized.
%             safetyfactorsatisfied = 0;
            %increment Nb.
            T2.Nb = T2.Nb + 1;
            %update Spring
            T2 = updateSpring(T2);
            %update SF for critical frame
            IndividualFrameCheck(S,In,P,A,thighlength,calflength,T1,T2, VT, VC, Blt, Brng, Z_forces, SF, mass, T2Index+27, verticaloffset);
            MinT2 = SF.SF_TS2;
        else
            %Inferior Min SF is satisfied.
            T2satisfied = 1;
        end
    end
    
   %% Obtain Bolt and Bearing SF
   [MinBoltIA, boltindex] = min(BLIASFArr);
   MinBoltIP = min(BLIPSFArr);
   MinBoltSP = min(BLSPSFArr);
   MinBoltSA = min(BLSASFArr);
%    MinBrngSP = min(BNSPFArr);
%    MinBrngSA = min(BNSAFArr);
%    MinBrngIA = min(BNIAFArr);
%    MinBrngIP = min(BNIPFArr);

    % ALLOWABLE FORCE CALCULATION
    %BTW WE CAN SPEED THIS UP IF WE NEED
    avgSA = mean(BNSAFArr)*((BSA/2)/90)^(1/3);
    avgSP = mean(BNSPFArr)*((BSP/2)/90)^(1/3);
    avgIA = mean(BNIAFArr)*((BIA/2)/90)^(1/3);
    avgIP = mean(BNIPFArr)*((BIP/2)/90)^(1/3);
    
    L_10sa = Brng.L / ((Brng.C_10 / avgSA)^3);
    L_10sp = Brng.L / ((Brng.C_10 / avgSP)^3);
    L_10ia = Brng.L / ((Brng.C_10 / avgIA)^3);
    L_10ip = Brng.L / ((Brng.C_10 / avgIP)^3);

    C_sa = avgSA * (Brng.L / L_10sa)^(1/3);
    C_sp = avgSP * (Brng.L / L_10sp)^(1/3);
    C_ia = avgIA * (Brng.L / L_10ia)^(1/3);
    C_ip = avgIP * (Brng.L / L_10ip)^(1/3);

    % SAFETY FACTOR CALCULATION
    SF.sigma_bearingsa = Brng.C_10 / C_sa;
    SF.sigma_bearingsp = Brng.C_10 / C_sp;
    SF.sigma_bearingia = Brng.C_10 / C_ia;
    SF.sigma_bearingip = Brng.C_10 / C_ip;
    
   MinBrngSP = SF.sigma_bearingsp;
   MinBrngSA = SF.sigma_bearingsa;
   MinBrngIA = SF.sigma_bearingia;
   MinBrngIP = SF.sigma_bearingip;
   
end

%Output final safety factors to log file here...

%%
%Output solidworks dimensions 

%Anterior link
A.springarmholepos = 0.5*S.L;
A.outputDimensions();

%Posterior Link
P.springarmholepos = 0.5*In.L;
P.outputDimensions();

%Superior Link
S.springarmholepos = 0.4*S.L;
S.H_holes = 0.5*(S.B1-S.L);
S.outputDimensions();

%Inferior Link
In.springarmholepos = 0.4*In.L;
In.H_holes = 0.5*(In.B1-In.L);
In.outputDimensions();

%Springs
T1.L_arm=S.springarmholepos-0.5*T1.loop_diam*cosd(45);
T1.height=T1.d*T1.Nb*1.1; %maybe come back and change this
T1.outputDimensions(1);

T2.L_arm=In.springarmholepos-0.5*T2.loop_diam*cosd(45);
T2.height=T2.d*T2.Nb*1.1; %maybe come back and change this
T2.outputDimensions(2);

%standoff and washer
if(S.T>=In.T && T1.height>=T2.height)
    Stoff1.H=T1.height;
    Stoff2.H=T1.height+0.5*(S.T-In.T);
    
elseif(S.T<In.T && T1.height>=T2.height)
    Stoff1.H=T1.height+0.5*(In.T-S.T);
    Stoff2.H=T1.height;

elseif(S.T>=In.T && T1.height<T2.height)
    Stoff1.H=T2.height;
    Stoff2.H=T2.height+0.5*(S.T-In.T);
    
else
    Stoff1.H=T2.height+0.5*(In.T-S.T);
    Stoff2.H=T2.height;
end
    
Stoff1.ID=0.0032;
Stoff1.OD=0.0045;
Stoff1.H=T1.height;

Stoff1.outputDimensions(1);

Stoff2.ID=0.0032;
Stoff2.OD=0.0045;
Stoff2.H=2*T1.d; %maybe come back and change this

Stoff2.outputDimensions(2);

Stoff3.ID=0.0032;
Stoff3.OD=0.0045;
Stoff3.H=2*T1.d; %maybe come back and change this
Stoff3.outputDimensions(3);

Wash.ID=0.0032;
Wash.OD=0.006;
Wash.H=0.0006;
Wash.outputDimensions(4);

%Bearing
Brng.outputDimensions();

%Housing 

%Housing base
Hbase.stop_width = 0.005;
Hbase.height = S.H1-S.H_holes+A.H*abs(sind(A.theta0))-0.5*(A.H-A.L)+Hbase.gap+Hbase.stop_width;
Hbase.width = A.H+2*Hbase.stop_width+Hbase.gap+0.001;
%Hbase.width = Hbase.height + 2*Hbase.stop_width;
Hbase.inf_stop_x = Hbase.stop_width+A.L*abs(cosd(A.theta0))+0.5*(A.B)-In.L-0.5*(In.B1-In.L)+Hbase.gap-0.0005;
Hbase.superior_stop_x = Hbase.stop_width+Hbase.gap+0.5*A.B-0.5*(S.B1-S.L);
Hbase.superior_stop_angle = 180-atand((S.H2-S.H1)/(0.5*(S.B1-S.B2)));
Hbase.t1 = 0.005;
Hbase.t2 = A.T+P.T+S.T+2*Stoff1.H+0.0035;

if(Stoff1<=Stoff2)
    Hbase.t3 = P.T+Stoff1.H-0.001;
else
    Hbase.t3 = P.T+Stoff2.H-0.001;
end

Hbase.b1_x=Hbase.stop_width+Hbase.gap+0.5*A.B+S.L;
Hbase.b1_y=S.H1-S.H_holes+0.0015;
Hbase.bolt_dist=P.L;
Hbase.theta_p_init=180-P.theta0;
Hbase.bolt_hole_depth=Hbase.t1;
Hbase.cover_holes_diam=0.002;

Hbase.outputDimensions(1);

%Housing cover
Hcover.stop_width=Hbase.stop_width;
Hcover.height=Hbase.height;
Hcover.width=Hbase.width;
Hcover.inf_stop_x=Hbase.inf_stop_x;
Hcover.superior_stop_x=Hbase.superior_stop_x;
Hcover.superior_stop_angle=Hbase.superior_stop_angle;
Hcover.t1=Hbase.t1;

if(Stoff1<=Stoff2)
    Hcover.t2 = A.T+Stoff1.H+0.0035-0.001;
else
    Hcover.t2 = A.T+Stoff2.H+0.0035-0.001;
end

Hcover.cover_holes_diam=0.0024;

Hcover.outputDimensions(2);

%Nut
%Link-spring nut
N1.thread_height=0.0018;
N1.outputDimensions(1);

%interlink nut
N2.height=0.004;
N2.thread_height=0.00333;
N2.outputDimensions(2);

%Bolt
Blt.D=0.003;

%Link-Spring bolt
if(A.T>P.T)
    Blt.L=(ceil((A.T+Wash.H+N1.thread_height)*1000)+1)/1000;
else
    Blt.L=(ceil((P.T+Wash.H+N1.thread_height)*1000)+1)/1000;
end

Blt.outputDimensions(1);

%SA bolt
Blt.L=(ceil((A.T+Stoff1.H+S.T+N2.height)*1000)+1)/1000;
Blt.outputDimensions(2);

%SP bolt
Blt.L=(ceil((P.T+Stoff1.H+S.T+Hbase.t1)*1000))/1000;
Blt.outputDimensions(3);

%IA bolt
Blt.L=(ceil((A.T+Stoff2.H+In.T+N2.height)*1000)+1)/1000;
Blt.outputDimensions(4);

%IP bolt
Blt.L=(ceil((P.T+Stoff2.H+In.T+Hbase.t1)*1000))/1000;
Blt.outputDimensions(5);

%Velcro
%Thigh Velcro
VT.Loop_D=0.008;
VT.t=0.001;
VT.fold_back_L=0.5*VT.L;

VT.outputDimensions(1);

%Calf Velcro
VC.Loop_D=0.008;
VC.t=0.001;
VC.fold_back_L=0.5*VC.L;

VC.outputDimensions(2);

